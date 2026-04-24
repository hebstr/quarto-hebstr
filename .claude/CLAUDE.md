
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

`hebstr` is a **Quarto multi-format extension** (html + typst + docx), packaged as a single source of truth for a theme that was previously duplicated under `_extensions/hebstr-template/` in every `~/Documents/pro/m2/m2_dm*` project. Downstream projects are meant to install it locally via:

```bash
quarto add ~/Documents/pro/packages/quarto-templates/hebstr --no-prompt
```

The repo contains **no `.qmd` test document of its own** — renders are validated by installing the extension into a consumer project (e.g. `m2_dm3`) and running `quarto render` there.

See [PLAN.md](PLAN.md) for roadmap (levels 1/2/3), migration steps for `m2_dm*` projects, known divergences across projects, and open decisions (e.g. `html-math-method: plain` for dm4, final format name).

## Layout

```
hebstr/                      ← repo root (not yet a git repo, see PLAN L.57)
├── .claude/                 ← PLAN.md, CLAUDE.md, memory
└── _extensions/
    └── hebstr/              ← the Quarto extension itself
        ├── _extension.yml   ← multi-format declaration (common/html/typst/docx)
        ├── theme.scss       ← HTML theme (Bootstrap/Bootswatch SCSS)
        └── resources/
            ├── template.typ ← Typst preamble (included via include-in-header)
            ├── chazard.dotx ← DOCX reference doc
            ├── code.tmTheme ← TextMate code theme (used by Typst raw blocks)
            ├── fonts.css    ← @font-face declarations for HTML
            └── fonts/       ← Luciole + FiraCode (woff + woff2)
```

The nested `hebstr/_extensions/hebstr/` structure is the Quarto convention for distributable extensions — do **not** flatten it.

## Architecture — multi-format via a single `_extension.yml`

`_extension.yml` uses the Quarto `common:` key (documented for extensions that target multiple formats) to share defaults (`lang: fr`, `toc`, `crossref`, knitr chunk options) across `html`, `typst`, `docx`. Each per-format block then adds format-specific settings.

Per-format resource wiring — keep these in sync if you rename/move files:

| Format | Resources referenced from `_extension.yml` |
|--------|-----|
| html   | `theme.scss`, `resources/fonts.css`, Luciole/FiraCode via `fonts.css`, `lightbox`, custom `grid` widths |
| typst  | `mainfont: Luciole` + `font-paths: resources/fonts`, `include-in-header: resources/template.typ` |
| docx   | `reference-doc: resources/chazard.dotx` |

When a consumer document declares a format, Quarto generates the format name as `<title>-<format>` → `hebstr-html`, `hebstr-typst`, `hebstr-docx`. This is why the `m2_dm*` migration must rewrite `hebstr-template-html` → `hebstr-html` across `.qmd` and `_quarto.yml` files.

## Known inconsistency to fix

[resources/template.typ:62](_extensions/hebstr/resources/template.typ#L62) still reads:

```typst
#set raw(theme: "_extensions/hebstr-template/resources/code.tmTheme")
```

This path is the **old** extension name (`hebstr-template`) and is a relative path out of the installed extension location — it will not resolve in consumer projects that install `hebstr` under `_extensions/hebstr/`. Fix before tagging v1.0 or before migrating `m2_dm*` projects. Verify the correct reference style for Typst `#set raw(theme: …)` when bundled inside a Quarto extension (the resource lookup rules differ between render-from-source and installed-extension contexts).

## Common tasks

No build/test/lint here — this is a static theme package. Meaningful operations all happen in consumer projects:

```bash
# Install into a consumer project (local path)
cd ~/Documents/pro/m2/m2_dmN
quarto add ~/Documents/pro/packages/quarto-templates/hebstr --no-prompt

# Render to validate
quarto render                       # all formats declared in _quarto.yml
quarto render path/to/doc.qmd --to hebstr-html
quarto render path/to/doc.qmd --to hebstr-typst
quarto render path/to/doc.qmd --to hebstr-docx

# Find residual references to the old extension name after migration
rg "hebstr-template" --type yaml
rg "hebstr-template" -g "*.qmd"
```

When editing the theme, render a consumer doc in all three target formats — SCSS changes can render fine in HTML while Typst/DOCX are unaffected, and vice versa. Do not assume parity.

## Versioning & git

- Repo is **not yet a git repo** (see PLAN L.57 — user handles `git init` and tags).
- Current version: `0.9.0` (extracted-from-dm3 state). `v1.0.0` is reserved for the first public GitHub release (level 3 in PLAN.md).
- The user manages all git operations — never run `git commit/add/push/tag/branch/merge/rebase` from here.

## Editing conventions specific to this repo

- The extension ships fonts as `.woff` + `.woff2` pairs under `resources/fonts/`. Keep both — `.woff2` is the primary, `.woff` is the fallback for the CSS `@font-face` `src:` list in `fonts.css`.
- French content (`lang: fr`, `published-title: "dernière mise à jour"`, `tbl-title: "Tableau"`): preserve diacritics exactly.
- SCSS custom properties under `:root` in `theme.scss` are the knobs consumers will most likely want to override downstream — keep them named and grouped rather than inlining values into selectors.
