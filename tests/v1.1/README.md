# MatinBook v1.1 — Test Suite

This directory contains integration tests specific to **MatinBook v1.1**.

## Purpose

Each test verifies one or more fixes/improvements introduced in v1.1,
corresponding to the four review stages documented in the project reports.

## Test Files

| File | Target | Stages Covered |
|------|--------|----------------|
| `stage-cls-01.tex` | `matinbook.cls` | 1, 2, 3, 4 |

## Running Tests

From the project root:

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