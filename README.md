# MatinBook — A Professional LaTeX Class for Persian Technical Books

**MatinBook** is a modular, feature-rich LaTeX document class designed specifically for writing professional Persian books in programming, mathematics, and computer science. Built with XeLaTeX, it provides a complete typesetting solution with beautiful typography, intelligent cross-referencing, and extensive customization options.

**Current version:** v1.1 (Mehr 1405 / مهر ۱۴۰۵)

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
- **Modular architecture:** 18 independent modules for easy maintenance
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

### Document Structure
- **Professional cover:** Full-color front cover with math/code symbols and a fantasy math band on the back cover (requires 2 compilation passes)
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
git clone https://github.com/matinbook/matinbook.git
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
cd tests/v1.1
./compile.sh stage-cls-01.tex
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
├── tests/                       # Integration tests (24)
│   ├── v1.1/                    #   v1.1-specific tests
│   │   ├── compile.sh           #     Test compiler script
│   │   ├── stage-cls-01.tex
│   │   ├── stage-packages-01.tex
│   │   ├── stage-options-01.tex
│   │   ├── stage-core-01.tex
│   │   ├── stage-utils-01.tex
│   │   ├── stage-rtl-01.tex
│   │   ├── stage-locale-01.tex
│   │   ├── stage-locale-en-01.tex
│   │   ├── stage-typography-01.tex
│   │   ├── stage-layout-01.tex
│   │   ├── stage-headings-01.tex
│   │   ├── stage-math-01.tex
│   │   ├── stage-boxes-01.tex
│   │   ├── stage-theorem-01.tex
│   │   ├── stage-code-01.tex
│   │   ├── stage-algorithm-01.tex
│   │   ├── stage-graphics-01.tex
│   │   ├── stage-index-01.tex
│   │   ├── stage-colors-01.tex
│   │   ├── stage-theme-default-01.tex
│   │   ├── stage-cover-01.tex
│   │   ├── stage-main-01.tex
│   │   └── stage-margin-01.tex  # ← margin notes test
│   └── (legacy stage01-15 tests)
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
- Architecture overview (all 18 modules)
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

The project includes 24 incremental integration tests in `tests/v1.1/`. To run all tests:

```bash
cd tests/v1.1
./compile.sh
```

Each test validates a specific module or feature:

| Test | Module | Description |
|------|--------|-------------|
| `stage-cls-01` | Class | Basic infrastructure |
| `stage-packages-01` | Packages | Package loading conventions |
| `stage-options-01` | Options | Key-value option system |
| `stage-core-01` | Core | Core package loader |
| `stage-utils-01` | Utils | Utility macros |
| `stage-rtl-01` | RTL | RTL/Bidi support |
| `stage-locale-01` | fa-IR | Persian locale |
| `stage-locale-en-01` | en-US | English locale |
| `stage-typography-01` | Typography | Microtype, Kashida, line breaking |
| `stage-layout-01` | Layout | Page geometry, headers, footers |
| `stage-headings-01` | Headings | Chapter/section styles |
| `stage-math-01` | Math | Equations, matrices, delimiters |
| `stage-boxes-01` | Boxes | Two box families, breakable boxes |
| `stage-theorem-01` | Theorem | All theorem environments |
| `stage-code-01` | Code | Syntax highlighting (minted) |
| `stage-algorithm-01` | Algorithm | Pseudocode with Persian captions |
| `stage-graphics-01` | Graphics | TikZ, PGFPlots, flowcharts |
| `stage-index-01` | Index | Xindy with persian-variant2 |
| `stage-colors-01` | Colors | CMYK color palette |
| `stage-theme-default-01` | Theme | Theme loader |
| `stage-cover-01` | Cover | Front and back cover |
| `stage-main-01` | Main | Full book structure |
| **`stage-margin-01`** | **Layout** | **Margin notes, RTL direction, odd/even pages** |

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
   \NeedsTeXFormat{LaTeX2e}[2020/10/01]
   \ProvidesPackage{mb-myfeature}[2026/01/01 v1.1 MatinBook My Feature]
   
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
   - Add a new stage file in `tests/v1.1/`
   - Increment the stage number
   - Run all tests before submitting

4. **Code Style:**
   - Use 4 spaces for indentation
   - Comment in English
   - Follow LaTeX3 conventions where applicable

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

### v1.1 (Mehr 1405 / مهر ۱۴۰۵) — Current

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

### v1.0 (Summer 1404 / تابستان ۱۴۰۴)

- Initial release

---

## License

MatinBook is released under the **MIT License**. See the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025-2026 MatinBook Project

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
- **Biber & Biblatex** — Bibliography management
- **Hyperref & Cleveref** — Cross-referencing by Heiko Oberdiek and Toby Cubitt
- **Xindy** — Index processing with Persian support

Special thanks to:
- The Persian LaTeX community for years of support and feedback
- All contributors who have helped improve this project
- The open-source community for making tools like LaTeX available to everyone

---

## Contact

- **GitHub:** [github.com/matinbook](https://github.com/matinbook)
- **Issues:** [github.com/matinbook/issues](https://github.com/matinbook/issues)

---

**Made with MatinBook — Written with passion for Persian technical writing.**
