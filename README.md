
```markdown
# MatinBook — A Professional LaTeX Class for Persian Technical Books

**MatinBook** is a modular, feature-rich LaTeX document class designed specifically for writing professional Persian books in programming, mathematics, and computer science. Built with XeLaTeX, it provides a complete typesetting solution with beautiful typography, intelligent cross-referencing, and extensive customization options.

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
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Features

### Core Capabilities
- **Persian-first design:** Full RTL support with proper Persian/Arabic typography
- **Modular architecture:** 20+ independent modules for easy maintenance
- **Professional typography:** Microtype protrusion, widow/orphan control, optimized line breaking
- **Unified theme system:** Professional color palette with full cover design

### Scientific Environments
- **10 colored box types:** Theorems, lemmas, definitions, examples, remarks, exercises, solutions, proofs, and more
- **Mathematics:** Custom operators, smart delimiters, matrix commands, number sets (ℕ, ℤ, ℚ, ℝ, ℂ)
- **Algorithms:** Pseudocode with Persian captions, automatic numbering, list of algorithms
- **Code display:** Syntax highlighting for 300+ languages via `minted`
- **Graphics:** TikZ styles, PGFPlots presets, flowchart and tree templates

### Document Structure
- **Professional cover:** Front and back cover with modern design
- **Table of contents:** Customizable with colored dotted lines
- **Cross-references:** Intelligent referencing with `cleveref` (Persian + English)
- **Bibliography:** Full `biblatex` support with Persian title
- **Index:** Multi-level index with `imakeidx`

### Advanced Features
- **Draft mode:** Watermark and overfull box highlighting
- **Multiple fonts:** XB Niloofar, Vazirmatn, Sahel, IR Lotus
- **Responsive layout:** twoside with binding offset for professional printing
- **Localization:** Persian (fa-IR) and English (en-US) locales

---

## Requirements

### Software
| Tool | Version | Required For |
|------|---------|--------------|
| **XeLaTeX** | Any | Engine (mandatory) |
| **Biber** | 2.x+ | Bibliography processing |
| **MakeIndex** | Any | Index generation |
| **Python 3** | 3.6+ | Pygments (for `minted`) |
| **Pygments** | Latest | Code syntax highlighting |

### Fonts
| Font | Type | Usage |
|------|------|-------|
| **XB Niloofar** | Persian | Default body text |
| **Times New Roman** | Latin | English text |
| **XITS Math** | Math | Mathematical formulas |
| **JetBrains Mono** | Monospace | Code listings |

Optional fonts (selectable via class options):
- **Vazirmatn** — Modern Persian sans-serif
- **Sahel** — Clean Persian font
- **IR Lotus** — Traditional Persian font

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
# Install XB Niloofar
sudo cp fonts/XBNiloofar.ttf /usr/share/fonts/
sudo fc-cache -fv

# Install XITS Math
sudo apt install fonts-xits-math

# Install JetBrains Mono
sudo apt install fonts-jetbrains-mono
```

**On macOS:**
```bash
# Copy fonts to ~/Library/Fonts/
cp fonts/*.ttf ~/Library/Fonts/
```

**On Windows:**
- Right-click each `.ttf` file → Install

### 3. Install Pygments (for code highlighting)
```bash
pip install pygments
```

### 4. Verify Installation
```bash
cd tests
xelatex -shell-escape stage01-basic.tex
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

\begin{document}
    \maketitle
    
    \chapter{فصل اول}
    
    این یک متن نمونه فارسی است.
    این کتاب با MatinBook حروف‌چینی شده است.
    
    \section{بخش اول}
    
    \begin{theorem}[قضیه نمونه]
        این یک قضیه آزمایشی است.
    \end{theorem}
    
    \begin{proof}
        اثبات این قضیه ساده است.
    \end{proof}
\end{document}
```

### Compile
```bash
xelatex -shell-escape my-book.tex
xelatex -shell-escape my-book.tex
```

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
│   ├── core/                    # Core modules (4)
│   │   ├── mb-engine.sty        #   Engine detection
│   │   ├── mb-options.sty       #   Class options
│   │   ├── mb-core.sty          #   Package loader
│   │   └── mb-utils.sty         #   Utility commands
│   │
│   ├── locales/                 # Language files (2)
│   │   ├── fa-IR.sty            #   Persian locale
│   │   └── en-US.sty            #   English locale
│   │
│   ├── modules/                 # Feature modules (11)
│   │   ├── algorithm/           #   Algorithm environments
│   │   ├── boxes/               #   Colored tcolorbox styles
│   │   ├── code/                #   Code listing (minted)
│   │   ├── color/               #   Color definitions
│   │   ├── graphics/            #   TikZ and PGFPlots
│   │   ├── index/               #   Index configuration
│   │   ├── layout/              #   Page layout and headings
│   │   ├── math/                #   Math operators and delimiters
│   │   ├── references/          #   Hyperref and cleveref
│   │   ├── theorem/             #   Theorem environments
│   │   └── typography/          #   Fonts and typography
│   │
│   └── themes/                  # Theme system (1)
│       └── default/             #   Default professional theme
│           ├── colors.sty       #     Color palette
│           ├── fonts.sty        #     Font configuration
│           ├── cover.sty        #     Cover design
│           └── theme.sty        #     Theme loader
│
├── assets/                      # Static assets
│   ├── cover/                   #   Cover images
│   └── images/                  #   Book images
│
├── tests/                       # Integration tests (15)
│   ├── run-all-tests.sh         #   Test runner script
│   ├── stage01-basic.tex        #   Basic infrastructure
│   ├── stage02-fonts.tex        #   Font system
│   ├── stage03-layout.tex       #   Page layout
│   ├── stage04-typography.tex   #   Typography settings
│   ├── stage05-math.tex         #   Mathematics
│   ├── stage06-theorems.tex     #   Theorem environments
│   ├── stage07-boxes.tex        #   Colored boxes
│   ├── stage08-code.tex         #   Code display
│   ├── stage09-algorithms.tex   #   Algorithm environments
│   ├── stage10-tikz.tex         #   Graphics and plots
│   ├── stage11-references.tex   #   Cross-references
│   ├── stage12-biblatex.tex     #   Bibliography
│   ├── stage13-index.tex        #   Index generation
│   ├── stage14-book.tex         #   Complete book
│   └── stage15-cover.tex        #   Cover system
│
└── examples/                    # Example books (2)
    ├── matinbook-documentation.tex  #   Full documentation
    └── advanced-algorithms-book.tex #   Complete sample book
```

---

## Documentation

### Full Documentation
The complete MatinBook user guide is available as a PDF generated from the source:

```bash
cd examples
xelatex -shell-escape matinbook-documentation.tex
biber matinbook-documentation
makeindex matinbook-documentation.idx
xelatex -shell-escape matinbook-documentation.tex
xelatex -shell-escape matinbook-documentation.tex
```

This documentation covers:
- Installation and setup
- Architecture overview (all 20+ modules)
- User guide (writing math, theorems, code, algorithms)
- Theme system and customization
- Development guide
- Troubleshooting

### Quick Reference

#### Class Options
```latex
\documentclass[draft]{matinbook}        % Draft mode
\documentclass[vazirmatn]{matinbook}    % Use Vazirmatn font
\documentclass[sahel]{matinbook}        % Use Sahel font
```

#### Scientific Environments
```latex
\begin{theorem}[Title] ... \end{theorem}
\begin{lemma}[Title] ... \end{lemma}
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
\codecaption{My function}
\label{code:hello}

\inlcode{print("inline")}
\coderef{code:hello}
```

#### Algorithms
```latex
\begin{latin}
\begin{algorithm}
\begin{algorithmic}[1]
    \Require Input description
    \Ensure Output description
    \State $x \gets 1$
    \While{condition}
        \State operation
    \EndWhile
    \State \Return result
\end{algorithmic}
\end{algorithm}
\algcaption[label]{Persian Title}
\end{latin}
```

#### Cross-References
```latex
\meqref{eq:label}     % Equation reference
\thmref{thm:label}    % Theorem reference
\defref{def:label}    % Definition reference
\figref{fig:label}    % Figure reference
\tabref{tab:label}    % Table reference
\coderef{code:label}  % Code reference
\algref{alg:label}    % Algorithm reference
\chref{chap:label}    % Chapter reference
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
makeindex advanced-algorithms-book.idx
xelatex -shell-escape advanced-algorithms-book.tex
xelatex -shell-escape advanced-algorithms-book.tex
```

---

## Tests

The project includes 15 incremental integration tests. To run all tests:

```bash
cd tests
bash run-all-tests.sh
```

Each test validates a specific module or feature combination:

| Test | Module | Description |
|------|--------|-------------|
| stage01 | Core | Basic infrastructure (colors, fonts) |
| stage02 | Fonts | Persian, Latin, math, and code fonts |
| stage03 | Layout | Page geometry, headers, footers |
| stage04 | Typography | Microtype, line breaking, hyphenation |
| stage05 | Math | Equations, matrices, delimiters |
| stage06 | Theorems | All theorem environments |
| stage07 | Boxes | Colored tcolorbox styles |
| stage08 | Code | Syntax highlighting (minted) |
| stage09 | Algorithms | Pseudocode with captions |
| stage10 | Graphics | TikZ, PGFPlots, flowcharts |
| stage11 | References | Hyperref, cleveref cross-references |
| stage12 | Bibliography | Biblatex citations |
| stage13 | Index | Makeindex entries |
| stage14 | Book | Complete book integration |
| stage15 | Cover | Front and back cover |

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

# Step 3: Generate index
makeindex document.idx

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
- Professional colors (15 colors in 5 families)
- Full-featured cover design (front and back)
- Colored boxes for all environments
- Optimized for print and digital output

> **Note:** An earlier "Minimal" theme was removed due to incompatibility issues with the core modules. The default theme is currently the only supported theme.

To activate the default theme, edit `matinbook.cls`:

```latex
% Default theme (active):
\RequirePackage{tex/themes/default/theme}
```

### Creating a Custom Theme

1. Create a new directory: `tex/themes/mytheme/`
2. Create the following files:
   - `colors.sty` — Define your color palette
   - `fonts.sty` — Configure fonts
   - `cover.sty` — Design your cover
   - `theme.sty` — Load all components
3. Activate in `matinbook.cls`:
   ```latex
   \RequirePackage{tex/themes/mytheme/theme}
   ```

### Font Selection

Four Persian fonts are supported via class options:

```latex
\documentclass[niloofar]{matinbook}   % XB Niloofar (default)
\documentclass[vazirmatn]{matinbook}  % Vazirmatn
\documentclass[sahel]{matinbook}      % Sahel
\documentclass[irlotus]{matinbook}    % IR Lotus
```

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
   \NeedsTeXFormat{LaTeX2e}
   \ProvidesPackage{tex/modules/.../mb-myfeature}
   
   % Your module code here...
   
   \endinput
   ```

2. **Naming Conventions:**
   - Module files: `mb-*.sty`
   - Commands: `\matin@*` (internal), `\*` (user-facing)
   - Counters: `*counter`

3. **Testing:**
   - Add a new stage file in `tests/`
   - Increment the stage number
   - Run all tests before submitting

4. **Code Style:**
   - Use 4 spaces for indentation
   - Comment in English
   - Follow LaTeX3 conventions where applicable

---

## License

MatinBook is released under the **MIT License**. See the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025-2026 MatinBook Project

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files...
```

---

## Acknowledgments

MatinBook is built on the shoulders of giants:

- **XePersian** — Persian typesetting engine by Vafa Khalighi
- **TColorBox** — Colored box system by Thomas F. Sturm
- **Minted** — Code highlighting by Geoffrey Poore
- **TikZ & PGFPlots** — Graphics by Till Tantau and Christian Feuersänger
- **Biber & Biblatex** — Bibliography management
- **Hyperref & Cleveref** — Cross-referencing by Heiko Oberdiek and Toby Cubitt

Special thanks to:
- The Persian LaTeX community for years of support and feedback
- All contributors who have helped improve this project
- The open-source community for making tools like LaTeX available to everyone

---

## Contact

- **GitHub:** [github.com/matinbook](https://github.com/matinbook)
- **Issues:** [github.com/matinbook/issues](https://github.com/matinbook/issues)
- **Email:** matinbook@example.com

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

**Current Version:** 1.0 (Summer 2026 / تابستان ۱۴۰۵)

---

**Made with MatinBook — Written with passion for Persian technical writing.**
```

---


