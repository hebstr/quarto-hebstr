# hebstr Extension For Quarto

A Quarto extension providing a shared multi-format theme for HTML documents, Typst (PDF) reports, and Word (DOCX) documents.

> **Status (v0.10.0)** — only the **HTML** format is operational. Typst and DOCX formats are planned but not yet shippable.

## Installation

```bash
quarto add hebstr/quarto-hebstr
```

This will install the extension under the `_extensions` subdirectory.
If you are using version control, you will want to check in this directory.

To pin a specific version:

```bash
quarto add hebstr/quarto-hebstr@v0.10.0
```

## Formats

The extension targets three formats sharing a common set of defaults (numbered sections, TOC, cross-references, knitr chunk options):

- **`hebstr-html`** *(operational)*: self-contained HTML with custom SCSS theme, Luciole and Fira Code fonts, lightbox figures, and a wide body/margin grid.
- **`hebstr-typst`** *(planned)*: A4 PDF with Luciole as the main font and a Typst preamble styling headings, lists, tables, code blocks, and quotes.
- **`hebstr-docx`** *(planned)*: Word document using a reference `.dotx` for styles.

## Usage

```yaml
---
title: "My Document"
format: hebstr-html
---
```

The Typst and DOCX formats below are declared but not yet ship-ready (no validated rendering on `main`):

```yaml
---
title: "My Report"
format: hebstr-typst   # planned
---
```

```yaml
---
title: "My Document"
format: hebstr-docx    # planned
---
```

## Fonts

The extension bundles the following open-licensed fonts:

- [Luciole](https://luciole-vision.com/) — a sans-serif font designed for low-vision readers (CC-BY 4.0).
- [Fira Code](https://github.com/tonsky/FiraCode) — a monospace font with programming ligatures (SIL OFL 1.1).

Both are shipped as `.woff` and `.woff2` under `_extensions/hebstr/fonts/` and referenced via `@font-face` (HTML) and `font-paths` (Typst). Licence texts are bundled alongside the font files (`Luciole.LICENSE`, `FiraCode.LICENSE`).

## Customisation

The SCSS theme exposes named CSS custom properties under `:root`, grouped by purpose:

- **brand colours**: `--primary`, `--primary-back`, `--primary-dark`, `--secondary`, `--neutral`, `--line-color`
- **surfaces**: `--surface-default`, `--em-background-color`, `--caption-color`
- **code highlight**: `--code-foreground-color`, `--code-background-color`, `--code-comment-color`
- **code-window chrome**: `--code-window-titlebar-bg`, `--code-window-border`, `--code-window-line-divider`, `--code-window-muted`, `--code-window-line-number`
- **callout colours**: `--callout-{note,tip,caution,warning,important}-color`

The SCSS variables `$primary`, `$secondary`, `$font-family-sans-serif`, `$font-family-monospace`, `$font-size-root`, and `$callout-icon-scale` are declared with `!default` and can also be overridden from a consumer SCSS file.

To override in a consumer project:

```yaml
format:
  hebstr-html:
    theme:
      - hebstr
      - custom.scss
```

## Example

Source: [example.qmd](example.qmd).

To render locally:

```bash
quarto render example.qmd
```

This produces `index.html` covering headings, lists, figures, tables, code blocks, equations, callouts, and cross-references. Typst (`example.pdf`) and DOCX (`example.docx`) outputs are planned for a later release.

## Licence

Code is released under the MIT Licence (see [LICENSE.md](LICENSE.md)). Bundled fonts retain their respective licences (see `_extensions/hebstr/fonts/`).
