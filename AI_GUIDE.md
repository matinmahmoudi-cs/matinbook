```markdown
# MatinBook — AI Content Generation Guide

## Complete Reference for AI-Assisted Academic Book Writing

**Version:** 1.0
**Target:** Persian technical books in programming, mathematics, and computer science
**Engine:** XeLaTeX (mandatory)
**Last Updated:** 2026

---

## Table of Contents

### Part I: Foundation
1. [Overview](#overview)
2. [Project Architecture](#project-architecture)
3. [Class System and Loading Order](#class-system-and-loading-order)

### Part II: Reference
4. [Available Environments](#available-environments)
5. [Custom Commands Reference](#custom-commands-reference)
6. [Color System](#color-system)
7. [Typography and Fonts](#typography-and-fonts)
8. [Page Layout](#page-layout)
9. [Mathematics](#mathematics)
10. [Code Display](#code-display)
11. [Algorithms and Pseudocode](#algorithms-and-pseudocode)
12. [Graphics and Diagrams](#graphics-and-diagrams)
13. [Cross-References](#cross-references)
14. [Bibliography](#bibliography)
15. [Index Generation](#index-generation)
16. [Cover System](#cover-system)
17. [Theme System](#theme-system)
18. [Localization](#localization)

### Part III: Academic Writing Standards
19. [Professional Writing Rules](#professional-writing-rules)
20. [Visual Hierarchy and Balance](#visual-hierarchy-and-balance)
21. [Content Density Guidelines](#content-density-guidelines)
22. [Mathematical Writing Standards](#mathematical-writing-standards)
23. [Algorithm Presentation Standards](#algorithm-presentation-standards)
24. [Code Presentation Standards](#code-presentation-standards)
25. [Figure and Table Standards](#figure-and-table-standards)
26. [Citation and Reference Standards](#citation-and-reference-standards)

### Part IV: Implementation
27. [Content Generation Rules](#content-generation-rules)
28. [File Structure Templates](#file-structure-templates)
29. [Compilation Instructions](#compilation-instructions)
30. [Common Patterns and Recipes](#common-patterns-and-recipes)
31. [Error Prevention Guide](#error-prevention-guide)
32. [Complete Example](#complete-example)

---

# Part I: Foundation

## 1. Overview

MatinBook is a professional LaTeX document class (`matinbook.cls`) designed for writing Persian technical books in programming, mathematics, and computer science. It requires **XeLaTeX** as the compilation engine and provides a modular architecture with 20+ independent modules.

### Design Philosophy

MatinBook follows three core principles inspired by top-tier academic publishers (MIT Press, Springer, Oxford University Press):

1. **Clarity over decoration** — Visual elements serve content, not the reverse
2. **Consistency over novelty** — Every element has one canonical form
3. **Restraint over excess** — Less is more; whitespace is a design element

### Key Principles for AI Content Generation

1. **All Persian text is written normally** — no special markup needed for Persian body text
2. **English/Latin text within Persian paragraphs** must be wrapped in `\lr{}` command
3. **All environments for code, algorithms, and Latin text** must be wrapped in `\begin{latin}...\end{latin}`
4. **Never use Persian text inside `minted` code blocks** — comments must be in English
5. **Algorithm captions (`\algcaption`) must be placed OUTSIDE the `latin` environment**
6. **Theorem-like environments have Persian titles** — defined in `fa-IR.sty`
7. **All cross-references use Persian prefixes** (e.g., "قضیه", "تعریف", "الگوریتم")
8. **Follow the 60-30-10 rule for content density** (see [Section 21](#content-density-guidelines))

---

## 2. Project Architecture

### Directory Structure

```
matinbook/
├── matinbook.cls                    # Main class file (entry point)
├── main.tex                         # Template main file
├── references.bib                   # Sample bibliography
├── CHANGELOG.md                     # Version history
├── LICENSE                          # MIT License
├── README.md                        # Project overview
├── AI_GUIDE.md                      # This file
│
├── tex/
│   ├── core/                        # 4 core modules
│   │   ├── mb-engine.sty            # Engine detection (XeLaTeX only)
│   │   ├── mb-options.sty           # Class option processing
│   │   ├── mb-core.sty              # Package loader (order matters)
│   │   └── mb-utils.sty             # Utility commands
│   ├── locales/                     # 2 locale files
│   │   ├── fa-IR.sty                # Persian translations
│   │   └── en-US.sty                # English translations
│   ├── modules/                     # 11 feature modules
│   │   ├── algorithm/mb-algorithm.sty
│   │   ├── boxes/mb-boxes.sty
│   │   ├── code/mb-code.sty
│   │   ├── color/mb-colors.sty
│   │   ├── graphics/mb-graphics.sty
│   │   ├── index/mb-index.sty
│   │   ├── layout/
│   │   │   ├── mb-layout.sty
│   │   │   └── mb-headings.sty
│   │   ├── math/mb-math.sty
│   │   ├── references/mb-references.sty
│   │   ├── theorem/mb-theorem.sty
│   │   └── typography/
│   │       ├── mb-fonts.sty
│   │       ├── mb-rtl.sty
│   │       └── mb-typography.sty
│   └── themes/                      # 1 theme
│       └── default/
│           ├── colors.sty
│           ├── fonts.sty
│           ├── cover.sty
│           └── theme.sty
│
├── assets/
│   ├── cover/
│   └── images/
│
├── tests/                           # 15 integration tests
│   ├── run-all-tests.sh
│   ├── stage01-basic.tex
│   ├── stage02-fonts.tex
│   ├── stage03-layout.tex
│   ├── stage04-typography.tex
│   ├── stage05-math.tex
│   ├── stage06-theorems.tex
│   ├── stage07-boxes.tex
│   ├── stage08-code.tex
│   ├── stage09-algorithms.tex
│   ├── stage10-tikz.tex
│   ├── stage11-references.tex
│   ├── stage12-biblatex.tex
│   ├── stage13-index.tex
│   ├── stage14-book.tex
│   └── stage15-cover.tex
│
└── examples/                        # 2 example books
    ├── matinbook-documentation.tex
    └── advanced-algorithms-book.tex
```

### Module Loading Order (Critical!)

```
1.  mb-engine      → Detect XeLaTeX
2.  mb-options     → Process class options
3.  book class     → Base LaTeX book class
4.  mb-core        → Load ALL packages
5.  mb-rtl         → xepersian (RTL support)
6.  mb-colors      → Color definitions
7.  mb-fonts       → Font configuration
8.  mb-typography  → Microtype settings
9.  mb-layout      → Page geometry
10. mb-headings    → Chapter/section styles
11. mb-math        → Math operators
12. mb-boxes       → tcolorbox styles
13. mb-theorem     → Theorem environments
14. mb-code        → minted configuration
15. mb-algorithm   → Algorithm environments
16. fa-IR          → Persian locale
17. mb-references  → hyperref + cleveref
18. mb-graphics    → TikZ + PGFPlots
19. mb-index       → imakeidx
20. mb-utils       → Utility commands
21. Theme          → Default theme
```

> ⚠️ **CRITICAL:** Changing this order will break the class. The order is designed to resolve dependencies correctly (e.g., `mb-rtl` must load before `mb-references` because hyperref needs RTL support).

---

## 3. Class System and Loading Order

### Class Declaration

```latex
\documentclass[options]{matinbook}
```

### Available Options

| Option | Effect | Default |
|--------|--------|---------|
| `draft` | Draft mode with watermark | `final` |
| `final` | Final mode | ✓ |
| `vazirmatn` | Use Vazirmatn Persian font | |
| `sahel` | Use Sahel Persian font | |
| `irlotus` | Use IR Lotus Persian font | |
| `niloofar` | Use XB Niloofar | ✓ |

### Base Packages (Loaded in `mb-core.sty`)

```
graphicx, xcolor, fontspec, microtype,
mathtools, amsmath, amssymb, amsthm, unicode-math,
algorithm, algpseudocode,
tcolorbox (with 'most' library),
minted,
biblatex (backend=biber, style=numeric, sorting=none),
imakeidx,
geometry, fancyhdr, titlesec, tocloft,
setspace, caption, footmisc,
booktabs, array, multirow,
hyperref, cleveref,
tikz, pgfplots
```

### Enhanced Column Types for Tables

```latex
L{width}  → Left-aligned paragraph column (English)
R{width}  → Right-aligned paragraph column (Persian)
C{width}  → Center-aligned paragraph column (mixed)
```

> 💡 **Tip:** Use `C{width}` for Persian text, `l` for English/numeric, `c` for short symbols.

---

# Part II: Reference

## 4. Available Environments

### Theorem Family (Blue Theme)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `theorem` | theoremcounter | matinblue | قضیه |
| `lemma` | theoremcounter | matinblue!70 | لم |
| `corollary` | theoremcounter | matinblue!50 | نتیجه |
| `proposition` | theoremcounter | matindarkblue | گزاره |
| `proof` | (none) | matinblue!30 | اثبات |

### Definition Family (Green Theme)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `definition` | definitioncounter | matingreen | تعریف |

### Example Family (Orange Theme)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `example` | examplecounter | matinorange | مثال |

### Remark Family (Red Theme)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `remark` | remarkcounter | matinred | نکته |

### Exercise Family (Purple Theme)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `exercise` | exercisecounter | matinpurple | تمرین |
| `solution` | (none) | matingreen!60 | راه حل |

### Usage Pattern

```latex
\begin{theorem}[Optional Title]
    Theorem content...
    \label{thm:my-theorem}
\end{theorem}

\begin{proof}
    Proof content...
\end{proof}

\begin{definition}[Optional Title]
    Definition content...
    \label{def:my-definition}
\end{definition}

\begin{example}[Optional Title]
    Example content...
    \label{ex:my-example}
\end{example}

\begin{remark}
    Remark content...
    \label{rem:my-remark}
\end{remark}

\begin{exercise}
    Exercise content...
    \label{exc:my-exercise}
\end{exercise}

\begin{solution}
    Solution content...
\end{solution}
```

### CRITICAL: Label Placement

Labels MUST be placed INSIDE the environment, AFTER any optional title argument:

```latex
% CORRECT:
\begin{theorem}[Fundamental Theorem]
    Content...
    \label{thm:fundamental}
\end{theorem}

% WRONG (label outside):
\begin{theorem}[Fundamental Theorem]
    Content...
\end{theorem}
\label{thm:fundamental}
```

---

## 5. Custom Commands Reference

### Document Structure Commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `\makecover{t}{s}{a}{d}` | Title, Subtitle, Author, Date | Front cover |
| `\makebackcover{text}` | Back cover text | Back cover |
| `\maketitle` | (none) | Title page |
| `\tableofcontents` | (none) | Table of contents |
| `\listoffigures` | (none) | List of figures |
| `\listoftables` | (none) | List of tables |
| `\listofalgorithms` | (none) | List of algorithms |
| `\printindex` | (none) | Print index |
| `\printbibliography` | (none) | Print bibliography |

### Bilingual Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `\lr{text}` | `\lr{computer}` | Inline Latin text in Persian |
| `\begin{latin}...\end{latin}` | Environment | Block of Latin text |

### Code Display Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `\inlcode{text}` | `\inlcode{print()}` | Inline monospace code |
| `\codecaption{title}` | `\codecaption{My function}` | Code caption with numbering |
| `\coderef{label}` | `\coderef{code:hello}` | Reference to code listing |

### Algorithm Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `\algcaption[label]{title}` | `\algcaption[alg:sort]{مرتب‌سازی}` | Algorithm caption |
| `\algref{label}` | `\algref{alg:sort}` | Reference to algorithm |

### Reference Commands

| Command | Output Example |
|---------|----------------|
| `\meqref{eq:label}` | معادله ۱.۱ |
| `\thmref{thm:label}` | قضیه ۱.۱ |
| `\lemref{lem:label}` | لم ۱.۱ |
| `\corref{cor:label}` | نتیجه ۱.۱ |
| `\defref{def:label}` | تعریف ۱.۱ |
| `\exref{ex:label}` | مثال ۱.۱ |
| `\figref{fig:label}` | شکل ۱.۱ |
| `\tabref{tab:label}` | جدول ۱.۱ |
| `\coderef{code:label}` | کد ۱.۱ |
| `\algref{alg:label}` | الگوریتم ۱.۱ |
| `\chref{chap:label}` | فصل ۱ |
| `\secref{sec:label}` | بخش ۱.۱ |

### Mathematics Commands

| Command | Output | Description |
|---------|--------|-------------|
| `\N, \Z, \Q, \R, \C` | ℕ, ℤ, ℚ, ℝ, ℂ | Number sets |
| `\abs{x}` | \|x\| | Absolute value |
| `\norm{x}` | ‖x‖ | Norm |
| `\ceil{x}` | ⌈x⌉ | Ceiling |
| `\floor{x}` | ⌊x⌋ | Floor |
| `\inner{u}{v}` | ⟨u,v⟩ | Inner product |
| `\set{1,2,3}` | {1,2,3} | Set |
| `\setbuilder{x}{x>0}` | {x \| x>0} | Set builder |
| `\paren{x}` | (x) | Smart parentheses |
| `\mat{1&2\\3&4}` | [matrix] | Bracketed matrix |
| `\pmat{1&2\\3&4}` | (matrix) | Parenthesized matrix |
| `\vmat{1&2\\3&4}` | \|matrix\| | Determinant |
| `\grad` | grad | Gradient |
| `\curl` | curl | Curl |
| `\diver` | div | Divergence |
| `\rank` | rank | Rank |
| `\trace` | trace | Trace |
| `\diag` | diag | Diagonal |
| `\gcdop` | gcd | GCD |
| `\lcm` | lcm | LCM |
| `\sinc` | sinc | Sinc function |
| `\sgn` | sgn | Sign function |
| `\erf` | erf | Error function |
| `\deriv{}{x}` | d/dx | Ordinary derivative |
| `\pderiv{f}{x}` | ∂f/∂x | Partial derivative |
| `\dd{x}` | dx | Differential |
| `\given` | \| | Set builder separator |

### Index Commands

| Command | Usage |
|---------|-------|
| `\index{term}` | Main entry |
| `\index{term!subterm}` | Sub-entry |
| `\index{term!sub!subsub}` | Sub-sub-entry |
| `\idxbold{term}` | Bold entry |
| `\idxsee{from}{to}` | See reference |
| `\idxseealso{from}{to}` | See also reference |
| `\idxsub{main}{sub}` | Quick sub-entry |
| `\idxsubsub{main}{sub}{subsub}` | Quick sub-sub-entry |

---

## 6. Color System

### 15 Defined Colors (5 Families × 3 Shades)

#### Blue Family (Theorems)
```latex
matinblue        RGB(41, 128, 185)    % Primary
matindarkblue    RGB(21, 67, 96)      % Dark
matinlightblue   RGB(214, 234, 248)   % Light
```

#### Green Family (Definitions)
```latex
matingreen       RGB(39, 174, 96)     % Primary
matindarkgreen   RGB(20, 90, 50)      % Dark
matinlightgreen  RGB(215, 245, 227)   % Light
```

#### Orange Family (Examples)
```latex
matinorange      RGB(230, 126, 34)    % Primary
matindarkorange  RGB(120, 66, 18)     % Dark
matinlightorange RGB(252, 235, 213)   % Light
```

#### Red Family (Remarks)
```latex
matinred         RGB(231, 76, 60)     % Primary
matindarkred     RGB(120, 40, 31)     % Dark
matinlightred    RGB(250, 215, 210)   % Light
```

#### Purple Family (Exercises)
```latex
matinpurple      RGB(142, 68, 173)    % Primary
matindarkpurple  RGB(74, 35, 90)      % Dark
matinlightpurple RGB(235, 222, 245)   % Light
```

#### Neutral Colors
```latex
matindarkgray    RGB(44, 62, 80)      % Text
matinmediumgray  RGB(149, 165, 166)   % Secondary text
matinlightgray   RGB(236, 240, 241)   % Background
matinbordergray  RGB(189, 195, 199)   % Borders
```

### Color Usage

```latex
\textcolor{matinblue}{Text}           % Colored text
\colorbox{matinlightblue}{Text}       % Colored background
\color{matinred}                      % Switch color
```

### Color Rules for Academic Writing

1. **Never use more than 3 colors on a single page** (excluding box colors)
2. **Use colors semantically, not decoratively** — blue for theorems, green for definitions, etc.
3. **Maintain 4.5:1 contrast ratio** for accessibility (all MatinBook colors comply)
4. **Avoid pure black on pure white** — use `matindarkgray` (RGB 44,62,80) for body text

---

## 7. Typography and Fonts

### Font Configuration

| Type | Font | Features |
|------|------|----------|
| Persian text | XB Niloofar (default) | Scale=1.2 |
| Latin text | Times New Roman | No ligatures |
| Mathematics | XITS Math | unicode-math |
| Code | JetBrains Mono | Scale=0.9 |

### Typography Settings

```latex
\microtypesetup{
    protrusion=true,    % Character protrusion
    expansion=false,    % XeTeX limitation
    tracking=false,
    kerning=false,
    spacing=false,
    final
}

\widowpenalty=10000     % Prevent widow lines
\clubpenalty=10000      % Prevent orphan lines
\emergencystretch=3em   % Emergency line stretch
\tolerance=3000         % Line breaking tolerance
\setstretch{1.15}       % Line spacing
```

### Typography Rules for Academic Writing

1. **Line length:** 60-75 characters per line (MatinBook: ~70 with A4 + 2.5cm margins)
2. **Line spacing:** 1.15 (MatinBook default) — optimal for Persian script
3. **Paragraph spacing:** `\parskip=0pt plus 1pt` — subtle, not distracting
4. **First-line indent:** `\parindent=1em` — Persian standard
5. **No first-line indent after headings** — MatinBook handles this automatically

---

## 8. Page Layout

### Geometry

```latex
\geometry{
    a4paper,
    left=2.5cm,
    right=2.5cm,
    top=2.5cm,
    bottom=2.5cm,
    bindingoffset=1cm,  % Extra space for binding
    headheight=18pt,
    headsep=10pt,
    footskip=30pt
}
```

### Header/Footer (twoside)

- **Odd pages:** Chapter name (right), page number (left)
- **Even pages:** Page number (right), section name (left)
- **Chapter start pages:** Footer only (plain style)

### Page Layout Standards (Inspired by MIT Press / Springer)

| Element | Standard | MatinBook |
|---------|----------|-----------|
| Paper | A4 (210×297mm) | ✓ |
| Margins | 2.5cm | ✓ |
| Binding offset | 1cm | ✓ |
| Body text width | ~16cm | ✓ |
| Body text height | ~22cm | ✓ |
| Header height | 18pt | ✓ |
| Footer skip | 30pt | ✓ |

---

## 9. Mathematics

### Equation Numbering

Equations are numbered by chapter: `\numberwithin{equation}{chapter}`

### Allowed Display Breaks

`\allowdisplaybreaks` is enabled — long align environments can break across pages.

### Math Spacing

```latex
\thinmuskip=3mu
\medmuskip=4mu plus 2mu minus 4mu
\thickmuskip=5mu plus 5mu
```

---

## 10. Code Display

### Configuration (in `mb-code.sty`)

```latex
\setminted{
    fontsize=\small,
    linenos=true,
    numbersep=8pt,
    frame=single,
    framesep=10pt,
    rulecolor=\color{matinbordergray},
    bgcolor=matinlightgray!20,
    breaklines=true,
    breakanywhere=true,
    autogobble=true,
    tabsize=4,
    python3=true
}
```

### Code Block Pattern

```latex
\begin{latin}
\begin{minted}{python}
def function_name(args):
    """Docstring in English."""
    # Comments MUST be in English
    return result
\end{minted}
\end{latin}
\codecaption{Persian caption for the code}
\label{code:unique-label}
```

### Inline Code

```latex
The \inlcode{function_name()} does something.
```

### Supported Languages

All languages supported by Pygments (300+): `python`, `cpp`, `java`, `javascript`, `rust`, `go`, `bash`, `latex`, `text`, etc.

---

## 11. Algorithms and Pseudocode

### Algorithm Pattern (CRITICAL — must follow exactly)

```latex
\begin{latin}
\begin{algorithm}
\begin{algorithmic}[1]
    \Require Input description (in English)
    \Ensure Output description (in English)
    \State $x \gets 1$
    \For{$i \gets 1$ \textbf{to} $n$}
        \If{condition}
            \State operation
        \EndIf
    \EndFor
    \State \Return $result$
\end{algorithmic}
\end{algorithm}
\end{latin}
\algcaption[alg:unique-label]{عنوان فارسی الگوریتم}
```

### RULES FOR ALGORITHMS

1. `\algcaption` MUST be OUTSIDE `\begin{latin}...\end{latin}`
2. All pseudocode text inside `algorithmic` MUST be in English
3. The caption argument to `\algcaption` is in Persian
4. Every `\If` must have `\EndIf`
5. Every `\For` must have `\EndFor`
6. Every `\While` must have `\EndWhile`
7. Every `\Function` must have `\EndFunction`
8. Every `\ForAll` must have `\EndFor`
9. `\Return` inside `\If` still requires `\EndIf` before the next statement
10. Optional label goes in square brackets: `\algcaption[alg:myalgo]{Title}`

### Available Algorithmic Commands

```latex
\Require, \Ensure          % Pre/post conditions
\State                    % Simple statement
\If, \ElsIf, \Else, \EndIf % Conditionals
\For, \EndFor             % For loops
\ForAll, \EndFor          % For-all loops
\While, \EndWhile         % While loops
\Repeat, \Until           % Repeat-until loops
\Function, \EndFunction   % Function definitions
\Call{name}{args}         % Function calls
\Return                   % Return statement
\Statex                   % Unnumbered statement
\Comment{text}            % Inline comment
\textbf{text}             % Bold text
\text{text}               % Normal text
```

---

## 12. Graphics and Diagrams

### Available TikZ Libraries

```
shapes, arrows, positioning, calc, patterns,
decorations.pathreplacing, decorations.pathmorphing,
decorations.markings, backgrounds, fit, matrix,
mindmap, trees, shadows, arrows.meta, quotes,
graphs, graphs.standard
```

### Custom TikZ Styles

```latex
% Flowchart blocks
block/.style={
    rectangle, draw=matindarkblue,
    fill=matinlightblue!20,
    text width=6em, text centered,
    rounded corners, minimum height=3em
}

% Decision diamond
decision/.style={
    diamond, draw=matinorange,
    fill=matinlightorange!20,
    text width=3em, text centered,
    inner sep=0pt
}

% Arrow
arrow/.style={thick,->,>=stealth}

% Tree node
treenode/.style={
    circle, draw=matinblue,
    fill=matinlightblue!30,
    minimum size=0.8cm
}
```

### PGFPlots Settings

```latex
% Default axis style
every axis/.style={
    grid=major,
    grid style={dashed, gray!30},
    axis lines=center,
    axis line style={-stealth, thick}
}

% Color cycle
cycle list name=matinbook  % 8 predefined colors
```

### Graphics Path

```latex
\graphicspath{
    {assets/images/}
    {assets/cover/}
    {images/}
    {figures/}
}
```

### Figure Pattern

```latex
\begin{figure}[h]
\centering
\begin{latin}
\begin{tikzpicture}
    % Drawing commands here
\end{tikzpicture}
\end{latin}
\caption{Persian figure caption}
\label{fig:unique-label}
\end{figure}
```

---

## 13. Cross-References

### Label Naming Convention

```latex
\label{eq:einstein}          % Equations
\label{thm:fundamental}      % Theorems
\label{lem:euclid}           % Lemmas
\label{cor:mycor}            % Corollaries
\label{prop:myprop}          % Propositions
\label{def:prime}            % Definitions
\label{ex:myexample}         % Examples
\label{rem:myremark}         % Remarks
\label{exc:myexercise}       % Exercises
\label{fig:mychart}          % Figures
\label{tab:mytable}          % Tables
\label{code:mycode}          % Code listings
\label{alg:myalgo}           % Algorithms
\label{chap:mychapter}       % Chapters
\label{sec:mysection}        % Sections
```

### Cleveref Integration

The `cleveref` package is configured with Persian names through `fa-IR.sty`. The `\cref` command automatically detects the counter type and adds the appropriate Persian prefix.

---

## 14. Bibliography

### Configuration

```latex
% In preamble:
\addbibresource{references.bib}

% In document (must be inside latin environment):
\begin{latin}
\printbibliography[title={منابع و مراجع}]
\end{latin}
```

### Settings

```latex
backend=biber
style=numeric
sorting=none  % Citation order
```

### Citation Commands

```latex
\cite{key}            % [1]
\parencite{key}       % [1]
\textcite{key}        % Author [1]
\autocite{key}        % Auto-detected
```

### Sample .bib Entries

```bibtex
@book{knuth1984,
    author    = {Donald E. Knuth},
    title     = {The TeXbook},
    year      = {1984},
    publisher = {Addison-Wesley}
}

@article{einstein1905,
    author  = {Albert Einstein},
    title   = {On the Electrodynamics of Moving Bodies},
    journal = {Annalen der Physik},
    year    = {1905}
}
```

---

## 15. Index Generation

### Configuration

```latex
\makeindex[intoc]  % Include index in table of contents
```

### Entry Types

```latex
\index{term}                      % Main entry
\index{term!subterm}              % Sub-entry
\index{term!sub!subsub}           % Sub-sub-entry
\index{term|textbf}               % Bold page number
\idxbold{term}                    % Bold entry helper
\idxsee{from}{to}                 % Cross-reference
\idxseealso{from}{to}             % See also reference
\idxsub{main}{sub}                % Quick sub-entry
\idxsubsub{main}{sub}{subsub}     % Quick sub-sub-entry
```

### Compilation

```bash
makeindex filename.idx
```

---

## 16. Cover System

### Front Cover

```latex
\makecover
{Book Title}
{Book Subtitle}
{Author Name}
{Date/Version}
```

### Back Cover

```latex
\makebackcover{%
    Back cover description text.
    Can include \textbf{formatting},
    \begin{itemize}
        \item bullet points
        \item and more
    \end{itemize}
}
```

---

## 17. Theme System

### Default Theme

- 15 professional colors (5 families × 3 shades)
- Full front and back cover
- Colored chapter headings
- Styled table of contents
- Colored boxes for all environments

> **Note:** An earlier "Minimal" theme was removed due to incompatibility issues with the core modules. The default theme is currently the only supported theme.

### Theme Switching

Edit `matinbook.cls`:

```latex
% Default theme:
\RequirePackage{tex/themes/default/theme}
```

---

## 18. Localization

### Persian Locale (fa-IR.sty)

All document element names are translated to Persian:

```
contentsname        → فهرست مطالب
listfigurename      → فهرست تصاویر
listtablename       → فهرست جداول
listalgorithmname   → فهرست الگوریتم‌ها
bibname             → منابع و مراجع
indexname           → نمایه
chaptername         → فصل
appendixname        → پیوست
proofname           → اثبات
figurename          → شکل
tablename           → جدول
algorithmname       → الگوریتم
seename             → نگاه کنید به
alsoname            → همچنین نگاه کنید به
```

### English Locale (en-US.sty)

Standard English names for all elements.

---

# Part III: Academic Writing Standards

## 19. Professional Writing Rules

These rules are inspired by the style guides of MIT Press, Springer, Oxford University Press, and the Chicago Manual of Style.

### Rule 1: One Idea Per Paragraph

Each paragraph should develop **one** main idea. If you find yourself switching topics mid-paragraph, start a new paragraph.

**Guideline:** 3-7 sentences per paragraph for technical content.

### Rule 2: Topic Sentence First

The first sentence of each paragraph should state the main idea. Subsequent sentences provide support, examples, or elaboration.

```latex
% GOOD:
الگوریتم دایکسترا یک الگوریتم حریصانه برای یافتن کوتاه‌ترین مسیر است.
این الگوریتم در هر گام، نزدیک‌ترین راس برش‌ندیده را انتخاب می‌کند.
پیچیدگی زمانی آن با هیپ دودویی $O((V+E)\log V)$ است.

% BAD:
این الگوریتم در هر گام نزدیک‌ترین راس را انتخاب می‌کند.
پیچیدگی آن $O((V+E)\log V)$ است.
الگوریتم دایکسترا یک الگوریتم حریصانه است.
```

### Rule 3: Active Voice Over Passive

Prefer active voice for clarity. Use passive only when the actor is unknown or unimportant.

```latex
% GOOD (active):
الگوریتم داده‌ها را مرتب می‌کند.

% LESS GOOD (passive):
داده‌ها توسط الگوریتم مرتب می‌شوند.
```

### Rule 4: Define Before Use

Every technical term must be defined (via `\begin{definition}`) before its first use in the text.

```latex
% GOOD:
\begin{definition}[گراف]
    گراف $G = (V, E)$ مجموعه‌ای از رئوس $V$
    و یال‌های $E$ است.
    \label{def:graph}
\end{definition}

طبق \defref{def:graph}، ...

% BAD:
گراف $G = (V, E)$ را در نظر بگیرید.  % گراف تعریف نشده!
```

### Rule 5: Consistent Terminology

Use the same term for the same concept throughout the book. Maintain a glossary or index.

| Concept | Use | Don't Use |
|---------|-----|-----------|
| Algorithm | الگوریتم | رویه، روش، تابع |
| Definition | تعریف | توصیف |
| Theorem | قضیه | حکم |
| Proof | اثبات | برهان |
| Complexity | پیچیدگی | سختی |

### Rule 6: Avoid Orphan and Widow Lines

MatinBook handles this automatically via `\widowpenalty=10000` and `\clubpenalty=10000`. But be aware: if you force line breaks (`\\`), you may create them.

### Rule 7: No Stacked Headings

Never place a subsection immediately after a section heading without intervening text.

```latex
% GOOD:
\section{مقدمه}
این فصل به بررسی... می‌پردازد.

\subsection{پیشینه}
پیشینه پژوهش...

% BAD:
\section{مقدمه}
\subsection{پیشینه}  % عنوان بدون متن!
```

### Rule 8: Parallel Structure in Lists

All items in a list should have the same grammatical structure.

```latex
% GOOD:
\begin{itemize}
    \item تحلیل الگوریتم
    \item طراحی الگوریتم
    \item پیاده‌سازی الگوریتم
\end{itemize}

% BAD:
\begin{itemize}
    \item تحلیل الگوریتم
    \item الگوریتم باید طراحی شود
    \item پیاده‌سازی
\end{itemize}
```

### Rule 9: Consistent Number Format

- Use Persian numerals (۰-۹) for Persian text
- Use Latin numerals (0-9) inside `\lr{}` for English text
- Use `\lr{}` for mathematical numbers in Persian text

```latex
% GOOD:
پیچیدگی این الگوریتم \lr{$O(n \log n)$} است.
این کتاب شامل ۱۲ فصل است.

% BAD:
پیچیدگی این الگوریتم $O(n \log n)$ است.  % بدون \lr
این کتاب شامل 12 فصل است.  % عدد لاتین در متن فارسی
```

### Rule 10: No Emoji in Formal Text

Emoji are acceptable in code comments, but NEVER in formal book text (except maybe in exercises for informal tone).

```latex
% GOOD (formal):
این الگوریتم به درستی کار می‌کند.

% BAD (informal):
این الگوریتم به درستی کار می‌کند 🎉
```

---

## 20. Visual Hierarchy and Balance

### The 60-30-10 Rule for Content

| Type | Percentage | Content |
|------|------------|---------|
| **Body text** | 60% | Regular paragraphs |
| **Structured content** | 30% | Lists, tables, code, algorithms |
| **Visual elements** | 10% | Boxes, figures, diagrams |

> 💡 **Tip:** If a page has more than 10% visual elements, it feels cluttered.

### The 3-Color Rule

On any single page, use at most **3 colors** (excluding box colors):

1. **Primary color** — `matindarkgray` for body text
2. **Accent color 1** — `matinblue` for theorems/references
3. **Accent color 2** — `matingreen` for definitions

### Vertical Rhythm

Maintain consistent spacing between elements:

| Element | Space Before | Space After |
|---------|--------------|-------------|
| Chapter title | 50pt (after `\titlespacing`) | 50pt |
| Section title | 20pt | 10pt |
| Subsection title | 15pt | 8pt |
| Subsubsection title | 12pt | 6pt |
| Paragraph | 0pt | 0pt + `\parskip` |
| Theorem/Definition box | 10pt | 10pt |
| Figure | 12pt | 12pt |
| Table | 12pt | 12pt |
| Code block | 10pt | 10pt |

### Box-to-Text Ratio

| Box Type | Recommended Ratio | Rationale |
|----------|-------------------|-----------|
| Theorem | 1 per 2-3 pages | Important, but not dominant |
| Definition | 1 per 2-3 pages | Same as theorem |
| Example | 1 per 1-2 pages | Examples support learning |
| Remark | 1 per 3-4 pages | Use sparingly |
| Exercise | 3-5 per chapter | At chapter end |
| Solution | 1 per exercise | Paired with exercise |

> ⚠️ **Warning:** Too many boxes break reading flow. If a page has 4+ boxes, you're overusing them.

### Whitespace Guidelines

1. **Never fill every inch of a page** — aim for 15-20% whitespace
2. **Prefer page breaks over cramming** — use `\clearpage` before major sections
3. **Use `\vspace{}` sparingly** — let LaTeX handle vertical spacing naturally
4. **One blank line between paragraphs** — no more, no less

---

## 21. Content Density Guidelines

### Optimal Reading Speed

| Language | Words per Minute | Words per Page (A4, 12pt) |
|----------|------------------|---------------------------|
| Persian | 180-220 | 350-450 |
| English | 200-250 | 400-500 |

### Chapter Length

| Book Type | Chapter Length | Total Chapters |
|-----------|----------------|----------------|
| Textbook | 15-25 pages | 10-15 |
| Monograph | 20-35 pages | 6-10 |
| Handbook | 10-20 pages | 20-30 |

### Section Length

- **Section:** 2-4 pages
- **Subsection:** 1-2 pages
- **Subsubsection:** 0.5-1 page

### Paragraph Length

- **Ideal:** 3-7 sentences
- **Maximum:** 10 sentences
- **Minimum:** 2 sentences

> 💡 **Tip:** If a paragraph exceeds 10 sentences, split it. If it's only 1 sentence, merge it with the next.

### Visual Elements per Page

| Element | Max per Page |
|---------|--------------|
| Figures | 2 |
| Tables | 2 |
| Code blocks | 1-2 |
| Algorithms | 1 |
| Theorem boxes | 2-3 |
| Lists | 3-4 |

---

## 22. Mathematical Writing Standards

### Equation Punctuation

Equations are part of sentences. Punctuate them accordingly:

```latex
% CORRECT:
اگر $a = b$، آنگاه:
\[
    a^{2} = b^{2}.
\]
بنابراین ...

% WRONG:
اگر $a = b$، آنگاه:
\[
    a^{2} = b^{2}
\]
بنابراین ...  % بدون نقطه
```

### Equation Numbering

- **Numbered equations** (`equation`): Only for equations referenced later
- **Unnumbered equations** (`\[ ... \]`): For one-off equations
- **Multi-line** (`align`): For aligned equation systems

### Variable Naming

| Type | Convention | Example |
|------|------------|---------|
| Scalar | lowercase italic | $x$, $y$, $n$ |
| Vector | lowercase bold | $\mathbf{v}$, $\vec{v}$ |
| Matrix | uppercase italic | $A$, $B$, $M$ |
| Set | uppercase blackboard | $\mathbb{R}$, $\mathbb{N}$ |
| Function | lowercase italic | $f$, $g$, $h$ |
| Constant | uppercase or Greek | $C$, $\pi$, $e$ |

### Theorems and Proofs

Every theorem should have a proof (unless it's a well-known result). Use `\begin{proof}...\end{proof}`.

```latex
\begin{theorem}[قضیه اصلی]
    هر عدد طبیعی بزرگتر از ۱ به عوامل اول تجزیه می‌شود.
    \label{thm:fundamental}
\end{theorem}

\begin{proof}
    با استقرای قوی روی $n$ اثبات می‌کنیم.
    ...
\end{proof}
```

### Equation Breaking

Long equations should break at logical points:

```latex
\begin{align}
    f(x) &= a_{0} + a_{1}x + a_{2}x^{2} + \cdots \nonumber \\
         &\quad + a_{n}x^{n} \\
    &= \sum_{i=0}^{n} a_{i}x^{i}
\end{align}
```

---

## 23. Algorithm Presentation Standards

### Algorithm Structure

Every algorithm should have:

1. **Input specification** (`\Require`)
2. **Output specification** (`\Ensure`)
3. **Clear variable names** (in English)
4. **Comments for non-trivial steps**
5. **Persian caption** (via `\algcaption`)

### Line Numbering

Use `\begin{algorithmic}[1]` for line numbers (recommended for algorithms with references).

### Algorithm Length

- **Ideal:** 5-15 lines
- **Maximum:** 25 lines
- **If longer:** Split into sub-algorithms

### Variable Naming in Algorithms

| Type | Convention | Example |
|------|------------|---------|
| Input | Descriptive | `A`, `target`, `n` |
| Loop counter | `i`, `j`, `k` | `\For{$i \gets 1$}` |
| Temporary | `temp`, `tmp` | `\State $temp \gets A[i]$` |
| Result | `result`, `ans` | `\State \Return result` |

### Example

```latex
\begin{latin}
\begin{algorithm}
\begin{algorithmic}[1]
    \Require Sorted array $A[1..n]$ of integers
    \Require Target value $x$
    \Ensure Index of $x$ in $A$, or $-1$ if not found
    \State $left \gets 1$, $right \gets n$
    \While{$left \leq right$}
        \State $mid \gets \lfloor (left + right) / 2 \rfloor$
        \If{$A[mid] = x$}
            \State \Return $mid$
        \ElsIf{$A[mid] < x$}
            \State $left \gets mid + 1$
        \Else
            \State $right \gets mid - 1$
        \EndIf
    \EndWhile
    \State \Return $-1$
\end{algorithmic}
\end{algorithm}
\end{latin}
\algcaption[alg:binary]{جستجوی دودویی}
```

---

## 24. Code Presentation Standards

### Code Length

- **Ideal:** 10-30 lines
- **Maximum:** 50 lines
- **If longer:** Split into multiple listings or reference a file

### Code Comments

- **All comments in English** (never Persian)
- **Docstrings for functions** (Google or NumPy style)
- **Inline comments** for non-obvious logic

### Code Style

- **4-space indentation** (Python standard)
- **Consistent naming** (snake_case for Python, camelCase for Java)
- **No trailing whitespace**
- **Meaningful variable names**

### Code and Text Integration

Always introduce code with a sentence, then show it, then explain it:

```latex
تابع زیر فاکتوریل را با روش بازگشتی محاسبه می‌کند:

\begin{latin}
\begin{minted}{python}
def factorial(n: int) -> int:
    """Calculate n! recursively."""
    if n <= 1:
        return 1
    return n * factorial(n - 1)
\end{minted}
\end{latin}
\codecaption{محاسبه فاکتوریل}
\label{code:factorial}

همانطور که در \coderef{code:factorial} می‌بینیم،
شرط پایه $n \leq 1$ است.
```

---

## 25. Figure and Table Standards

### Figure Placement

Use `[h]` (here) for small figures, `[t]` (top) for large ones, `[H]` (HERE) if absolutely necessary (requires `float` package, not loaded by default).

### Figure Captions

Captions should be:

- **Self-contained** (understandable without reading the text)
- **Below the figure** (standard in academic writing)
- **Numbered** automatically

```latex
\begin{figure}[h]
\centering
\begin{latin}
\begin{tikzpicture}
    ...
\end{tikzpicture}
\end{latin}
\caption{نمودار تابع $f(x) = x^{2}$ برای $x \in [-2, 2]$}
\label{fig:parabola}
\end{figure}
```

### Table Standards

- **Use `booktabs`** for professional tables (no vertical lines, only horizontal)
- **Captions above** tables (opposite of figures)
- **Align numbers** on decimal point
- **Use `C{width}`** for Persian text columns

```latex
\begin{table}[h]
\centering
\caption{مقایسه پیچیدگی الگوریتم‌ها}
\label{tab:complexity}
\begin{tabular}{@{}lC{4cm}c@{}}
\toprule
\textbf{Algorithm} & \textbf{Description} & \textbf{Complexity} \\
\midrule
Binary Search & جستجو در آرایه مرتب & $O(\log n)$ \\
Merge Sort & مرتب‌سازی پایدار & $O(n \log n)$ \\
Quicksort & مرتب‌سازی سریع & $O(n \log n)$ \\
\bottomrule
\end{tabular}
\end{table}
```

### Figure/Table Density

- **Maximum:** 1 figure/table per 2 pages
- **Minimum:** 1 figure/table per 10 pages
- **Ideal:** 1 figure/table per 4-5 pages

---

## 26. Citation and Reference Standards

### When to Cite

- **Direct quotes** (always)
- **Paraphrased ideas** (always)
- **Statistics and data** (always)
- **Well-known facts** (optional, but recommended)
- **Your own prior work** (always)

### Citation Style

MatinBook uses **numeric** style (`style=numeric`), which means citations appear as `[1]`, `[2]`, etc.

```latex
% Single citation:
طبق قضیه اصلی حساب \cite{cormen2009}، هر عدد طبیعی...

% Multiple citations:
منابع \cite{knuth1984,lamport1994} برای مطالعه بیشتر توصیه می‌شوند.

% Textual citation:
\textcite{cormen2009} این الگوریتم را معرفی کرد.
```

### Bibliography Entry Types

| Type | Usage | Example |
|------|-------|---------|
| `@book` | Books | Knuth's TeXbook |
| `@article` | Journal articles | Einstein's 1905 paper |
| `@inproceedings` | Conference papers | STOC, FOCS |
| `@online` | Websites | LaTeX Project |
| `@phdthesis` | PhD theses | — |
| `@techreport` | Technical reports | — |

### Minimum Bibliography

For a technical book, aim for:

- **Textbook:** 30-50 references
- **Monograph:** 50-100 references
- **Handbook:** 100-200 references

---

# Part IV: Implementation

## 27. Content Generation Rules

### RULE 1: Persian Text is Natural

Persian body text is written normally without any special commands.

```latex
% CORRECT:
این یک متن فارسی است که به طور طبیعی نوشته می‌شود.

% WRONG:
\rl{این یک متن فارسی است...}
```

### RULE 2: Latin Text in Persian

Any English word, phrase, or technical term within Persian text must use `\lr{}`:

```latex
% CORRECT:
این کتاب درباره \lr{machine learning} و \lr{deep neural networks} است.

% WRONG:
این کتاب درباره machine learning و deep neural networks است.
```

### RULE 3: Latin Blocks

Large blocks of English text, code, algorithms, and TikZ diagrams must be wrapped in `\begin{latin}...\end{latin}`:

```latex
\begin{latin}
This is a block of English text.
It can contain multiple paragraphs.
\end{latin}
```

### RULE 4: Code Comments in English

ALL comments inside `minted` code blocks MUST be in English:

```python
# CORRECT:
def calculate_sum(numbers):
    """Compute the sum of all numbers."""
    return sum(numbers)

# WRONG:
def calculate_sum(numbers):
    """محاسبه مجموع اعداد"""
    return sum(numbers)
```

### RULE 5: Algorithm Captions Outside Latin

The `\algcaption` command MUST be placed OUTSIDE the `latin` environment:

```latex
% CORRECT:
\begin{latin}
\begin{algorithm}
    ...
\end{algorithm}
\end{latin}
\algcaption[alg:myalgo]{عنوان فارسی}

% WRONG:
\begin{latin}
\begin{algorithm}
    ...
\end{algorithm}
\algcaption[alg:myalgo]{عنوان فارسی}
\end{latin}
```

### RULE 6: Labels Inside Environments

`\label` commands belong INSIDE the environment they reference:

```latex
% CORRECT:
\begin{theorem}
    Content...
    \label{thm:mythm}
\end{theorem}

% WRONG:
\begin{theorem}
    Content...
\end{theorem}
\label{thm:mythm}
```

### RULE 7: No Math in Section Titles

Do NOT use math mode (`$...$`) in section titles. Use plain Unicode characters instead:

```latex
% CORRECT:
\section{تحلیل پیچیدگی O بزرگ}

% WRONG:
\section{تحلیل پیچیدگی $O$ بزرگ}
```

### RULE 8: Use \lr for Technical Terms

All technical terms in English should use `\lr{}`:

```latex
استفاده از \lr{Quick Sort} برای مرتب‌سازی داده‌ها.
پیچیدگی زمانی \lr{Merge Sort} برابر $O(n \log n)$ است.
```

### RULE 9: Tables with Persian Text

Use `C{width}` column type for Persian text columns, `c` for numeric/symbol columns, and `l` for English:

```latex
\begin{tabular}{|c|C{5cm}|c|}
\hline
\textbf{Number} & \textbf{Description in Persian} & \textbf{Status} \\
\hline
۱ & توضیح فارسی در این ستون قرار می‌گیرد & OK \\
\hline
\end{tabular}
```

### RULE 10: Book Structure

Always follow this structure:

```latex
\begin{document}
    % Cover
    \makecover{...}{...}{...}{...}
    \makebackcover{...}
    
    % Title page
    \maketitle
    
    % Copyright page
    \thispagestyle{empty}
    ...
    \clearpage
    
    % Dedication (optional)
    \thispagestyle{empty}
    ...
    \clearpage
    
    \frontmatter
    
    % Preface
    \chapter*{پیشگفتار}
    \addcontentsline{toc}{chapter}{پیشگفتار}
    ...
    \clearpage
    
    % Table of Contents
    \tableofcontents
    \clearpage
    \listoffigures
    \clearpage
    \listoftables
    \clearpage
    \listofalgorithms
    \clearpage
    
    \mainmatter
    
    % Chapters
    \chapter{...}
    ...
    
    % Appendices (optional)
    \appendix
    \chapter{...}
    ...
    
    % Bibliography
    \begin{latin}
    \printbibliography[title={منابع و مراجع}]
    \end{latin}
    
    % Index
    \printindex
\end{document}
```

---

## 28. File Structure Templates

### Template 1: Simple Book (3-5 chapters)

```latex
\makeatletter
\def\input@path{{../}}
\makeatother

\documentclass{matinbook}

\addbibresource{references.bib}

\title{Book Title}
\author{Author Name}
\date{Summer 2026}

\begin{document}
    \makecover{Title}{Subtitle}{Author}{Date}
    \makebackcover{Back cover text...}
    \maketitle
    
    \frontmatter
    \chapter*{پیشگفتار}
    \addcontentsline{toc}{chapter}{پیشگفتار}
    ...
    \tableofcontents
    
    \mainmatter
    \chapter{Chapter 1}
    ...
    \chapter{Chapter 2}
    ...
    
    \begin{latin}
    \printbibliography[title={منابع و مراجع}]
    \end{latin}
    \printindex
\end{document}
```

### Template 2: Multi-Part Book (8+ chapters)

```latex
\makeatletter
\def\input@path{{../}}
\makeatother

\documentclass{matinbook}

\addbibresource{references.bib}

\title{Comprehensive Guide}
\author{Author Name}
\date{Summer 2026}

\begin{document}
    \makecover{Title}{Subtitle}{Author}{Date}
    \makebackcover{...}
    \maketitle
    
    \frontmatter
    \chapter*{پیشگفتار}
    \addcontentsline{toc}{chapter}{پیشگفتار}
    ...
    \tableofcontents
    \listoffigures
    \listoftables
    \listofalgorithms
    
    \mainmatter
    
    \part{Part One Title}
    \chapter{Chapter 1}
    ...
    \chapter{Chapter 2}
    ...
    
    \part{Part Two Title}
    \chapter{Chapter 3}
    ...
    
    \appendix
    \chapter{Appendix A}
    ...
    
    \begin{latin}
    \printbibliography[title={منابع و مراجع}]
    \end{latin}
    \printindex
\end{document}
```

---

## 29. Compilation Instructions

### Minimal Compilation (no bibliography or index)

```bash
xelatex -shell-escape filename.tex
xelatex -shell-escape filename.tex
```

### Full Compilation (with bibliography and index)

```bash
xelatex -shell-escape filename.tex
biber filename
makeindex filename.idx
xelatex -shell-escape filename.tex
xelatex -shell-escape filename.tex
```

### Using latexmk

```bash
latexmk -xelatex -shell-escape filename.tex
```

### Clean auxiliary files

```bash
latexmk -c filename.tex
```

---

## 30. Common Patterns and Recipes

### Pattern 1: Theorem with Proof

```latex
\begin{theorem}[Title]
    Statement of the theorem.
    \label{thm:mythm}
\end{theorem}

\begin{proof}
    Proof of the theorem.
\end{proof}
```

### Pattern 2: Definition with Example

```latex
\begin{definition}[Title]
    Definition text.
    \label{def:mydef}
\end{definition}

\begin{example}
    Example illustrating the definition.
    \label{ex:myex}
\end{example}
```

### Pattern 3: Exercise with Solution

```latex
\begin{exercise}
    Exercise statement.
    \label{exc:myexc}
\end{exercise}

\begin{solution}
    Detailed solution.
\end{solution}
```

### Pattern 4: Code with Reference

```latex
\begin{latin}
\begin{minted}{python}
def solve():
    return 42
\end{minted}
\end{latin}
\codecaption{Solution function}
\label{code:solve}

As shown in \coderef{code:solve}, the function returns 42.
```

### Pattern 5: Algorithm with Reference

```latex
\begin{latin}
\begin{algorithm}
\begin{algorithmic}[1]
    \Require Input
    \Ensure Output
    \State \Return result
\end{algorithmic}
\end{algorithm}
\end{latin}
\algcaption[alg:myalgo]{My Algorithm}

Algorithm \algref{alg:myalgo} describes the process.
```

### Pattern 6: Figure with TikZ

```latex
\begin{figure}[h]
\centering
\begin{latin}
\begin{tikzpicture}
    \begin{axis}[
        width=12cm, height=7cm,
        xlabel={$x$},
        ylabel={$f(x)$},
        title={Function Plot},
        grid=major
    ]
        \addplot[matinblue, thick, domain=-2:2] {x^2};
    \end{axis}
\end{tikzpicture}
\end{latin}
\caption{Plot of $f(x) = x^{2}$}
\label{fig:parabola}
\end{figure}
```

### Pattern 7: Table with Persian Text

```latex
\begin{table}[h]
\centering
\caption{Algorithm Comparison}
\label{tab:comparison}
\begin{tabular}{|c|C{5cm}|c|}
\hline
\textbf{Algorithm} & \textbf{Description} & \textbf{Complexity} \\
\hline
Binary Search & جستجو در آرایه مرتب & $O(\log n)$ \\
Merge Sort & مرتب‌سازی پایدار & $O(n \log n)$ \\
\hline
\end{tabular}
\end{table}
```

### Pattern 8: Cross-Chapter Reference

```latex
% In chapter 3:
\chapter{Graph Algorithms}
\label{chap:graphs}
...

% In chapter 1:
As we will see in \chref{chap:graphs}, graph algorithms...
```

---

## 31. Error Prevention Guide

### Common Errors and Solutions

#### Error 1: "Extra \middle" when using \given

**Cause:** Using `\given` without `\left` and `\right`.

**Solution:** Use `\setbuilder{cond}{cond}` or `\mid` for manual braces.

```latex
% WRONG:
$\{x \given x > 0\}$

% CORRECT:
$\setbuilder{x}{x > 0}$
% OR:
$\{x \mid x > 0\}$
```

#### Error 2: "Extra \fi" in section titles with math

**Cause:** Using `$...$` inside `\section{}`, `\subsection{}`, etc.

**Solution:** Use Unicode characters or text equivalents.

```latex
% WRONG:
\section{Analysis of $O(n)$}

% CORRECT:
\section{Analysis of O(n)}
```

#### Error 3: "Dimension too large" with tan(x)

**Cause:** tan(x) has asymptotes that go to infinity.

**Solution:** Add `restrict y to domain`:

```latex
\addplot[thick, restrict y to domain=-5:5] {tan(deg(x))};
```

#### Error 4: Algorithmic blocks not closed

**Cause:** Missing `\EndIf`, `\EndFor`, `\EndWhile`, or `\EndFunction`.

**Solution:** Ensure every opening block has a matching close.

#### Error 5: Empty list of algorithms

**Cause:** `\algcaption` placed inside `\begin{latin}`.

**Solution:** Move `\algcaption` outside the `latin` environment.

#### Error 6: References showing "??"

**Cause:** Needs additional LaTeX compilation passes.

**Solution:** Run XeLaTeX at least 2-3 times.

#### Error 7: Empty bibliography

**Cause:** `biber` not run between compilations.

**Solution:** Run the full compilation sequence.

#### Error 8: Persian text scrambled in TikZ nodes

**Cause:** TikZ nodes inside `latin` environment need `\rl{}`.

**Solution:** Wrap Persian text in `\rl{}`:

```latex
\node {\rl{متن فارسی}};
```

#### Error 9: Code not displaying

**Cause:** Missing `-shell-escape` flag.

**Solution:** Always use `xelatex -shell-escape`.

#### Error 10: Overfull hbox warnings

**Cause:** Long unbreakable text (URLs, long inline code).

**Solution:** Use `\emergencystretch=3em` (already set) or manually break lines.

---

## 32. Complete Example

Below is a complete, compilable example demonstrating the most common patterns:

```latex
\makeatletter
\def\input@path{{../}}
\makeatother

\documentclass{matinbook}

\addbibresource{references.bib}

\title{Introduction to Algorithms}
\author{A. Author}
\date{Summer 2026}

\begin{document}

% Cover
\makecover
{Introduction to Algorithms}
{A Comprehensive Guide}
{A. Author}
{Summer 2026}

\makebackcover{%
    This book provides a comprehensive introduction
    to algorithms and data structures.
    
    \textbf{Topics covered:}
    \begin{itemize}
        \item Sorting and searching
        \item Graph algorithms
        \item Dynamic programming
        \item Number theory
    \end{itemize}
}

% Title page
\maketitle

% Copyright
\thispagestyle{empty}
\vspace*{5cm}
\begin{center}
    {\large\textbf{Copyright}}\\[1cm]
    Copyright \copyright\ 2026\\
    All rights reserved.
\end{center}
\clearpage

\frontmatter

% Preface
\chapter*{پیشگفتار}
\addcontentsline{toc}{chapter}{پیشگفتار}

This book is an introduction to the field of algorithms
and data structures. It is designed for undergraduate
students in computer science.

\clearpage

% Table of Contents
\tableofcontents
\clearpage

\mainmatter

% Chapter 1
\chapter{Introduction to Algorithms}

\section{What is an Algorithm?}

\begin{definition}[Algorithm]
    An \textbf{algorithm}\index{algorithm} is a finite sequence
    of well-defined instructions for solving a problem.
    \label{def:algorithm}
\end{definition}

\begin{example}[Binary Search]
    Binary search\index{binary search} finds an element
    in a sorted array in $O(\log n)$ time.
    \label{ex:binary-search}
\end{example}

\section{Asymptotic Notation}

\begin{definition}[Big-O]
    $f(n) = O(g(n))$ if there exist constants $c > 0$
    and $n_{0} \geq 0$ such that
    $0 \leq f(n) \leq c \cdot g(n)$
    for all $n \geq n_{0}$.
    \label{def:big-o}
\end{definition}

\begin{theorem}[Master Theorem]
    Let $T(n) = aT(n/b) + f(n)$. Then the asymptotic
    behavior of $T(n)$ can be determined by comparing
    $f(n)$ with $n^{\log_{b}a}$.
    \label{thm:master}
\end{theorem}

\begin{proof}
    The proof uses the recursion tree method
    and considers three cases based on
    the growth rate of $f(n)$.
\end{proof}

\begin{remark}
    The Master Theorem \thmref{thm:master} is one of
    the most useful tools for analyzing
    divide-and-conquer algorithms.
    \label{rem:master-importance}
\end{remark}

% Chapter 2
\chapter{Sorting Algorithms}

\section{Quicksort}

Quicksort\index{quicksort} is a divide-and-conquer
algorithm invented by \lr{C.A.R. Hoare}.

\begin{latin}
\begin{algorithm}
\begin{algorithmic}[1]
    \Require Array $A$ of $n$ elements
    \Require Indices $low$ and $high$
    \Ensure Sorted array $A[low..high]$
    \Function{Quicksort}{$A$, $low$, $high$}
        \If{$low < high$}
            \State $p \gets \Call{Partition}{A, low, high}$
            \State $\Call{Quicksort}{A, low, p-1}$
            \State $\Call{Quicksort}{A, p+1, high}$
        \EndIf
    \EndFunction
\end{algorithmic}
\end{algorithm}
\end{latin}
\algcaption[alg:quicksort]{مرتب‌سازی سریع}

Algorithm \algref{alg:quicksort} has an average-case
complexity of $O(n \log n)$.

\section{Implementation}

Here is the Python implementation:

\begin{latin}
\begin{minted}{python}
def quicksort(arr: list) -> list:
    """Sort array using quicksort algorithm."""
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quicksort(left) + middle + quicksort(right)
\end{minted}
\end{latin}
\codecaption{Quicksort Implementation}
\label{code:quicksort}

\section{Complexity Comparison}

\begin{table}[h]
\centering
\caption{Sorting Algorithm Comparison}
\label{tab:sorting}
\begin{tabular}{|c|C{4cm}|c|}
\hline
\textbf{Algorithm} & \textbf{Description} & \textbf{Average Case} \\
\hline
Bubble Sort & مرتب‌سازی حبابی ساده & $O(n^{2})$ \\
Quicksort & مرتب‌سازی سریع & $O(n \log n)$ \\
Merge Sort & مرتب‌سازی ادغامی & $O(n \log n)$ \\
\hline
\end{tabular}
\end{table}

% Exercises
\section{Exercises}

\begin{exercise}
    Implement the quicksort algorithm in C++
    and compare its performance with merge sort
    on arrays of size $10^{6}$.
    \label{exc:quicksort-cpp}
\end{exercise}

\begin{solution}
    The implementation should use in-place
    partitioning to achieve $O(\log n)$
    space complexity.
\end{solution}

% Bibliography
\begin{latin}
\printbibliography[title={منابع و مراجع}]
\end{latin}

% Index
\printindex

\end{document}
```

---

## Summary Checklist for AI Content Generation

Before generating content, verify:

### Structural
- [ ] Document starts with `\makeatletter` and path setup
- [ ] `\documentclass{matinbook}` is used
- [ ] Bibliography resource is added
- [ ] Cover is properly configured
- [ ] `\frontmatter` / `\mainmatter` structure is correct

### Bilingual
- [ ] All Latin text uses `\lr{}` or `\begin{latin}`
- [ ] All code comments are in English
- [ ] All `\algcaption` commands are outside `latin` environment

### Technical
- [ ] All `\label` commands are inside their environments
- [ ] No math mode in section titles
- [ ] Tables use `C{width}` for Persian columns
- [ ] TikZ nodes with Persian use `\rl{}`
- [ ] All blocks (`\If`/`\For`/`\While`/`\Function`) are properly closed

### Academic
- [ ] Each paragraph has one main idea
- [ ] Topic sentences are first
- [ ] Terms are defined before use
- [ ] Visual hierarchy follows 60-30-10 rule
- [ ] Box-to-text ratio is appropriate
- [ ] Citations follow numeric style
- [ ] Index entries are meaningful

### Quality
- [ ] No emoji in formal text
- [ ] Consistent terminology
- [ ] Parallel structure in lists
- [ ] No orphan/widow lines
- [ ] Bibliography is printed inside `latin` environment
- [ ] Cross-references use appropriate MatinBook commands

---

**This AI Guide is the definitive reference for generating content with MatinBook. Follow these instructions exactly for correct, compilable, and academically rigorous output.**

---

## References

1. Chicago Manual of Style, 17th Edition. University of Chicago Press, 2017.
2. The MIT Press. *Author Guidelines*. MIT Press, 2023.
3. Springer. *Book Manuscript Guidelines*. Springer Nature, 2023.
4. Oxford University Press. *Style Manual*. OUP, 2014.
5. Tufte, Edward R. *The Visual Display of Quantitative Information*. Graphics Press, 2001.
6. Bringhurst, Robert. *The Elements of Typographic Style*. Hartley & Marks, 2013.
```

---