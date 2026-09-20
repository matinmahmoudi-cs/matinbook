# Changelog

All notable changes to the MatinBook project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned for v1.2

- **`matinbook.cls`:** Add `\DeclareRelease` for backward compatibility with v1.0
- **`mb-theorem`:** Unify all `\theoremstyle` calls to `definition` (fix italic title for 'نکته')
- **`mb-code`:** Migrate to `minted` v3's `bgcolorpadding` (requires TeX Live 2024+)
- **`mb-code`:** Replace manual `codecounter` with minted's `listing` float
- **`mb-theme-colors`:** Convert RGB→CMYK with a professional color tool for precise values
- **`mb-theme-cover`:** Simplify cover design (reduce decorative elements)
- **`mb-theme-cover`:** Reduce font count from 5 to 2
- **`main.tex`:** Enable Bismillah page and Latin title page by default
- **`tests/`:** Replace `run-all-tests.sh` with a modern test runner

---

## [1.1.0] — 2026-01-01 (تابستان ۱۴۰۵)

### 🎯 Major Changes

This release is the result of a comprehensive 25-report audit covering
LaTeX 2023 standards, official documentation, open-source comparisons,
and Iranian publishing standards.

#### Architecture Refactoring

- **Migrated to LaTeX 2023 key-value option system** (`\DeclareKeys`)
  - Replaced traditional `\DeclareOption` with `\DeclareKeys` in `matinbook.cls`
  - Added `\ProcessKeyOptions` support
  - Added backward-compatibility flags (`\if@matin@draft`) for existing modules

- **Standardized package conventions**
  - All 24 `.sty` files now use `\ProvidesPackage{mb-*}` (simple names)
  - All files use `\NeedsTeXFormat{LaTeX2e}[2020/10/01]`
  - All files use `\PackageInfo` instead of `\typeout`

- **Fixed loading order** (critical for xepersian and colors)
  - `xepersian` is now the LAST package in `matinbook.cls`
  - Colors (`mb-theme-colors`) are loaded immediately after `mb-core`
  - Font configuration moved directly into `matinbook.cls` (after `xepersian`)

#### Obsolete Modules Removed

Six modules were removed because their functionality was either merged
into other modules or handled automatically by `xepersian`:

| Module | Reason |
|--------|--------|
| `mb-engine.sty` | Logic merged into `matinbook.cls` |
| `mb-options.sty` | Options moved to `matinbook.cls` (`\DeclareKeys`) |
| `mb-fonts.sty` | Fonts moved to `matinbook.cls` (after `xepersian`) |
| `mb-rtl.sty` | `xepersian` loaded directly in `matinbook.cls` |
| `mb-algorithm.sty` | `xepersian` handles `algorithm` natively |
| `mb-colors.sty` | Empty placeholder; colors in `mb-theme-colors` |

### ✨ Added

#### Core

- **`matinbook.cls`:**
  - Three-phase bootstrap sequence (Phase 1: base packages, Phase 2: xepersian, Phase 3: Persian-specific)
  - Version variables (`\matinbookversion`, `\matinbookdate`) at the top
  - Book title command (`\booktitle`) for even-page headers
  - `\repository` command for cover customization
  - `\matin@repository` internal variable

- **`mb-core.sty`:**
  - `xcolor[table]` for `\rowcolor` support
  - `\tcbuselibrary{minted}` for tcolorbox-minted integration
  - Moved `pgf-pie` to `mb-graphics` (per review #3)
  - Moved `draftwatermark` to `mb-layout` (per review #3)
  - Moved `\newcolumntype{L,R,C}` to `mb-typography` (per review #3)

- **`mb-typography.sty`:**
  - `xepersian-hm` for Kashida support (disabled by default)
  - `\newcolumntype{L}[1]`, `R[1]`, `C[1]` (with width argument)
  - Reduced `\emergencystretch` from 3em to 1em (Persian uses Kashida, not spacing)

- **`mb-layout.sty`:**
  - O'Reilly-standard margins with Vaziri page size (16.5 × 24 cm)
  - Asymmetric margins: top=3.0cm, bottom=2.5cm, inner/outer=2.5cm
  - `bindingoffset=0.5cm`
  - Header/Footer per Iranian standard (book title / chapter name)
  - Draft watermark (moved from `mb-core`)

- **`mb-headings.sty`:**
  - Reduced chapter number from 72pt to 36pt
  - Changed chapter title from `\Huge` to `\LARGE`
  - Replaced negative `\titlespacing` with positive values
  - Restored `\cftdotsep` from 0.5 to 4.5 (LaTeX default)
  - Removed `\renewcommand{\thechapter}` (preserves `\appendix`)

- **`mb-math.sty`:**
  - Wrapped all `\DeclareMathOperator` in `\AtBeginDocument` (unicode-math override)
  - Changed `\newcommand` to `\providecommand` for `\N, \Z, \Q, \R, \C, \D`
  - Equation numbering: `\theequation` redefined to `(formula-chapter)` per Iranian standard
  - Removed duplicate `\thinmuskip`/`\medmuskip`/`\thickmuskip` (LaTeX defaults)

- **`mb-boxes.sty`:**
  - Reduced color count from 5 to 3 (blue, orange, green)
  - Changed `colback` from white to `matincream` (off-white)
  - Changed `fonttitle` from `\small` to `\normalsize`
  - Increased `toptitle` from 4pt to 6pt
  - Removed redundant `\textbf{ }` in title

- **`mb-theorem.sty`:**
  - Complete rewrite using `\newtheorem` + `\tcolorboxenvironment`
  - All theorem environments share a counter (`definition`)
  - `solution` environment (no numbering)
  - `proof` environment preserves `\qedsymbol`
  - `\crefname` uses environment names (not counter names)
  - Added `\Crefname` for capitalized forms
  - Added plural forms in `fa-IR` and `en-US`

- **`mb-code.sty`:**
  - Added `escapeinside=||` for Persian comments
  - Added `\pc{}` command for Persian text inside code
  - Changed `fontsize` from `\small` to `\footnotesize`
  - Changed `frame` from `single` to `lines`
  - Changed `breakanywhere` from `true` to `false`
  - Added `baselinestretch=0.95`
  - Added `style=friendly`
  - Removed `python3=true` (obsolete in minted v2/v3)

- **`mb-graphics.sty`:**
  - Moved `pgf-pie` from `mb-core`
  - Documented `lstlisting` in TikZ nodes limitation (LaTeX kernel issue)

- **`mb-index.sty`:**
  - Switched from `makeindex` to `xindy` with `persian-variant2`
  - Removed fragile `\renewcommand{\subitem}` and `\subsubitem`
  - Full xindy options: `-L persian-variant2 -C utf8 -M texindy -M page-ranges`

- **`mb-theme-colors.sty`:**
  - Converted all colors from RGB to CMYK (per Iranian standard ز/۱-۴)
  - Changed `\definecolor` to `\providecolor` (user override support)
  - Added `matincream` (off-white background)
  - `matinblue` is the dominant color

- **`mb-theme-cover.sty`:**
  - Mapped all `cover*` colors to `matin*` palette via `\colorlet`
  - Replaced hardcoded `v1.0.0` with `\matinbookversion`
  - Replaced hardcoded `github.com/matinbook` with `\matin@repository`
  - Added `\repository` public alias
  - Fixed TikZ font size syntax in nodes
  - Removed `\lr{}` from math symbols inside `tikzpicture`
  - Added prominent 2-pass compilation note

- **`main.tex`:**
  - Fixed document order per Iranian publishing standards
  - Moved `\makebackcover` to the very end
  - Moved `\frontmatter` to before `\maketitle`
  - Removed `latin` wrapper from `\printbibliography`
  - Expanded copyright page with `شناسنامه کتاب` table
  - Added `\backmatter` for bibliography and index
  - Added optional Bismillah page (commented)
  - Added optional Latin title page (commented)
  - Added conditional `\listofalgorithms` (commented)

#### Tests

- **22 integration tests** in `tests/v1.1/`:
  - `compile.sh` — modern test compiler (compiles all `.tex`, cleans aux files on success)
  - `stage-cls-01.tex` — basic infrastructure
  - `stage-packages-01.tex` — package loading conventions
  - `stage-options-01.tex` — key-value option system
  - `stage-core-01.tex` — core package loader
  - `stage-utils-01.tex` — utility macros
  - `stage-rtl-01.tex` — RTL/Bidi support
  - `stage-locale-01.tex` — Persian locale
  - `stage-locale-en-01.tex` — English locale
  - `stage-typography-01.tex` — typography (Kashida, microtype)
  - `stage-layout-01.tex` — layout (O'Reilly margins)
  - `stage-headings-01.tex` — heading styles
  - `stage-math-01.tex` — math operators, delimiters, numbering
  - `stage-boxes-01.tex` — colored tcolorbox styles
  - `stage-theorem-01.tex` — theorem environments
  - `stage-code-01.tex` — code listings (minted)
  - `stage-algorithm-01.tex` — algorithm environments
  - `stage-graphics-01.tex` — TikZ, PGFPlots, pgf-pie
  - `stage-index-01.tex` — xindy with Persian sorting
  - `stage-colors-01.tex` — CMYK color palette
  - `stage-theme-default-01.tex` — theme loader
  - `stage-cover-01.tex` — front and back cover
  - `stage-main-01.tex` — full book structure

### 🔧 Changed

#### `matinbook.cls`

- Reorganized loading into three phases:
  1. **Phase 1 — Base packages (BEFORE xepersian):** `mb-core`, `mb-theme-colors`, `mb-boxes`, `mb-code`, `mb-layout`, `mb-headings`, `mb-math`, `mb-references`, `mb-graphics`, `mb-index`, `mb-utils`, `mb-theme-cover`
  2. **Phase 2 — xepersian (LAST package):** `\RequirePackage{xepersian}`
  3. **Phase 3 — Persian-specific settings (AFTER xepersian):** font configuration, `mb-typography`, `fa-IR`
- `\ProvidesClass{matinbook}[2026/01/01 v1.1]`
- `\NeedsTeXFormat{LaTeX2e}[2023/06/01]`

#### `fa-IR.sty` and `en-US.sty`

- Changed `\renewcommand` to `\providecommand` for names undefined in `book` class (`\abstractname`, `\refname`)
- Added `\crefname` for `subsection`, `exercise`, `proposition`
- Added `\crefrangeformat` for `theorem`
- Added `\crefpairconjunction`, `\crefrangeconjunction`, `\crefmiddleconjunction`, `\creflastconjunction` via `\AtBeginDocument`
- Added plural forms (`\theoremplural`, `\lemmanplural`, etc.)
- Removed `\floatname{algorithm}` (xepersian handles it)

#### `mb-utils.sty`

- Fixed `\matin@ifcmd` to accept 3 arguments (was 1, broken)
- Added `\makeatletter`/`\makeatother` block
- Pre-initialized `\@latintitle` and `\@latinauthor` with `\providecommand`
- Used `\gdef` for global assignment (matches LaTeX kernel pattern)
- Removed dead code (`\matinbookversion`, `\matinbookdate` — moved to `matinbook.cls`)

### 🐛 Fixed

- **`matinbook.cls`:** Removed stray `\n` character introduced by earlier `sed`
- **`mb-core.sty`:** Fixed `mathtools`/`amsmath` order (amsmath first)
- **`mb-core.sty`:** Removed `amssymb` (unicode-math replaces it)
- **`mb-core.sty`:** Added explicit `\tcbuselibrary{minted}`
- **`mb-core.sty`:** Added `colortbl` (via `xcolor[table]`) for `\rowcolor`
- **`mb-boxes.sty`:** Fixed `\newcolumntype{L,R,C}` to accept width argument
- **`mb-theorem.sty`:** Fixed `\crefname` to use environment names (not counter names)
- **`mb-theorem.sty`:** Fixed `\qedsymbol` preservation in proof environment
- **`fa-IR.sty`:** Fixed `\renewcommand{\abstractname}` (undefined in book) → `\providecommand`
- **`fa-IR.sty`:** Fixed `\creflastconjunction` undefined error via `\AtBeginDocument`
- **`mb-theme-cover.sty`:** Fixed TikZ `font=` syntax (`\fontsize` inside node content)
- **`mb-theme-cover.sty`:** Fixed `\lr{}` in `tikzpicture` (`\endL or \endR` error)
- **`mb-theme-cover.sty`:** Fixed `\matin@repository` not accessible from tests (added `\repository`)
- **`main.tex`:** Fixed document order per Iranian publishing standards

### ⚠️ Known Issues

- **`mb-theorem`:** `\theoremstyle{remark}` produces italic title for 'نکته'. To be fixed in v1.2.
- **`mb-code`:** `bgcolorpadding` not available in TeX Live 2023's `fvextra`. To be added when TeX Live 2024+ is required.
- **`mb-theme-colors`:** CMYK values are approximate (converted from RGB). Precise conversion planned for v1.2.
- **`mb-theme-cover`:** Cover uses 5 fonts and many decorative elements. Simplification planned for v1.2.

### 📚 Documentation

- **`README.md`:** Complete rewrite
  - Updated for v1.1 (18 modules, not 20)
  - Updated font list
  - Updated compilation instructions (xindy, 2-pass cover)
  - Updated project structure
  - Updated test list (22 tests)
  - Added CHANGELOG section
- **`CHANGELOG.md`:** Initial release (this file)
- **`AI_GUIDE.md`:** (pending update)

### 🔍 Review Reports

This release is based on 25 review reports covering:

| # | Report | File(s) |
|---|--------|---------|
| 1 | LaTeX 2023 standards | `matinbook.cls` |
| 2 | Official documentation | `mb-engine`, `mb-options` |
| 3 | Open-source comparison | `mb-core` |
| 4 | Market standards | `mb-utils` |
| 5 | xepersian integration | `mb-rtl` |
| 6 | Persian localization | `fa-IR` |
| 7 | English localization | `en-US` |
| 8 | Empty placeholder | `mb-fonts` |
| 9 | Kashida support | `mb-typography` |
| 10 | Page geometry | `mb-layout` |
| 11 | Heading styles | `mb-headings` |
| 12 | Math environments | `mb-math` |
| 13 | Color philosophy | `mb-boxes` |
| 14 | Theorem conflicts | `mb-theorem` |
| 15 | Minted v2/v3 | `mb-code` |
| 16 | Algorithm support | `mb-algorithm` |
| 17 | TikZ compatibility | `mb-graphics` |
| 18 | Index sorting | `mb-index` |
| 19 | Empty placeholder | `mb-colors` |
| 20 | CMYK standards | `mb-theme-colors` |
| 21 | Load order | `mb-theme-default` |
| 22 | Cover design | `mb-theme-cover` |
| 23 | Document structure | `main.tex` |
| 24 | Document structure | `main.tex` |
| 25 | Document structure | `main.tex` |

---

## [1.0.0] — 2025-07-01 (تابستان ۱۴۰۴)

### Added

- Initial release of MatinBook
- 24 modules (20 feature modules + 4 core modules)
- XB Niloofar default font
- Full RTL support via xepersian
- 10 colored box types
- Math operators and delimiters
- Algorithm environments
- Code listing via minted
- TikZ and PGFPlots integration
- Bibliography via biblatex
- Index via makeindex
- Front and back cover design
- Persian and English locales

### Known Issues (v1.0)

- Color palette used RGB instead of CMYK
- `makeindex` used instead of `xindy` (Persian sorting incorrect)
- `mb-theorem` used manual `\newcounter` + `\newenvironment`
- `mb-code` used `python3=true` (obsolete)
- `main.tex` had incorrect component order
- `xepersian` not loaded as the last package

---

## Version Numbering

MatinBook follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version (X.0.0): Incompatible API changes
- **MINOR** version (1.X.0): Backward-compatible functionality added
- **PATCH** version (1.1.X): Backward-compatible bug fixes

Persian calendar dates are provided in parentheses for reference.

---

## Links

- **Repository:** [github.com/matinbook/matinbook](https://github.com/matinbook/matinbook)
- **Issues:** [github.com/matinbook/matinbook/issues](https://github.com/matinbook/matinbook/issues)
- **CTAN:** (planned)

---

**Made with MatinBook — Written with passion for Persian technical writing.**
