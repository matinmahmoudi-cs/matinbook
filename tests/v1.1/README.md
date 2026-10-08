# MatinBook v1.1 — Test Suite

This directory contains **26 integration tests** for **MatinBook v1.1**.

## Purpose

Each `stage-*.tex` file verifies one or more modules of MatinBook v1.1,
covering the architecture refactoring documented in `CHANGELOG.md`.

## Test Files (23 official tests)

| File | Target |
|------|--------|
| `stage-cls-01.tex` | `matinbook.cls` (basic infrastructure) |
| `stage-packages-01.tex` | Package loading conventions |
| `stage-options-01.tex` | Key-value option system (`\DeclareKeys`) |
| `stage-core-01.tex` | `mb-core.sty` |
| `stage-utils-01.tex` | `mb-utils.sty` |
| `stage-rtl-01.tex` | RTL/Bidi support |
| `stage-locale-01.tex` | Persian locale (`fa-IR.sty`) |
| `stage-locale-en-01.tex` | English locale (`en-US.sty`) |
| `stage-typography-01.tex` | Typography (`mb-typography.sty`) |
| `stage-layout-01.tex` | Layout (`mb-layout.sty`) |
| `stage-headings-01.tex` | Headings (`mb-headings.sty`) |
| `stage-math-01.tex` | Math (`mb-math.sty`) |
| `stage-boxes-01.tex` | Boxes (`mb-boxes.sty`) |
| `stage-theorem-01.tex` | Theorem environments (`mb-theorem.sty`) |
| `stage-code-01.tex` | Code (`mb-code.sty`) |
| `stage-algorithm-01.tex` | Algorithms |
| `stage-graphics-01.tex` | Graphics (`mb-graphics.sty`) |
| `stage-index-01.tex` | Index (`mb-index.sty`) |
| `stage-colors-01.tex` | Colors (`mb-theme-colors.sty`) |
| `stage-theme-default-01.tex` | Theme loader (`mb-theme-default.sty`) |
| `stage-cover-01.tex` | Cover (`mb-theme-cover.sty`) |
| `stage-main-01.tex` | Full book structure |
| `stage-margin-01.tex` | Margin notes |

## Debug Helpers (3 files, not official tests)

| File | Purpose |
|------|---------|
| `test-latin.tex` | Latin-only minimal document (isolates Latin rendering) |
| `test-minimal.tex` | Minimal document (isolates class loading) |
| `test-unicode-math.tex` | unicode-math integration test |

These files were written during v1.1 development to isolate specific issues.
They are **not** part of the official test suite.

## Running Tests

### Option 1: Use the test compiler (recommended)

```bash
cd tests/v1.1
bash compile.sh
```

This compiles all 26 `.tex` files and reports pass/fail.

To compile a specific test:

```bash
cd tests/v1.1
bash compile.sh stage-cls-01.tex
```

### Option 2: Manual compilation

```bash
cd tests/v1.1
TEXINPUTS=../../: xelatex -shell-escape stage-cls-01.tex
```

Or use `latexmk`:

```bash
cd tests/v1.1
TEXINPUTS=../../: latexmk -xelatex -shell-escape stage-cls-01.tex
```

**Note:** `TEXINPUTS=../../:` is required because `matinbook.cls` uses
`\input{tex/...}` with paths relative to the project root.

## Expected Result

A clean compilation with:

- No errors
- No warnings related to package loading
- The welcome message visible in the log (via `\ClassInfo`)
- All test sections rendered in the PDF

## Requirements

- XeLaTeX (mandatory)
- Biber (for bibliography tests)
- Xindy (for index tests)
- Python 3 + Pygments (for `minted` code tests)
- All MatinBook fonts installed

## Links

- **Repository:** [github.com/matinmahmoudi-cs/matinbook](https://github.com/matinmahmoudi-cs/matinbook)
- **Issues:** [github.com/matinmahmoudi-cs/matinbook/issues](https://github.com/matinmahmoudi-cs/matinbook/issues)
- **CHANGELOG:** [CHANGELOG.md](../../CHANGELOG.md)
- **AI Guide:** [AI_GUIDE.md](../../AI_GUIDE.md)
