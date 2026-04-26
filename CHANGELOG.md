# Changelog

## [0.10.0] — 2026-04-26

### Added

- `README.md`, `LICENSE.md` (MIT), `.gitignore`.
- Self-contained `example.qmd` (HTML; Typst and DOCX planned), plus
  `scripts/demo_penguins.R` for the externalised-script demo.
- Bundled font licences (Luciole CC-BY 4.0, Fira Code OFL 1.1).
- Embedded [`mcanouil/code-window`](https://github.com/mcanouil/quarto-code-window)
  (HTML + Typst) and inlined `add-code-files` filter under `filters/`.
- SCSS custom properties for code-window chrome and surface/caption colours.

### Changed

- **Breaking**: extension renamed `hebstr-template` → `hebstr`; resource layout
  flattened (`template.typ`, `code.tmTheme`, `template.dotx` at extension root,
  fonts under `fonts/`); Typst raw theme path fixed accordingly.
- **Breaking**: `lang` and `published-title` removed from `common:` — consumers
  declare their own language.
- `quarto-required` bumped to `>=1.9.36` (matches the embedded `mcanouil/code-window` 1.1.5); `tbl-title` neutralised to `"Table"`.
- HTML: `page-layout: full`, wider `gutter-width`, `code-copy: always`.
- Theme: code-filename block restyled to match code-window; system font
  fallbacks added with `!default` for consumer overrides; code-highlight
  palette switched from purple to dark grey to match the code-window chrome.
- Font licence files renamed `LICENSE-Luciole.md` → `Luciole.LICENSE` and
  `LICENSE-FiraCode.md` → `FiraCode.LICENSE` (alignment with
  `filters/add-code-file.LICENSE`).

### Removed

- `filters/resources/add-code-files.css`: all rules were already shadowed by
  `theme.scss` (`body div[data-code-filename] { … }`); the inlined filter
  registers only the JS dependency.

## [0.9.0] — 2026-04-24

### Added

- Multi-format Quarto extension (`hebstr-html`, `hebstr-typst`, `hebstr-docx`)
  via a shared `common:` block.
- HTML theme (Bootstrap/Bootswatch SCSS), Typst preamble, DOCX reference doc,
  Luciole and Fira Code fonts.
