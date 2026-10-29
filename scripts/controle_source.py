"""Contrôle de la source Typst d'un produit : point-virgule avalé.

En Typst, un « ; » collé juste après une expression intégrée au texte (#f(…), #f[…], #x.y(…), #x, #if … [ ] …)
termine l'expression et disparaît du PDF, sans avertissement : « #res("EX11"); suite » s'affiche « … suite ».
La forme correcte est « #res("EX11")\\; suite ». Ce module lit la source avec les règles de mode de Typst
(texte, code, maths) pour ne signaler que les « ; » réellement avalés en mode texte ou maths :
- ignorés : instructions #let, #set, #show, #import, #include, #return (leur « ; » est un terminateur voulu),
  le code entre { } et ( ), les chaînes, commentaires, blocs bruts (`…`), liens http(s)://, « \\; » ;
- admis : « ; » nécessaire pour clore l'expression, c'est-à-dire suivi directement de « ( », « [ », « .x », ou
  d'une lettre ou d'un chiffre après un nom (« #sym.space.nobreak;h ») : sans lui, la suite serait lue comme
  appartenant à l'expression (usage documenté de Typst).

Usage direct : python3 scripts/controle_source.py fichier.typ [fichier.typ …]   (code 1 si un cas est trouvé)
Appelé par build.py sur produits/<CODE>/src/*.typ avant toute compilation.
"""
import argparse
import re
import sys
from pathlib import Path

from outillage_commun import ErreurOutillage, lancer, reglage_entier, relatif

# Mots-clés de Typst (syntaxe du langage, pas des réglages).
INSTRUCTIONS = {"let", "set", "show", "import", "include", "return"}  # « ; » final voulu
BLOCS_SUITE = {"if": "else", "for": None, "while": None}  # expressions à corps entre [ ] ou { }
IDENT = re.compile(r"[A-Za-z_][A-Za-z0-9_-]*")
LIEN = re.compile(r"https?://")
SUITE_IDENT = re.compile(r"[A-Za-z0-9_-]")
FIN_LIEN = re.compile(r"[^\s\]<>\"]*")


class _Lecteur:
    """Parcours récursif de la source : texte (markup), code, maths. Note les « ; » avalés."""

    def __init__(self, texte):
        self.s, self.n, self.cas = texte, len(texte), []

    # --- éléments communs --------------------------------------------------------------
    def _commentaire(self, i):
        """Fin d'un commentaire commençant en i (// ou /* */ imbricables), ou None."""
        s = self.s
        if s.startswith("//", i):
            j = s.find("\n", i)
            return self.n if j < 0 else j
        if s.startswith("/*", i):
            prof, j = 1, i + 2
            while j < self.n and prof:
                if s.startswith("/*", j):
                    prof, j = prof + 1, j + 2
                elif s.startswith("*/", j):
                    prof, j = prof - 1, j + 2
                else:
                    j += 1
            return j
        return None

    def _brut(self, i):
        """Bloc brut `…` ou ```…``` commençant en i : position après sa fin."""
        s, j = self.s, i
        while j < self.n and s[j] == "`":
            j += 1
        nb = j - i
        if nb == 2:  # `` : brut vide
            return j
        fin = s.find("`" * nb, j)
        return self.n if fin < 0 else fin + nb

    def _chaine(self, i):
        """Chaîne "…" commençant en i : position après le guillemet fermant."""
        s, j = self.s, i + 1
        while j < self.n and s[j] != '"':
            j += 2 if s[j] == "\\" else 1
        return j + 1

    # --- modes ---------------------------------------------------------------------------
    def texte(self, i, fermant=None):
        """Mode texte jusqu'au « ] » fermant (bloc de contenu) ou la fin ; position après le fermant."""
        s = self.s
        while i < self.n:
            c = s[i]
            if c == "\\":
                i += 2
            elif c == fermant:
                return i + 1
            elif c == "[":  # crochets équilibrés dans le texte d'un bloc de contenu
                i = self.texte(i + 1, "]")
            elif c == "`":
                i = self._brut(i)
            elif c == "$":
                i = self.maths(i + 1)
            elif c == "#":
                i = self.integre(i + 1)
            elif c == "h" and LIEN.match(s, i):
                i = FIN_LIEN.match(s, i).end()
            else:
                fin = self._commentaire(i) if c == "/" else None
                i = fin if fin is not None else i + 1
        return i

    def maths(self, i):
        """Mode maths jusqu'au « $ » fermant ; position après."""
        s = self.s
        while i < self.n:
            c = s[i]
            if c == "\\":
                i += 2
            elif c == "$":
                return i + 1
            elif c == '"':
                i = self._chaine(i)
            elif c == "#":
                i = self.integre(i + 1)
            else:
                fin = self._commentaire(i) if c == "/" else None
                i = fin if fin is not None else i + 1
        return i

    def code(self, i, fermant, arret_ligne=False):
        """Mode code jusqu'au fermant « ) » ou « } » (position après), ou, si arret_ligne, jusqu'au saut de ligne
        ou au « ; » de profondeur 0 (instruction intégrée au texte ; position du saut de ligne / après le « ; »)."""
        s = self.s
        while i < self.n:
            c = s[i]
            if fermant and c == fermant:
                return i + 1
            if arret_ligne and c == "\n":
                return i
            if arret_ligne and c == ";":
                return i + 1
            if arret_ligne and c == "]":  # fin du bloc de contenu englobant
                return i
            if c == '"':
                i = self._chaine(i)
            elif c == "`":
                i = self._brut(i)
            elif c == "(":
                i = self.code(i + 1, ")")
            elif c == "{":
                i = self.code(i + 1, "}")
            elif c == "[":
                i = self.texte(i + 1, "]")
            elif c == "$":
                i = self.maths(i + 1)
            else:
                fin = self._commentaire(i) if c == "/" else None
                i = fin if fin is not None else i + 1
        return i

    # --- expression intégrée (après #) ---------------------------------------------------
    def _blocs(self, i, suite):
        """Corps d'un #if / #for / #while : code jusqu'au premier bloc [ ] ou { } de profondeur 0,
        puis « else » éventuel (if). Position après la construction entière."""
        s = self.s
        while i < self.n and s[i] not in "[{\n":
            if s[i] == '"':
                i = self._chaine(i)
            elif s[i] == "(":
                i = self.code(i + 1, ")")
            else:
                i += 1
        if i >= self.n or s[i] == "\n":
            return i
        i = self.texte(i + 1, "]") if s[i] == "[" else self.code(i + 1, "}")
        if suite:
            m = re.compile(r"[ \t]*" + suite + r"\b[ \t]*").match(s, i)
            if m:
                j, mot = m.end(), IDENT.match(s, m.end())
                if mot and mot.group(0) == "if":  # else if …
                    return self._blocs(mot.end(), suite)
                return self._blocs(j, None) if j < self.n and s[j] in "[{" else i
        return i

    def integre(self, i):
        """Expression intégrée commençant en i (juste après #) ; note un « ; » avalé ; position après."""
        s, debut = self.s, i - 1
        m = IDENT.match(s, i)
        if m:
            mot = m.group(0)
            if mot in INSTRUCTIONS:
                return self.code(m.end(), None, arret_ligne=True)
            if mot in BLOCS_SUITE:
                i = self._blocs(m.end(), BLOCS_SUITE[mot])
                return self._apres(debut, i)
            if mot == "context":
                j = m.end()
                while j < self.n and s[j] in " \t":
                    j += 1
                return self.integre(j) if j < self.n and s[j] not in "\n" else j
            i = m.end()
        elif i < self.n and s[i] in "([{\"":
            c = s[i]
            i = (self.code(i + 1, ")") if c == "(" else self.code(i + 1, "}") if c == "{"
                 else self.texte(i + 1, "]") if c == "[" else self._chaine(i))
        else:
            return i  # « # » isolé : rien à suivre
        # suites : .champ, (arguments), [contenu]
        while i < self.n:
            if s[i] == "(":
                i = self.code(i + 1, ")")
            elif s[i] == "[":
                i = self.texte(i + 1, "]")
            elif s[i] == "." and IDENT.match(s, i + 1):
                i = IDENT.match(s, i + 1).end()
            else:
                break
        return self._apres(debut, i)

    def _apres(self, debut, i):
        """Note le cas si un « ; » suit directement l'expression [debut, i), sauf s'il sert à la clore."""
        s = self.s
        if i < self.n and s[i] == ";":
            suivant = s[i + 1:i + 2]
            voulu = (suivant in ("(", "[") or (suivant == "." and IDENT.match(s, i + 2))
                     or (SUITE_IDENT.match(s[i - 1]) and SUITE_IDENT.match(suivant)))
            if not voulu:
                self.cas.append((debut, i))
            return i + 1
        return i


def points_virgules_avales(texte):
    """[(ligne, colonne, expression, position du « ; »)] des « ; » avalés dans une source Typst (lignes depuis 1)."""
    lecteur = _Lecteur(texte)
    lecteur.texte(0)
    cas = []
    for debut, pv in lecteur.cas:
        ligne = texte.count("\n", 0, pv) + 1
        colonne = pv - (texte.rfind("\n", 0, pv) + 1) + 1
        cas.append((ligne, colonne, texte[debut:pv], pv))
    return cas


def _extrait(texte, pv, largeur):
    """Contexte d'une ligne autour du « ; » en pv : (avant, après), coupés à `largeur` caractères."""
    debut_ligne = texte.rfind("\n", 0, pv) + 1
    fin_ligne = texte.find("\n", pv)
    fin_ligne = len(texte) if fin_ligne < 0 else fin_ligne
    avant, apres = texte[debut_ligne:pv], texte[pv + 1:fin_ligne]
    avant = ("…" + avant[-largeur:]) if len(avant) > largeur else avant
    apres = (apres[:largeur] + "…") if len(apres) > largeur else apres
    return avant.lstrip(), apres.rstrip()


def controler_fichiers(fichiers):
    """Messages d'erreur (un par cas) pour une liste de sources .typ ; liste vide si tout va bien."""
    largeur = reglage_entier("controle_source_extrait_car")
    messages = []
    for f in fichiers:
        texte = Path(f).read_text(encoding="utf-8")
        for ligne, colonne, expr, pv in points_virgules_avales(texte):
            avant, apres = _extrait(texte, pv, largeur)
            expr_courte = expr if len(expr) <= largeur else expr[:largeur] + "…"
            messages.append(
                f"{relatif(Path(f).resolve())}:{ligne}:{colonne} : « ; » avalé par Typst après {expr_courte}"
                f" (absent du PDF)\n    extrait    : {avant};{apres}\n    correction : {avant}\\;{apres}")
    return messages


def verifier(fichiers):
    """Lève ErreurOutillage si une source contient un « ; » avalé."""
    messages = controler_fichiers(fichiers)
    if messages:
        raise ErreurOutillage(
            f"{len(messages)} point(s)-virgule(s) avalé(s) dans la source Typst (écrire « \\; » après l'appel) :\n"
            + "\n".join(messages))


def main():
    ap = argparse.ArgumentParser(description="Cherche les « ; » avalés par Typst dans des sources .typ.")
    ap.add_argument("fichiers", nargs="+", help="sources Typst")
    a = ap.parse_args()
    for f in a.fichiers:
        if not Path(f).is_file():
            raise ErreurOutillage(f"source introuvable : {f}")
    verifier(a.fichiers)
    print(f"{len(a.fichiers)} source(s) sans point-virgule avalé.")


if __name__ == "__main__":
    lancer(main)
