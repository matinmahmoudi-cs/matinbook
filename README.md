# MatinBook — A Professional LaTeX Class for Persian Technical Books

**MatinBook** is a modular, feature-rich LaTeX document class designed specifically for writing professional Persian books in programming, mathematics, and computer science. Built with XeLaTeX, it provides a complete typesetting solution with beautiful typography, intelligent cross-referencing, and extensive customization options.

**Current version:** v1.2 (Mehr 1405 / مهر ۱۴۰۵)

---

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Examples](#examples)
- [Tests](#tests)
- [Compilation](#compilation)
- [Customization](#customization)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Features

### Core Capabilities
- **Persian-first design:** Full RTL support with proper Persian/Arabic typography
- **Modular architecture:** 19 source modules (18 `.sty` + 1 `.cls`) for easy maintenance
- **Professional typography:** Microtype protrusion, Kashida support, widow/orphan control
- **Standard-compliant:** Follows LaTeX 2023 key-value option system
- **Print-ready:** CMYK color palette per Iranian educational publishing standards

### Scientific Environments
- **Two box families:**
  - **`matinbox`** (Boyer-style): solid colored title bar, white body, sharp corners — used by `theorem`, `lemma`, `corollary`, `proposition`, `definition`, `remark`, `exercise`.
  - **`matin-outline`** (RTL outline): right vertical line + horizontal rules, white body, black bold title — used by `example`, `proof`, `solution`.
- **Breakable boxes:** Long boxes span multiple pages; the outline family keeps its vertical line on the correct side of each broken piece.
- **Mathematics:** Custom operators, smart delimiters, matrix commands, number sets (ℕ, ℤ, ℚ, ℝ, ℂ)
- **Algorithms:** Pseudocode with Persian captions via `xepersian` (standard `algorithm` package)
- **Code display:** Syntax highlighting for 300+ languages via `minted` with Persian comment support
- **Graphics:** TikZ styles, PGFPlots presets, flowcharts, trees, and pie charts
- **Tables:** Modern table system via `tabularray` with `matintable` environment, RTL-native, `booktabs`-compatible

### Document Structure
- **Professional cover:** Full-color front cover with math/code symbols and a two-block back cover (book blurb + author bio). Requires 2 compilation passes.
- **Wide margin layout:** 5.9cm outer margin with `\mnote{}` and `\marginfig{}{}` for RTL margin notes
- **Frontmatter / mainmatter split:** Symmetric margins for frontmatter (copyright, preface, ToC) and wide margins for main chapters
- **Boyer/Stewart heading scale:** 24/20pt chapter, 15pt section, 13pt subsection, 11pt subsubsection
- **Table of contents:** Customizable with colored dotted lines
- **Cross-references:** Intelligent referencing with `cleveref` (Persian + English)
- **Bibliography:** Full `biblatex` support with Persian title
- **Index:** Multi-level index with `xindy` and `persian-variant2` for correct Persian sorting

### Advanced Features
- **Draft mode:** Watermark and overfull box highlighting
- **Multiple fonts:** XB Niloofar (default), Vazirmatn, Sahel, IR Lotus, B Nazanin
- **Textbook leading:** 1.15 line spacing (Boyer/Stewart-style)
- **Persian number helper:** `\pnum{...}` for decimal numbers and thousands separators in RTL context
- **Localization:** Persian (fa-IR) and English (en-US) locales

---

## Requirements

### Software

| Tool | Version | Required For |
|------|---------|--------------|
| **XeLaTeX** | Any | Engine (mandatory) |
| **Biber** | 2.x+ | Bibliography processing |
| **Xindy** | Any | Index generation (Persian sorting) |
| **Python 3** | 3.6+ | Pygments (for `minted`) |
| **Pygments** | Latest | Code syntax highlighting |
| **latexminted** | Latest | Required for `minted` v3+ (optional) |
| **tabularray** | 2021+ | Modern table package (RTL-compatible) |

> **Note:** `xindy` is required because `makeindex` cannot sort Persian correctly (it fails to order the Persian-specific letters پ، چ، ژ، گ، ک).

### Fonts

| Font | Type | Usage | Required? |
|------|------|-------|-----------|
| **XB Niloofar** | Persian | Default body text | ✅ Yes |
| **Times New Roman** | Latin | English text | ✅ Yes |
| **XITS Math** | Math | Mathematical formulas | ✅ Yes |
| **DejaVu Sans Mono** | Monospace | Code listings | ✅ Yes |
| **Vazirmatn** | Persian | Optional alternative | ❌ Optional |
| **Sahel** | Persian | Optional alternative | ❌ Optional |
| **IR Lotus** | Persian | Optional alternative | ❌ Optional |
| **B Nazanin** | Persian | Optional alternative | ❌ Optional |

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/matinmahmoudi-cs/matinbook.git
cd matinbook
```

### 2. Install Required Fonts

**On Linux:**

```bash
# Install XB Niloofar (if not already installed)
cp fonts/niloofar/*.ttf ~/.local/share/fonts/
fc-cache -fv

# Install XITS Math
sudo apt install fonts-xits

# Install DejaVu Sans Mono (usually pre-installed)
sudo apt install fonts-dejavu

# Install Vazirmatn (optional)
sudo apt install fonts-vazirmatn
```

**On macOS:**

```bash
cp fonts/niloofar/*.ttf ~/Library/Fonts/
```

**On Windows:**

- Right-click each `.ttf` file → Install

### 3. Install Python Dependencies

```bash
pip install pygments
pip install latexminted  # optional, for minted v3+
```

### 4. Install the Class in texmf (Recommended)

```bash
mkdir -p ~/texmf/tex/latex/matinbook
cp matinbook.cls ~/texmf/tex/latex/matinbook/
find tex -name "*.sty" -exec cp {} ~/texmf/tex/latex/matinbook/ \;
texhash ~/texmf
```

### 5. Verify Installation

```bash
cd tests/v1.2
./run-all-tests.sh
```

If a PDF is generated without errors, the installation is successful.

---

## Quick Start

### Minimal Working Example

Create a file `my-book.tex`:

```latex
\documentclass{matinbook}

\title{عنوان کتاب من}
\author{نام نویسنده}
\date{مهر ۱۴۰۵}

\begin{document}

\makecover
    {عنوان کتاب من}
    {زیرعنوان}
    {نام نویسنده}
    {مهر ۱۴۰۵}

\frontmatter
\frontmattergeometry          % ← symmetric margins (no wide margin)
\maketitle
\tableofcontents

\mainmatter
\mainmattergeometry           % ← wide margin for margin notes
\chapter{فصل اول}

این یک متن نمونه فارسی است.

\begin{theorem}[قضیه نمونه]
    این یک قضیه آزمایشی است.
\end{theorem}

\begin{proof}
    اثبات این قضیه ساده است.
\end{proof}

\mnote{این یک یادداشت حاشیه‌ای است.}

\backmatter
\frontmattergeometry
\printbibliography[title={منابع و مراجع}]
\printindex

\makebackcover{توضیحات پشت جلد...}

\end{document}
```

### Compile

```bash
# Simple document (2 passes for cross-references)
xelatex -shell-escape my-book.tex
xelatex -shell-escape my-book.tex

# Full document (with cover, bibliography, and index)
xelatex -shell-escape my-book.tex
biber my-book
xelatex -shell-escape my-book.tex
xelatex -shell-escape my-book.tex
```

> **Important:** The cover uses `remember picture, overlay` (TikZ), which **requires at least 2 compilation passes**.

---

## Project Structure

```
matinbook/
├── matinbook.cls                # Main class file
├── main.tex                     # Template main file
├── references.bib               # Sample bibliography
├── CHANGELOG.md                 # Version history
├── LICENSE                      # MIT License
├── README.md                    # This file
│
├── tex/                         # Source modules
│   ├── core/                    # Core modules (2)
│   │   ├── mb-core.sty          #   Package loader
│   │   └── mb-utils.sty         #   Utility commands
│   │
│   ├── locales/                 # Language files (2)
│   │   ├── fa-IR.sty            #   Persian locale
│   │   └── en-US.sty            #   English locale
│   │
│   ├── modules/                 # Feature modules (9)
│   │   ├── boxes/               #   Two box families (matinbox, matin-outline)
│   │   ├── code/                #   Code listing (minted)
│   │   ├── graphics/            #   TikZ and PGFPlots
│   │   ├── index/               #   Index configuration (xindy)
│   │   ├── layout/              #   Page layout, headings, margin notes
│   │   ├── math/                #   Math operators and delimiters
│   │   ├── references/          #   Hyperref and cleveref
│   │   ├── table/               #   Table system (tabularray)
│   │   ├── theorem/             #   Theorem environments (tcolorbox)
│   │   └── typography/          #   Fonts and typography
│   │
│   └── themes/                  # Theme system (1)
│       └── default/             #   Default professional theme
│           ├── mb-theme-colors.sty   # Color palette (CMYK)
│           ├── mb-theme-cover.sty    # Cover design (full-color)
│           └── mb-theme-default.sty  # Theme loader
│
├── assets/                      # Static assets
│   ├── cover/                   #   Cover images
│   └── images/                  #   Book images
│
├── tests/                       # Test suites
│   ├── v1.2/                    #   Active v1.2 test suite (15 tests)
│   │   ├── run-all-tests.sh     #     Test runner script
│   │   ├── stage01-basic.tex
│   │   ├── stage02-fonts.tex
│   │   ├── stage03-layout.tex
│   │   ├── stage04-typography.tex
│   │   ├── stage05-math.tex
│   │   ├── stage06-theorems.tex
│   │   ├── stage07-boxes.tex
│   │   ├── stage08-code.tex
│   │   ├── stage09-algorithms.tex
│   │   ├── stage10-tikz.tex
│   │   ├── stage11-references.tex
│   │   ├── stage12-biblatex.tex
│   │   ├── stage13-index.tex
│   │   ├── stage14-book.tex
│   │   └── stage15-cover.tex
│   │
│   └── archive/                 #   Legacy test suites
│       └── v1.1/                #     Old v1.1 tests (for reference)
│
└── examples/                    # Example books (2)
    ├── matinbook-documentation.tex  # Full documentation
    └── advanced-algorithms-book.tex # Complete sample book
```

---

## Documentation

### Full Documentation
The complete MatinBook user guide is available as a PDF generated from the source:

```bash
cd examples
xelatex -shell-escape matinbook-documentation.tex
biber matinbook-documentation
xelatex -shell-escape matinbook-documentation.tex
xelatex -shell-escape matinbook-documentation.tex
```

This documentation covers:
- Installation and setup
- Architecture overview (all 19 modules)
- User guide (writing math, theorems, code, algorithms)
- Theme system and customization
- Development guide
- Troubleshooting

### Quick Reference

#### Class Options

```latex
\documentclass[draft]{matinbook}        % Draft mode (watermark)
\documentclass[niloofar]{matinbook}     % XB Niloofar (default)
\documentclass[vazirmatn]{matinbook}    % Vazirmatn
\documentclass[sahel]{matinbook}        % Sahel
\documentclass[irlotus]{matinbook}      % IR Lotus
\documentclass[bnazanin]{matinbook}     % B Nazanin
```

#### Scientific Environments

```latex
\begin{theorem}[Title] ... \end{theorem}
\begin{lemma}[Title] ... \end{lemma}
\begin{corollary}[Title] ... \end{corollary}
\begin{proposition}[Title] ... \end{proposition}
\begin{definition}[Title] ... \end{definition}
\begin{example}[Title] ... \end{example}
\begin{remark}[Title] ... \end{remark}
\begin{exercise}[Title] ... \end{exercise}
\begin{solution} ... \end{solution}
\begin{proof} ... \end{proof}
```

#### Mathematics

```latex
\N, \Z, \Q, \R, \C           % Number sets
\abs{x}, \norm{x}             % Absolute value, norm
\ceil{x}, \floor{x}           % Ceiling, floor
\inner{u}{v}                  % Inner product
\mat{1 & 2 \\ 3 & 4}          % Matrix with brackets
\grad, \curl, \diver          % Vector calculus
\deriv{}{x}, \pderiv{f}{x}    % Derivatives
```

#### Persian Numbers

```latex
مقیاس \pnum{۱.۲} به این معناست...     % decimal point
\pnum{۳/۱۴}                             % slash
\pnum{۱٬۰۰۰٬۰۰۰}                        % thousands separator
```

> **Note:** Persian numbers containing a decimal point, slash, or
> thousands separator are reversed by the bidi/fontspec
> interaction. Use `\pnum{...}` to wrap them.

#### Code Display

```latex
\begin{minted}{python}
def hello():
    print("Hello, World!")
\end{minted}

% With Persian comment:
\begin{minted}{python}
x = 5  # |\pc{مقدار متغیر}|
\end{minted}

\inlcode{print("inline")}
```

#### Algorithms

```latex
\begin{latin}
\begin{algorithm}
\caption{محاسبه فاکتوریل}
\label{alg:factorial}
\begin{algorithmic}[1]
    \Require عدد صحیح $n \geq 0$
    \Ensure $n!$
    \State $result \gets 1$
    \For{$i \gets 2$ \textbf{to} $n$}
        \State $result \gets result \times i$
    \EndFor
    \State \Return $result$
\end{algorithmic}
\end{algorithm}
\end{latin}
```

#### Cross-References

```latex
\cref{eq:label}       % Smart reference (uses cleveref)
\cref{thm:label}      % Theorem reference
\cref{fig:label}      % Figure reference
\cref{tab:label}      % Table reference
\cref{lst:label}      % Code reference
```

#### Margin Notes

```latex
\mnote{یادداشت حاشیه}                    % plain margin note (RTL, no number)
\marginfig{figures/plot.png}{نمودار}     % figure + caption in the margin
```
#### Tables

```latex
\begin{matintable}{caption}{label}
\begin{tblr}{
    width = \textwidth,
    colspec = {l l X[c] X[c]},
    hlines, vlines,
    colsep = 8pt,
    rowsep = 4pt,
    row{1} = {font=\bfseries},
}
نوع & فونت & وضعیت & توضیحات \\
فارسی & \lr{XB Niloofar} & فعال & ... \\
\end{tblr}
\end{matintable}
```

> **Note:** MatinBook uses `tabularray` (not `tabularx`) because
> `tabularx` is incompatible with `xepersian`. The `matintable`
> environment wraps the boilerplate of a captioned, labelled,
> centered table.

#### Frontmatter / Mainmatter

```latex
\frontmatter
\frontmattergeometry          % symmetric margins (no wide margin)
\maketitle
\tableofcontents

\mainmatter
\mainmattergeometry           % wide margin for margin notes
\chapter{...}

\backmatter
\frontmattergeometry          % symmetric margins again
\printbibliography
\printindex
```

#### Index Entries

```latex
\index{پایتون}
\idxbold{مفهوم مهم}
\idxitalic{اصطلاح}
\idxsee{پایتون}{زبان برنامه‌نویسی}
\idxseealso{برنامه‌نویسی}{الگوریتم}
\idxsub{برنامه‌نویسی}{پایتون}
\idxsubsub{ریاضیات}{جبر}{گروه}
```

#### Cover

```latex
\makecover
    {عنوان کتاب}
    {زیرعنوان}
    {نام نویسنده}
    {مهر ۱۴۰۵}

% Author bio (optional, before \makebackcover):
\authorbio{متن درباره نویسنده}

% Back cover (at the very end):
\makebackcover{توضیحات پشت جلد...}
```

---

## Examples

### 1. Complete Documentation
A comprehensive 12-chapter guide covering all MatinBook features:
```bash
cd examples
xelatex -shell-escape matinbook-documentation.tex
```

### 2. Advanced Algorithms Book
A full technical book on algorithms and mathematics (12 chapters + appendices):
```bash
cd examples
xelatex -shell-escape advanced-algorithms-book.tex
biber advanced-algorithms-book
xelatex -shell-escape advanced-algorithms-book.tex
xelatex -shell-escape advanced-algorithms-book.tex
```

---

## Tests

The project includes **15 integration tests** in `tests/v1.2/` and 2 complete examples in `examples/`. The legacy v1.1 test suite is preserved in `tests/archive/v1.1/` for historical reference.

To run all tests:

```bash
cd tests/v1.2
./run-all-tests.sh
```

To run a specific test:

```bash
cd tests/v1.2
./run-all-tests.sh stage08
```

Each test validates a specific module or feature:

| Test | Module | Description |
|------|--------|-------------|
| `stage01-basic` | Core | Basic infrastructure, colors, fonts, math |
| `stage02-fonts` | Fonts | Persian, Latin, Math, Monospace, Code fonts |
| `stage03-layout` | Layout | Page geometry, headers, footers, margin notes |
| `stage04-typography` | Typography | Microtype, line breaking, hyphenation |
| `stage05-math` | Math | Equations, matrices, operators, delimiters |
| `stage06-theorems` | Theorems | All theorem environments and both box families |
| `stage07-boxes` | Boxes | Two box families, all 10 colored box types |
| `stage06-theorems` | Theorems | All theorem environments and both box families |
| `stage08-code` | Code | Syntax highlighting (minted), inline code |
| `stage09-algorithms` | Algorithms | Pseudocode with Persian captions |
| `stage10-tikz` | Graphics | TikZ, PGFPlots, flowcharts, trees, 3D, pie charts |
| `stage11-references` | References | \cref, \crefrange, hyperref, all ref commands |
| `stage12-biblatex` | Bibliography | biblatex + biber, citation commands |
| `stage13-index` | Index | xindy with persian-variant2, sub-entries |
| `stage14-book` | Integration | Full book: all modules together |
| `stage15-cover` | Cover | Front cover, back cover, author bio |

> **Note:** The test runner preserves the `.log` file of any failed test for inspection. All other auxiliary files are removed after the run.

---

## Compilation

### Single Compilation (Simple Documents)
```bash
xelatex -shell-escape document.tex
xelatex -shell-escape document.tex
```

### Full Compilation (with Bibliography and Index)
```bash
# Step 1: First LaTeX compilation
xelatex -shell-escape document.tex

# Step 2: Generate bibliography
biber document

# Step 3: Generate index (xindy is called automatically via shell-escape)

# Step 4: Second compilation (for references)
xelatex -shell-escape document.tex

# Step 5: Third compilation (for table of contents)
xelatex -shell-escape document.tex
```

### Using latexmk (Automated)
```bash
latexmk -xelatex -shell-escape document.tex
```

### Clean Auxiliary Files
```bash
latexmk -c document.tex
```

---

## Customization

### Theme System

MatinBook uses a modular theme system with a single, comprehensive default theme:

**Default Theme** (active by default):
- 20 CMYK colors organized in 5 families (blue, green, orange, red, purple)
- Full-color cover design (front and back)
- Two box families for scientific environments
- Optimized for print (CMYK) and digital output

> **Note:** The color palette follows Iranian educational publishing standards (ز/۱-۴) using CMYK with 5/10 multiples.

To activate the default theme, edit `matinbook.cls`:

```latex
\RequirePackage{mb-theme-default}
```

### Creating a Custom Theme

1. Create a new directory: `tex/themes/mytheme/`
2. Create the following files:
   - `mb-theme-colors.sty` — Define your color palette
   - `mb-theme-cover.sty` — Design your cover
   - `mb-theme-default.sty` — Load all components
3. Activate in `matinbook.cls`:
   ```latex
   \RequirePackage{tex/themes/mytheme/mb-theme-default}
   ```

### Font Selection

Five Persian fonts are supported via class options:

```latex
\documentclass[niloofar]{matinbook}   % XB Niloofar (default)
\documentclass[vazirmatn]{matinbook}  % Vazirmatn
\documentclass[sahel]{matinbook}      % Sahel
\documentclass[irlotus]{matinbook}    % IR Lotus
\documentclass[bnazanin]{matinbook}   % B Nazanin (commercial)
```

### Layout Customization

The default layout uses a **wide outer margin** for margin notes, with a symmetric geometry available for frontmatter:

**Mainmatter (wide margin):**
```latex
\geometry{
    paperwidth=17.8cm,
    paperheight=25.4cm,
    top=1.7cm,
    bottom=1.7cm,
    inner=1.5cm,
    outer=5.9cm,              % wide outer margin
    marginparwidth=3.5cm,     % width of margin note area
    marginparsep=0.6cm,       % gap between text and note
    headheight=15pt,
    headsep=5pt,
    footskip=18pt,
    bindingoffset=0.4cm
}
```

**Frontmatter (symmetric, no wide margin):**
```latex
\frontmattergeometry
% → inner=1.5cm, outer=1.5cm, no marginparwidth
```

The line spacing is set to **1.15** (Boyer/Stewart-style textbook leading).

To customize, edit `tex/modules/layout/mb-layout.sty`.

### Margin Notes

The wide outer margin (5.9cm) provides room for RTL margin notes:

```latex
\mnote{یادداشت حاشیه}                    % plain margin note (no number)
\marginfig{figures/plot.png}{نمودار}     % figure + caption in the margin
```

Margin notes use the standard `\marginpar` with `\RL{}` (from xepersian) to ensure correct RTL direction on both odd and even pages.

---

### Table Customization

MatinBook uses **`tabularray`** for all tables, which is fully
compatible with RTL typesetting. The recommended environment is
`matintable`:

```latex
\begin{matintable}{caption}{label}
\begin{tblr}{
    width = \textwidth,
    colspec = {l l X[c] X[c]},
    hlines, vlines,
    colsep = 8pt,
    rowsep = 4pt,
}
...
\end{tblr}
\end{matintable}
```

**Key options:**

| Option | Effect |
|--------|--------|
| `width = \textwidth` | Table spans the full text width |
| `colspec = {l l X[c] X[c]}` | Column types (`l` = left, `X[c]` = centered flexible) |
| `hlines, vlines` | Horizontal and vertical rules |
| `colsep = 8pt` | Cell padding on each side |
| `rowsep = 4pt` | Vertical space above and below each row |
| `row{1} = {font=\bfseries}` | Bold header row |

To customize, edit `tex/modules/table/mb-table.sty`.

## Contributing

We welcome contributions! Here's how you can help:

### Ways to Contribute
- **Bug reports:** Open an issue on GitHub
- **Feature requests:** Suggest new modules or improvements
- **Code contributions:** Submit pull requests
- **Documentation:** Improve docs, add examples, translate
- **Testing:** Run tests and report issues
- **Fonts:** Add support for new Persian fonts

### Development Guidelines

1. **Module Structure:**
   ```latex
   \NeedsTeXFormat{LaTeX2e}[2023/06/01]
   \ProvidesPackage{mb-myfeature}[2026/10/08 v1.1 MatinBook My Feature]
   
   %========================================================================
   % MB-MYFEATURE — DESCRIPTION
   %========================================================================
   
   % Your module code here...
   
   \PackageInfo{mb-myfeature}{My feature loaded}
   
   \endinput
   ```

2. **Naming Conventions:**
   - Module files: `mb-*.sty`
   - Commands: `\matin@*` (internal), `\*` (user-facing)
   - Colors: `matin*`
   - Counters: `*counter`

3. **Testing:**
   - Add a new stage file in `tests/v1.2/`
   - Increment the stage number
   - Run all tests before submitting

4. **Code Style:**
   - Use 4 spaces for indentation
   - Comment in English
   - Follow LaTeX3 conventions where applicable

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

### v1.1 (Mehr 1405 / مهر ۱۴۰۵)

**Major changes:**
- **Migrated to LaTeX 2023 key-value option system** (`\DeclareKeys`)
- **Converted color palette to CMYK** (per Iranian standard ز/۱-۴)
- **Switched to xindy** for correct Persian index sorting
- **Added xepersian-hm** for Kashida support
- **Removed 6 obsolete modules:** `mb-engine`, `mb-options`, `mb-fonts`, `mb-rtl`, `mb-algorithm`, `mb-colors`
- **Fixed loading order** so colors are defined before consumers
- **Added wide margin layout** (5.9cm outer) with `\mnote{}` and `\marginfig{}{}` for RTL margin notes
- **Added `\frontmattergeometry` / `\mainmattergeometry`** to separate frontmatter and mainmatter geometries
- **Adopted Boyer/Stewart heading scale:** 24/20pt chapter, 15pt section, 13pt subsection, 11pt subsubsection
- **Two box families:** `matinbox` (Boyer-style) and `matin-outline` (RTL outline)
- **Breakable outline boxes** with `underlay first/middle/last`
- **Rewrote `mb-theorem`** using `\newtcolorbox`
- **Redesigned cover** with full-color front and fantasy math band on the back
- **Set line spacing to 1.15** (Boyer/Stewart textbook leading)
- **Fixed cover design** (2-pass compilation, CMYK colors, LTR math symbols)
- **Fixed main.tex structure** per Iranian publishing standards
- **Added 24 integration tests** (was 22)
### v1.2 (Mehr 1405 / مهر ۱۴۰۵) — Current

**Added:**
- **`mb-table`** — New module for table configuration using `tabularray`
- **`\pnum{...}`** — Persian number helper for decimals and thousands separators
- **`\authorbio{...}`** — Author biography block on the back cover
- **`\coverauthorbio`** — Locale string for "About the Author"

**Changed:**
- **Back cover redesign:** Static two-block layout (book blurb + author bio), removed decorative math elements
- **`matin-outline` boxes:** Fixed missing horizontal rules; all lines now 2pt
- **`mb-typography`:** Removed `L/R/C` column types (moved to `mb-table`)
- **`matinbook.cls`:** Loads `mb-table` in Phase 1

**Fixed:**
- **`matin-outline`:** Both horizontal rules (under title and under content) now render in all breakage states
- **Back cover:** No more overflow onto a second page; RTL direction fixed
- **`tabularx` incompatibility** with `xepersian` resolved by switching to `tabularray`

### v1.0 (Summer 1404 / تابستان 1404)

- Initial release

---

## License

MatinBook is released under the **MIT License**. See the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025-2026 Matin Mahmoudi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Acknowledgments

MatinBook is built on the shoulders of giants:

- **XePersian** — Persian typesetting engine by Vafa Khalighi
- **XePersian-HM** — Kashida support by Hassan Mesgarha
- **TColorBox** — Colored box system by Thomas F. Sturm
- **Minted** — Code highlighting by Geoffrey Poore
- **TikZ & PGFPlots** — Graphics by Till Tantau and Christian Feuersänger
- **Tabularray** — Modern table package by Jianrui Lyu
- **Biber & Biblatex** — Bibliography management
- **Hyperref & Cleveref** — Cross-referencing by Heiko Oberdiek and Toby Cubitt
- **Xindy** — Index processing with Persian support

Special thanks to:
- The Persian LaTeX community for years of support and feedback
- All contributors who have helped improve this project
- The open-source community for making tools like LaTeX available to everyone

---

## Contact

- **GitHub:** [github.com/matinmahmoudi-cs/matinbook](https://github.com/matinmahmoudi-cs/matinbook)
- **Issues:** [github.com/matinmahmoudi-cs/matinbook/issues](https://github.com/matinmahmoudi-cs/matinbook/issues)

---

**Made with MatinBook — Written with passion for Persian technical writing.**
