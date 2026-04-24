# PLAN.md — hebstr Quarto extension

## Contexte

Extension Quarto multiformat (html, typst, docx) extraite du template `hebstr-template` précédemment dupliqué dans chaque projet `~/Documents/pro/m2/m2_dm*`.

Objectif : **une seule source de vérité** pour le thème, installée dans chaque projet via `quarto add <path>`, repos projet restant indépendants.

Source d'origine : `_extensions/hebstr-template/` de `m2_dm3` (la version la plus à jour — contient la suppression de `background-color: red;` L.214 de `theme.scss`, mtime `janv. 16 15:22`).

## État actuel (niveau 1 — extension locale utilisable)

Emplacement : `~/Documents/pro/packages/quarto-templates/hebstr/`

Arborescence :

```
hebstr/                               ← racine repo
└── _extensions/
    └── hebstr/                       ← l'extension elle-même
        ├── _extension.yml            (title: hebstr, version: 0.9.0)
        ├── theme.scss
        └── resources/
            ├── chazard.dotx
            ├── code.tmTheme
            ├── fonts.css
            ├── fonts/ (Luciole + FiraCode, woff + woff2)
            └── template.typ
```

`_extension.yml` déjà multiformat avec clé `common` :
- `common` : lang fr, number-sections, toc, crossref, knitr defaults
- `html` : embed-resources, theme.scss, fonts.css, grid custom, html-math-method plain
- `typst` : mainfont Luciole, include-in-header template.typ
- `docx` : reference-doc chazard.dotx

## Divergences connues dans les projets m2-dm*

Chacun a sa copie de `_extensions/hebstr-template/`. Divergences au 2026-04-24 :

| Projet  | theme.scss                          | _extension.yml                        |
|---------|-------------------------------------|---------------------------------------|
| m2_dm1  | baseline (contient `background-color: red;` debug L.214) | baseline avec `html-math-method: plain` |
| m2_dm2  | identique à dm1                     | identique à dm1                       |
| m2_dm3  | **SANS** ligne debug red (pris comme source) | baseline                              |
| m2_dm4  | baseline (contient la ligne red)    | **SANS** `html-math-method: plain` L.38 |

Décision à prendre pour dm4 : intégrer ou non la suppression de `html-math-method: plain` dans l'extension centrale.

## Roadmap

### Niveau 1 — extension locale ✅ fait

- [x] Copier hebstr-template dm3 → emplacement central
- [x] Renommer `title: hebstr-template` → `title: hebstr` dans `_extension.yml`
- [x] Restructurer en `hebstr/_extensions/hebstr/` (convention Quarto)
- [ ] Initialiser git dans `packages/quarto-templates/hebstr/` (à faire par l'utilisateur)
- [ ] Tagger `v0.9.0` pour marquer l'état extrait de dm3

### Niveau 2 — migrer les projets m2-dm*

Pour chaque projet (commencer par dm3 = le plus safe) :

1. `cd ~/Documents/pro/m2/m2_dmN`
2. Supprimer l'ancienne extension : `rm -rf _extensions/hebstr-template`
3. Installer la nouvelle : `quarto add ~/Documents/pro/packages/quarto-templates/hebstr --no-prompt`
4. Greps à faire et à corriger (le nom du format change) :
   - `rg "hebstr-template" --type yaml`
   - `rg "hebstr-template" -g "*.qmd"`
   - Remplacer `hebstr-template-html` → `hebstr-html`, idem `-typst`, `-docx`
5. `quarto render` et vérifier le rendu visuel
6. Décision sur dm4 : intégrer `html-math-method: plain` supprimé ou pas

### Niveau 3 — publication GitHub (plus tard)

Quand l'extension est stable et que tu veux un accès cross-machine / public :

- [ ] Créer repo GitHub `hebstr/quarto-hebstr` (ou nom final décidé)
- [ ] Ajouter `README.md` (usage, exemples, captures)
- [ ] Ajouter `LICENSE` (MIT ou CC-BY)
- [ ] Créer `example.qmd` + `_quarto.yml` de démo
- [ ] Ajouter CI GitHub Actions pour rendre l'exemple et publier gh-pages
- [ ] Tagger `v1.0.0` à la première release publique
- [ ] Bascule utilisateur : `quarto add hebstr/quarto-hebstr` au lieu du chemin local

## Décisions prises dans la conversation précédente

- **Naming** : extension s'appelle `hebstr` (pas `simple-html`, pas `hebstr-html`). Repo = `quarto-hebstr` quand il sera sur GitHub (préfixe `quarto-` = convention GitHub des org Quarto).
- **Une seule extension multiformat** (html + typst + docx) plutôt que trois extensions séparées — parce que le doc Quarto documente explicitement la clé `common` pour ce cas, et que les fontes (Luciole, FiraCode) sont partagées entre formats.
- **Quarto Brand écarté pour l'instant** : experimental, ne couvre pas DOCX (officiellement formats supportés = html, dashboard, revealjs, typst). Réexaminable plus tard en couche `_brand.yml` override dans les projets consommateurs.

## Références

- [Quarto — Creating Format Extensions](https://quarto.org/docs/extensions/formats.html)
- [Quarto — Distributing Extensions](https://quarto.org/docs/extensions/distributing.html)
- [Quarto — Managing Extensions](https://quarto.org/docs/extensions/managing.html)
- [Quarto — Brand.yml](https://quarto.org/docs/authoring/brand.html) (pour info, écarté pour l'instant)
- Exemples de structure canonique : [quarto-ext/fontawesome](https://github.com/quarto-ext/fontawesome), [quarto-ext/lightbox](https://github.com/quarto-ext/lightbox), [quarto-journals/acm](https://github.com/quarto-journals/acm)

## Ouvertures / questions en suspens

- Nom final du format : `hebstr-html` ou autre ? (Quarto génère `<title>-<format>` par défaut)
- `README.md` minimal à rédiger dès maintenant ou attendre niveau 3 ?
- Ajouter `example.qmd` tout de suite permettrait de tester le render sans dépendre d'un projet m2-dm — utile pour valider les modifs sans risque
