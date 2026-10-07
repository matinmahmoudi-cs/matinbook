# MatinBook — AI Content Generation Guide

## Complete Reference for AI-Assisted Academic Book Writing

**Version:** 1.1
**Target:** Persian technical books in programming, mathematics, and computer science
**Engine:** XeLaTeX (mandatory)
**Last Updated:** Mehr 1405 / October 2026

---

## Table of Contents

### Part I: Foundation
1. [Overview](#1-overview)
2. [Project Architecture](#2-project-architecture)
3. [Class System and Loading Order](#3-class-system-and-loading-order)

### Part II: Reference
4. [Available Environments](#4-available-environments)
5. [Custom Commands Reference](#5-custom-commands-reference)
6. [Color System](#6-color-system)
7. [Typography and Fonts](#7-typography-and-fonts)
8. [Page Layout](#8-page-layout)
8b. [Margin Notes (RTL)](#8b-margin-notes-rtl)
8c. [Frontmatter / Mainmatter Split](#8c-frontmatter--mainmatter-split)
9. [Mathematics](#9-mathematics)
10. [Code Display](#10-code-display)
11. [Algorithms and Pseudocode](#11-algorithms-and-pseudocode)
12. [Graphics and Diagrams](#12-graphics-and-diagrams)
13. [Cross-References](#13-cross-references)
14. [Bibliography](#14-bibliography)
15. [Index Generation](#15-index-generation)
16. [Cover System](#16-cover-system)
17. [Theme System](#17-theme-system)
18. [Localization](#18-localization)

### Part III: Academic Writing Standards
19. [Professional Writing Rules](#19-professional-writing-rules)
20. [Visual Hierarchy and Balance](#20-visual-hierarchy-and-balance)
21. [Content Density Guidelines](#21-content-density-guidelines)
22. [Mathematical Writing Standards](#22-mathematical-writing-standards)
23. [Algorithm Presentation Standards](#23-algorithm-presentation-standards)
24. [Code Presentation Standards](#24-code-presentation-standards)
25. [Figure and Table Standards](#25-figure-and-table-standards)
26. [Citation and Reference Standards](#26-citation-and-reference-standards)

### Part IV: Implementation
27. [Content Generation Rules](#27-content-generation-rules)
28. [File Structure Templates](#28-file-structure-templates)
29. [Compilation Instructions](#29-compilation-instructions)
30. [Common Patterns and Recipes](#30-common-patterns-and-recipes)
31. [Error Prevention Guide](#31-error-prevention-guide)
32. [Complete Example](#32-complete-example)

---

# Part I: Foundation

## 1. Overview

MatinBook is a professional LaTeX document class (`matinbook.cls`) designed for writing Persian technical books in programming, mathematics, and computer science. It requires **XeLaTeX** as the compilation engine and provides a modular architecture with **18 independent modules**.

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
5. **Algorithms use the standard `algorithm` package** — `xepersian` handles Persian captions automatically via `algorithm-xepersian.def`
6. **Theorem-like environments have Persian titles** — defined in `fa-IR.sty`
7. **All cross-references use `\cref{}`** (via `cleveref`) — Persian prefixes come from `fa-IR.sty`
8. **Colors are defined in CMYK** (per Iranian educational publishing standard ز/۱-۴)
9. **The cover requires at least 2 compilation passes** (TikZ `remember picture, overlay`)
10. **The index requires `xindy`** (not `makeindex`) for correct Persian sorting
11. **Margin notes use the wide outer margin** (5.9cm) with `\mnote{}` and `\marginfig{}{}`
12. **Frontmatter and mainmatter use different geometries** — `\frontmattergeometry` and `\mainmattergeometry`

---

## 2. Project Architecture

### Directory Structure (v1.1)

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
│   ├── core/                        # 2 core modules
│   │   ├── mb-core.sty              # Package loader (order matters)
│   │   ├── mb-utils.sty             # Utility commands
│   │   └── (mb-engine.sty, mb-options.sty removed in v1.1)
│   │
│   ├── locales/                     # 2 locale files
│   │   ├── fa-IR.sty                # Persian translations
│   │   └── en-US.sty                # English translations
│   │
│   ├── modules/                     # 9 feature modules
│   │   ├── boxes/mb-boxes.sty       # Two families: matinbox + matin-outline
│   │   ├── code/mb-code.sty         # minted configuration
│   │   ├── graphics/mb-graphics.sty # TikZ + PGFPlots
│   │   ├── index/mb-index.sty       # xindy configuration
│   │   ├── layout/
│   │   │   ├── mb-layout.sty        # Page geometry (wide margin)
│   │   │   └── mb-headings.sty      # Chapter/section styles
│   │   ├── math/mb-math.sty         # Math operators and delimiters
│   │   ├── references/mb-references.sty  # hyperref + cleveref
│   │   ├── theorem/mb-theorem.sty   # Theorem environments (tcolorbox)
│   │   └── typography/
│   │       ├── mb-typography.sty    # Microtype + Kashida
│   │       └── (mb-rtl.sty, mb-fonts.sty removed in v1.1)
│   │
│   └── themes/                      # Theme system
│       └── default/
│           ├── mb-theme-colors.sty  # Color palette (CMYK)
│           ├── mb-theme-cover.sty   # Cover design (full-color)
│           └── mb-theme-default.sty # Theme loader
│
├── assets/
│   ├── cover/
│   └── images/
│
├── fonts/                           # Project-local fonts
│   ├── bnazanin/
│   ├── niloofar/
│   ├── vazirmatn/
│   ├── sahel/
│   └── irlotus/
│
├── tests/
│   └── v1.1/                        # 24 integration tests
│       ├── compile.sh               # Test compiler script
│       ├── stage-cls-01.tex
│       ├── stage-packages-01.tex
│       ├── stage-options-01.tex
│       ├── stage-core-01.tex
│       ├── stage-utils-01.tex
│       ├── stage-rtl-01.tex
│       ├── stage-locale-01.tex
│       ├── stage-locale-en-01.tex
│       ├── stage-typography-01.tex
│       ├── stage-layout-01.tex
│       ├── stage-headings-01.tex
│       ├── stage-math-01.tex
│       ├── stage-boxes-01.tex
│       ├── stage-theorem-01.tex
│       ├── stage-code-01.tex
│       ├── stage-algorithm-01.tex
│       ├── stage-graphics-01.tex
│       ├── stage-index-01.tex
│       ├── stage-colors-01.tex
│       ├── stage-theme-default-01.tex
│       ├── stage-cover-01.tex
│       ├── stage-main-01.tex
│       └── stage-margin-01.tex      # ← Margin notes test
│
└── examples/                        # 2 example books
    ├── matinbook-documentation.tex
    └── advanced-algorithms-book.tex
```

### Module Loading Order (Critical!)

```
Phase 1 — Base packages (BEFORE xepersian):
 1.  mb-core          → Load ALL base packages
 2.  mb-theme-colors  → Color palette (CMYK)
 3.  mb-boxes         → tcolorbox styles (two families)
 4.  mb-code          → minted configuration
 5.  mb-layout        → Page geometry (wide margin)
 6.  mb-headings      → Chapter/section styles (Boyer/Stewart)
 7.  mb-math          → Math operators
 8.  mb-theorem       → Theorem environments (tcolorbox)
 9.  mb-references    → hyperref + cleveref
10.  mb-graphics      → TikZ + PGFPlots
11.  mb-index         → xindy configuration
12.  mb-utils         → Utility commands
13.  mb-theme-cover   → Cover design (full-color)

Phase 2 — xepersian (MUST be the last package):
14.  xepersian        → RTL/Bidi support

Phase 3 — Persian-specific settings (AFTER xepersian):
15.  mb-typography    → Microtype + Kashida
16.  fa-IR            → Persian locale
17.  mb-theme-default → Theme loader
```

> ⚠️ **CRITICAL:** Changing this order will break the class.
>
> **Why three phases?**
> - `xepersian` **must be the last package** (per its documentation). If loaded earlier, it overwrites `bidi` and other package definitions.
> - Colors **must be defined before consumers** (`mb-boxes`, `mb-code`, `mb-layout`, `mb-headings`, `mb-graphics`).
> - Font configuration **must come after `xepersian`** because `\settextfont` is defined by `xepersian`.

---

## 3. Class System and Loading Order

### Class Declaration

```latex
\documentclass[options]{matinbook}
```

### Available Options (LaTeX 2023 Key-Value System)

| Option | Effect | Default |
|--------|--------|---------|
| `draft` | Draft mode with watermark and overfull box highlighting | `final` |
| `final` | Final mode (no watermark) | ✓ |
| `niloofar` | Use XB Niloofar Persian font | ✓ |
| `vazirmatn` | Use Vazirmatn Persian font | |
| `sahel` | Use Sahel Persian font | |
| `irlotus` | Use IR Lotus Persian font | |
| `bnazanin` | Use B Nazanin Persian font (commercial) | |

> **Note:** MatinBook v1.1 uses the LaTeX 2023 `\DeclareKeys` system for options. This is more robust and supports the modern key-value syntax.

### Base Packages (Loaded in `mb-core.sty`)

```
graphicx, xcolor[table], fontspec, microtype,
amsmath, amssymb, mathtools, amsthm, unicode-math,
algorithm, algpseudocode,
tcolorbox (with 'most' library + minted library),
minted,
biblatex (backend=biber, style=numeric, sorting=none),
imakeidx,
geometry, fancyhdr, titlesec, tocloft,
setspace, caption, footmisc,
booktabs, array, multirow,
hyperref, cleveref
```

> **Note:** `pgf-pie`, `draftwatermark`, and `\newcolumntype` are **NOT** in `mb-core`.
> - `pgf-pie` → moved to `mb-graphics`
> - `draftwatermark` → moved to `mb-layout`
> - `\newcolumntype` → moved to `mb-typography`

### Enhanced Column Types for Tables

Defined in `mb-typography.sty`:

```latex
L{width}  → Left-aligned paragraph column
R{width}  → Right-aligned paragraph column (for Persian)
C{width}  → Center-aligned paragraph column
```

> 💡 **Tip:** Use `C{width}` for Persian text, `l` for English/numeric, `c` for short symbols.

### Module Roles

| Module | Role |
|--------|------|
| `mb-core` | Loads ALL base packages (order matters!) |
| `mb-theme-colors` | Defines 20 CMYK colors in 5 families |
| `mb-boxes` | **Two families:** `matinbox` (Boyer-style) + `matin-outline` (RTL outline) |
| `mb-code` | Configures minted with Persian comment support |
| `mb-layout` | Page geometry (wide margin), headers, footers, margin notes, watermark |
| `mb-headings` | Chapter/section/subsection styles (Boyer/Stewart scale) |
| `mb-math` | Math operators, delimiters, equation numbering |
| `mb-theorem` | Defines theorem environments via **`\newtcolorbox`** |
| `mb-references` | Configures hyperref and cleveref |
| `mb-graphics` | TikZ, PGFPlots, pgf-pie |
| `mb-index` | Configures xindy with persian-variant2 |
| `mb-utils` | `\latintitle`, `\latinauthor`, `\matin@ifcmd` |
| `mb-theme-cover` | Front and back cover design (full-color) |
| `mb-typography` | Microtype, Kashida, column types |
| `fa-IR` | Persian translations for LaTeX names |
| `mb-theme-default` | Loads `mb-theme-cover` (colors loaded separately) |

**End of Part I**


# Part II: Reference

## 4. Available Environments

### Box Families (v1.1)

MatinBook v1.1 provides **two box families**:

| Family | Style | Used by |
|--------|-------|---------|
| **`matinbox`** | Boyer-style: solid colored title bar, white body, sharp corners | `theorem`, `lemma`, `corollary`, `proposition`, `definition`, `remark`, `exercise` |
| **`matin-outline`** | RTL outline: right vertical line (2pt), horizontal rule under title (1pt), horizontal rule at bottom (1pt), white body, black bold title | `example`, `proof`, `solution` |

> **Note:** Both families are **breakable** — long boxes span multiple pages.
> The `matin-outline` family keeps its vertical line on the **correct side**
> of each broken piece (odd/even page) via `underlay first/middle/last`.

### Theorem Family (Blue Theme — shared counter)

All theorem-family environments **share a single counter** (per Persian LaTeX community consensus, to help readers locate theorems faster).

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `theorem` | matin@thmcounter (shared) | matin-theorem (blue) | قضیه |
| `lemma` | matin@thmcounter (shared) | matin-lemma (blue) | لم |
| `corollary` | matin@thmcounter (shared) | matin-corollary (blue) | نتیجه |
| `proposition` | matin@thmcounter (shared) | matin-proposition (blue) | گزاره |

### Definition Family (Green)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `definition` | matin@thmcounter (shared) | matin-definition | تعریف |

### Example Family (Orange — outline style)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `example` | matin@thmcounter (shared) | matin-example-outline | مثال |

### Remark Family (Red)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `remark` | matin@thmcounter (shared) | matin-remark | نکته |

### Exercise Family (Purple)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `exercise` | matin@thmcounter (shared) | matin-exercise | تمرین |

### Solution / Proof (Green / Gray — outline style)

| Environment | Counter | Color | Persian Title |
|-------------|---------|-------|---------------|
| `solution` | (none) | matin-solution-outline (green) | راه حل |
| `proof` | (none) | matin-proof-outline (gray) | اثبات |

> **Note:** The `proof` environment automatically adds `\qedsymbol` (□) at the end.

### Usage Pattern

```latex
\begin{definition}[Optional Title]
    Definition content...
    \label{def:my-definition}
\end{definition}

\begin{theorem}[Optional Title]
    Theorem content...
    \label{thm:my-theorem}
\end{theorem}

\begin{proof}
    Proof content...
\end{proof}

\begin{lemma}[Optional Title]
    Lemma content...
    \label{lem:my-lemma}
\end{lemma}

\begin{corollary}[Optional Title]
    Corollary content...
    \label{cor:my-corollary}
\end{corollary}

\begin{proposition}[Optional Title]
    Proposition content...
    \label{prop:my-proposition}
\end{proposition}

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

### IMPORTANT: Shared Counter Behavior

Because all theorem-family environments share the `matin@thmcounter`, the numbering is **continuous**:

```latex
\begin{definition}[Graph]  % Number 1.1
    ...
\end{definition}

\begin{theorem}[Euler]     % Number 1.2
    ...
\end{theorem}

\begin{lemma}[Handshake]   % Number 1.3
    ...
\end{lemma}

\begin{example}            % Number 1.4
    ...
\end{example}
```

> 💡 **Tip:** This is **intentional** — Persian LaTeX community prefers shared numbering so readers don't have to search through multiple sequences.

### Title Format

The title of each box is built by `\matin@thmtitle`:

```
\begin{theorem}              → "قضیه ۱.۱"
\begin{theorem}[قضیه اصلی]   → "قضیه ۱.۱: قضیه اصلی"
```

---

## 5. Custom Commands Reference

### Document Structure Commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `\makecover{t}{s}{a}{d}` | Title, Subtitle, Author, Date | Front cover (requires 2 passes) |
| `\makebackcover{text}` | Back cover text | Back cover (at end of document) |
| `\maketitle` | (none) | Title page |
| `\booktitle{text}` | Book title | For even-page headers |
| `\tableofcontents` | (none) | Table of contents |
| `\listoffigures` | (none) | List of figures |
| `\listoftables` | (none) | List of tables |
| `\listofalgorithms` | (none) | List of algorithms (only if used) |
| `\printindex` | (none) | Print index |
| `\printbibliography` | (none) | Print bibliography |
| `\frontmatter` | (none) | Start front matter (Persian letter numbering) |
| `\mainmatter` | (none) | Start main matter (Arabic numbering) |
| `\backmatter` | (none) | Start back matter |

### Geometry Commands (NEW in v1.1)

| Command | Description |
|---------|-------------|
| `\frontmattergeometry` | Switch to symmetric margins (no wide margin) for frontmatter/backmatter |
| `\mainmattergeometry` | Restore the wide-margin geometry for main chapters |

### Margin Note Commands (NEW in v1.1)

| Command | Arguments | Description |
|---------|-----------|-------------|
| `\mnote{text}` | Text | Plain margin note (RTL, no number) |
| `\marginfig{file}{caption}` | File, Caption | Figure + caption in the margin |

### Cover Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `\makecover{...}` | 4 args | Front cover with full-color background |
| `\makebackcover{...}` | 1 arg | Back cover with math/code fantasy band |
| `\repository` | Variable | Repository URL (shown on cover) |
| `\booktitle{...}` | 1 arg | Book title for headers |

> **CRITICAL:** `\makecover` and `\makebackcover` use `remember picture, overlay` (TikZ), which **requires at least 2 compilation passes**.

### Bilingual Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `\lr{text}` | `\lr{computer}` | Inline Latin text in Persian |
| `\rl{text}` | `\rl{متن فارسی}` | Inline Persian text in LTR (for TikZ nodes only) |
| `\RL{text}` | `\RL{متن فارسی}` | Paragraph-level RTL group |
| `\begin{latin}...\end{latin}` | Environment | Block of Latin text |

### Reference Commands (NEW in v1.1)

All references use **`\cref{}`** and helper macros. The helpers delegate to `\cref`:

| Command | Output Example | Notes |
|---------|----------------|-------|
| `\cref{eq:label}` | معادله ۱.۱ | Auto-detects type |
| `\cref{thm:label}` | قضیه ۱.۱ | Shared counter |
| `\cref{lem:label}` | لم ۱.۱ | |
| `\cref{cor:label}` | نتیجه ۱.۱ | |
| `\cref{def:label}` | تعریف ۱.۱ | |
| `\cref{ex:label}` | مثال ۱.۱ | |
| `\cref{rem:label}` | نکته ۱.۱ | |
| `\cref{exc:label}` | تمرین ۱.۱ | |
| `\cref{fig:label}` | شکل ۱.۱ | |
| `\cref{tab:label}` | جدول ۱.۱ | |
| `\cref{alg:label}` | الگوریتم ۱.۱ | |
| `\cref{chap:label}` | فصل ۱ | |
| `\cref{sec:label}` | بخش ۱.۱ | |
| `\Cref{...}` | Same as `\cref` (Persian has no case) | |

### Helper Reference Commands (v1.1)

These helpers are provided by `mb-theorem.sty` and delegate to `\cref`:

| Command | Delegates to |
|---------|--------------|
| `\thmref{label}` | `\cref{label}` |
| `\lemref{label}` | `\cref{label}` |
| `\corref{label}` | `\cref{label}` |
| `\propref{label}` | `\cref{label}` |
| `\defref{label}` | `\cref{label}` |
| `\exref{label}` | `\cref{label}` |
| `\remref{label}` | `\cref{label}` |
| `\excref{label}` | `\cref{label}` |

> **Note:** These helpers exist for semantic clarity. `\thmref{thm:main}` is equivalent to `\cref{thm:main}`.

### Multiple References

`cleveref` supports multiple references and ranges:

```latex
\cref{thm:a,thm:b,thm:c}       % "قضایای ۱.۱ تا ۱.۳"
\crefrange{eq:a}{eq:c}         % "معادلات ۱.۱ تا ۱.۳"
```

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
| `\argmax` | argmax | Argmax |
| `\argmin` | argmin | Argmin |
| `\sinc` | sinc | Sinc function |
| `\sgn` | sgn | Sign function |
| `\erf` | erf | Error function |
| `\deriv{}{x}` | d/dx | Ordinary derivative |
| `\pderiv{f}{x}` | ∂f/∂x | Partial derivative |
| `\dd{x}` | dx | Differential |
| `\D` | d | Differential (short) |
| `\given` | \| | Set builder separator |

### Code Display Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `\inlcode{text}` | `\inlcode{print()}` | Inline monospace code |
| `\pc{text}` | `\pc{متن فارسی}` | Persian text inside minted code |
| `\codecaption{title}` | `\codecaption{عنوان کد}` | Code caption with numbering |
| `\coderef{label}` | `\coderef{code:hello}` | Reference to code listing |

> **Note:** For code blocks, use the standard `minted` environment inside `\begin{latin}...\end{latin}`. Then add `\codecaption{}` and `\label{}` after the environment.

### Algorithm Commands

In MatinBook v1.1, algorithms use the **standard `algorithm` package** with **`xepersian`'s built-in adaptation**. There is **no `\algcaption`** command anymore.

Use the standard `algorithm` + `algorithmic` environments:

```latex
\begin{latin}
\begin{algorithm}
\caption{Persian or English caption}
\label{alg:myalgo}
\begin{algorithmic}[1]
    \Require Input description
    \Ensure Output description
    \State ...
\end{algorithmic}
\end{algorithm}
\end{latin}
```

> **Why no `\algcaption`?**
> `xepersian` ships `algorithm-xepersian.def`, which automatically translates:
> - `\ALG@name` → «الگوریتم»
> - `\listalgorithmname` → «فهرست الگوریتم‌ها»
>
> So you just use `\caption{}` inside the `algorithm` environment.

### Index Commands

| Command | Usage |
|---------|-------|
| `\index{term}` | Main entry |
| `\index{term!subterm}` | Sub-entry |
| `\index{term!sub!subsub}` | Sub-sub-entry |
| `\idxbold{term}` | Bold entry |
| `\idxitalic{term}` | Italic entry |
| `\idxsee{from}{to}` | See reference |
| `\idxseealso{from}{to}` | See also reference |
| `\idxsub{main}{sub}` | Quick sub-entry |
| `\idxsubsub{main}{sub}{subsub}` | Quick sub-sub-entry |
| `\printindex` | Print index (in back matter) |

> **CRITICAL:** MatinBook v1.1 uses **`xindy`** (not `makeindex`) because `makeindex` cannot sort Persian correctly (it fails on پ، چ، ژ، گ، ک).

### Utility Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `\latintitle{text}` | `\latintitle{My Book}` | Latin title (for bilingual covers) |
| `\latinauthor{text}` | `\latinauthor{Author}` | Latin author |
| `\matin@ifcmd{cmd}{true}{false}` | Conditional | Check if command exists |

### Class Options

| Option | Effect |
|--------|--------|
| `draft` | Draft mode (watermark + overfull rules) |
| `final` | Final mode |
| `niloofar` | XB Niloofar font (default) |
| `vazirmatn` | Vazirmatn font |
| `sahel` | Sahel font |
| `irlotus` | IR Lotus font |
| `bnazanin` | B Nazanin font (commercial) |

---

## 6. Color System

### 20 Defined Colors (CMYK, 5 Families × 3 Shades + Neutrals)

MatinBook v1.1 uses **CMYK** color model (per Iranian educational publishing standard ز/۱-۴). All percentages are multiples of 5 or 10.

#### Blue Family (Theorems — Dominant Color)

```latex
matinblue        cmyk(0.80, 0.30, 0.00, 0.30)   % Primary
matindarkblue    cmyk(0.80, 0.30, 0.00, 0.60)   % Dark
matinlightblue   cmyk(0.15, 0.05, 0.00, 0.05)   % Light
```

#### Green Family (Definitions/Solutions)

```latex
matingreen       cmyk(0.80, 0.00, 0.45, 0.30)   % Primary
matindarkgreen   cmyk(0.80, 0.00, 0.45, 0.65)   % Dark
matinlightgreen  cmyk(0.10, 0.00, 0.05, 0.05)   % Light
```

#### Orange Family (Examples/Remarks/Exercises)

```latex
matinorange      cmyk(0.00, 0.45, 0.85, 0.10)   % Primary
matindarkorange  cmyk(0.00, 0.45, 0.85, 0.55)   % Dark
matinlightorange cmyk(0.00, 0.05, 0.15, 0.00)   % Light
```

#### Red Family (Alerts/Remarks)

```latex
matinred         cmyk(0.00, 0.65, 0.75, 0.10)   % Primary
matindarkred     cmyk(0.00, 0.65, 0.75, 0.55)   % Dark
matinlightred    cmyk(0.00, 0.15, 0.15, 0.00)   % Light
```

#### Purple Family (Exercises)

```latex
matinpurple      cmyk(0.20, 0.60, 0.00, 0.30)   % Primary
matindarkpurple  cmyk(0.20, 0.60, 0.00, 0.65)   % Dark
matinlightpurple cmyk(0.05, 0.10, 0.00, 0.05)   % Light
```

#### Neutral Colors

```latex
matindarkgray    cmyk(0.45, 0.25, 0.00, 0.70)   % Body text (near-black)
matinmediumgray  cmyk(0.10, 0.00, 0.00, 0.35)   % Secondary text
matinlightgray   cmyk(0.00, 0.00, 0.00, 0.05)   % Background
matinbordergray  cmyk(0.05, 0.00, 0.00, 0.20)   % Borders
matincream       cmyk(0.00, 0.00, 0.00, 0.00)   % Off-white background
```

### Color Aliases (Cover, v1.1)

The cover uses aliases mapped to the main palette:

```latex
coverprimary     → matindarkgreen   % dark green
coveraccent      → matinorange      % warm orange
covergray        → matinmediumgray  % gray
coverlight       → matinlightgray   % light gray
```

> **Note:** This ensures the cover uses the same CMYK palette as the rest of the book.

### Color Usage

```latex
\textcolor{matinblue}{Text}           % Colored text
\colorbox{matinlightblue}{Text}       % Colored background
\color{matinred}                      % Switch color
{\color{matinblue}Text}               % Grouped color
```

### Color Rules for Academic Writing

1. **Never use more than 3 colors on a single page** (excluding box colors)
2. **Use colors semantically, not decoratively** — blue for theorems, green for definitions, orange for examples
3. **Maintain 4.5:1 contrast ratio** for accessibility (all MatinBook colors comply)
4. **Avoid pure black on pure white** — use `matindarkgray` (near-black) for body text
5. **The dominant color is blue** — all other colors are functional accents

### Available Color Mixtures

Since all colors are defined with `\providecolor`, you can create lighter/darker variants:

```latex
matinblue!20    % Very light blue
matinblue!40    % Light blue
matinblue!60    % Medium blue
matinblue!80    % Dark blue
```

> **Note:** You can also **override** any MatinBook color in your document by calling `\definecolor{matinblue}{cmyk}{...}` **before** loading the class. Since MatinBook uses `\providecolor`, your definition will be preserved.

---

## 7. Typography and Fonts

### Font Configuration

MatinBook v1.1 configures fonts **directly in `matinbook.cls`**, AFTER `xepersian` is loaded (because `\settextfont` is defined by `xepersian`).

| Type | Font | Features |
|------|------|----------|
| Persian text | XB Niloofar (default) | Scale=1.2 |
| Latin text | Times New Roman | Fallback: TeX Gyre Termes |
| Mathematics | XITS Math | Fallback: Latin Modern Math |
| Monospace | DejaVu Sans Mono | For `\texttt` |
| Code | JetBrains Mono | Fallback: DejaVu Sans Mono, Courier New |

### Font Selection via Class Options

```latex
\documentclass[niloofar]{matinbook}   % XB Niloofar (default)
\documentclass[vazirmatn]{matinbook}  % Vazirmatn
\documentclass[sahel]{matinbook}      % Sahel
\documentclass[irlotus]{matinbook}    % IR Lotus
\documentclass[bnazanin]{matinbook}   % B Nazanin (commercial, incomplete glyphs)
```

> ⚠️ **Warning:** B Nazanin is a commercial font with incomplete glyph coverage. It is **not recommended** for technical books. Use XB Niloofar or Vazirmatn instead.

### Typography Settings (in `mb-typography.sty`)

```latex
\microtypesetup{
    activate={true,nocompatibility},
    protrusion=true,    % Character protrusion (XeTeX supports this)
    expansion=false,    % XeTeX does NOT support font expansion
    final,
    verbose=silent
}

\SetProtrusion{encoding={TU,EU1,EU2}}{
    \textquotedblleft = {1000, },
    \textquotedblright = { ,1000},
    .  = { ,700},
    ,  = { ,700},
    :  = { ,500},
    ;  = { ,500}
}

\emergencystretch=1em   % Reduced from 3em (Persian uses Kashida)
\hbadness=3000
\tolerance=3000

\widowpenalty=10000     % Prevent widow lines
\clubpenalty=10000      % Prevent orphan lines

\hyphenpenalty=750
\exhyphenpenalty=750
\doublehyphendemerits=1000000
\finalhyphendemerits=0
```

### Kashida (Persian Letter Stretching)

MatinBook v1.1 includes `xepersian-hm` for Kashida support:

```latex
\IfFileExists{xepersian-hm.sty}{
    \RequirePackage[Kashida=off]{xepersian-hm}
}{
    \PackageWarning{mb-typography}{xepersian-hm not found}
}
```

> **Note:** Kashida is **disabled by default** because it produces unnatural spacing in technical books. To enable, change `Kashida=off` to `Kashida=glyph` (requires 3 compilation passes).

### Typography Rules for Academic Writing

1. **Line length:** 60-75 characters per line
2. **Line spacing:** 1.15 (MatinBook default, Boyer/Stewart style) — optimal for Persian script
3. **Paragraph spacing:** `\parskip=0pt` — no extra spacing
4. **First-line indent:** `\parindent=1em` — Persian standard
5. **No first-line indent after headings** — MatinBook handles this automatically

### When to Use `\lr{}` vs `\begin{latin}`

| Situation | Command |
|-----------|---------|
| Single English word | `\lr{word}` |
| English phrase (1 line) | `\lr{phrase of words}` |
| Full English paragraph | `\begin{latin}...\end{latin}` |
| Code block | `\begin{latin}...\end{latin}` |
| Algorithm | `\begin{latin}...\end{latin}` |
| TikZ diagram | `\begin{latin}...\end{latin}` |
| Bibliography | (no wrapper needed) |
| URL | `\lr{https://...}` |

---

## 8. Page Layout

### Geometry (Mainmatter — Wide Margin for Notes)

```latex
\geometry{
    paperwidth=17.8cm,    % 7 × 10 in (Boyer/Stewart)
    paperheight=25.4cm,
    top=1.7cm,
    bottom=1.7cm,
    inner=1.5cm,          % Toward binding
    outer=5.9cm,          % Wide — for margin notes
    marginparwidth=3.5cm, % Width of margin note area
    marginparsep=0.6cm,   % Gap between text and note
    headheight=15pt,
    headsep=5pt,
    footskip=18pt,
    bindingoffset=0.4cm
}
```

### Frontmatter Geometry (Symmetric, No Wide Margin)

```latex
\frontmattergeometry
% → inner=1.5cm, outer=1.5cm, no marginparwidth
```

Used in:
- Copyright page
- Dedication
- Preface
- Table of Contents / List of Figures / List of Tables
- Bibliography
- Index

### Page Layout Standards

| Element | Mainmatter | Frontmatter |
|---------|------------|-------------|
| Paper width | 17.8 cm | 17.8 cm |
| Paper height | 25.4 cm | 25.4 cm |
| Top margin | 1.7 cm | 1.7 cm |
| Bottom margin | 1.7 cm | 1.7 cm |
| Inner margin | 1.5 cm | 1.5 cm |
| Outer margin | **5.9 cm** (wide) | **1.5 cm** (symmetric) |
| Margin note width | 3.5 cm | — |
| Margin note gap | 0.6 cm | — |
| Binding offset | 0.4 cm | 0.4 cm |
| Text width | ~10.3 cm | ~14.3 cm |

### Line Spacing

```latex
\setstretch{1.15}   % Boyer/Stewart textbook leading
```

### Paragraph Settings

```latex
\setlength{\parindent}{1em}
\setlength{\parskip}{0pt}
```

### Header/Footer (twoside)

- **Even pages (left side):** Chapter name (`\leftmark`)
- **Odd pages (right side):** Chapter name (`\leftmark`)
- **Page number:** In footer, no rule
- **Chapter start pages:** Plain style (page number only in footer)

### How to Set the Book Title

```latex
\booktitle{عنوان کتاب من}
```

This appears in the header of even pages.

### Draft Watermark

In `draft` mode, MatinBook adds a watermark:

```latex
\documentclass[draft]{matinbook}
```

The watermark text is "DRAFT" at 1.5x scale with light gray color.

### Caption Settings

```latex
\captionsetup{
    font=footnotesize,
    labelfont=bf,
    skip=8pt,
    justification=centering
}
```

### Footnote Settings

```latex
\setlength{\footnotesep}{8pt}
\renewcommand{\footnoterule}{%
    \kern-3pt
    \hrule width 0.3\textwidth height 0.4pt
    \kern2.6pt
}
```

---

## 8b. Margin Notes (RTL)

### Overview

MatinBook v1.1 adds a **wide outer margin** (5.9cm) with margin note support for RTL documents. This feature is inspired by classic textbook layouts (Boyer, Stewart) where the outer margin holds figures, formulas, or explanatory notes.

### API

| Command | Usage | Description |
|---------|-------|-------------|
| `\mnote{text}` | `\mnote{یادداشت}` | Plain margin note (RTL, no number) |
| `\marginfig{file}{caption}` | `\marginfig{plot.png}{نمودار}` | Figure with caption in margin |

### How It Works

- Uses the standard `\marginpar` (LaTeX kernel-level) for odd/even placement.
- Wraps content in `\RL{}` (from xepersian) to force RTL direction.
- **Does NOT use `\reversemarginpar`** (would double-reverse the position).
- Position: outer margin on both odd (right) and even (left) pages.

### Direction Behavior

| Page | Margin side | Note direction |
|------|-------------|----------------|
| Odd (recto) | Left | RTL (via `\RL{}`) |
| Even (verso) | Right | RTL (via `\RL{}`) |

### Usage Example

```latex
\chapter{فصل اول}

این یک متن اصلی است.
\mnote{این یک یادداشت حاشیه‌ای است.}
و این ادامه‌ی متن اصلی است.

\marginfig{figures/plot.png}{نمودار نمونه}
```

### Limitations

- `\mnote` cannot be used inside `tcolorbox` or `figure` environments
  (limitation of `\marginpar`).
- Requires a wide outer margin, which reduces the main text width.
- Needs at least 2 compilation passes for stable positioning.

### Compilation

```bash
xelatex -shell-escape document.tex
xelatex -shell-escape document.tex
```

---

## 8c. Frontmatter / Mainmatter Split

MatinBook v1.1 provides two geometry commands:

| Command | Purpose |
|---------|---------|
| `\frontmattergeometry` | Symmetric margins (no wide margin) for frontmatter and backmatter |
| `\mainmattergeometry` | Restore the wide-margin geometry for main chapters |

### Usage

```latex
\frontmatter
\frontmattergeometry          % symmetric margins

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

### Which pages use which geometry?

| Section | Geometry |
|---------|----------|
| Cover (before `\frontmatter`) | Original wide-margin (but full page) |
| Frontmatter | Symmetric (`\frontmattergeometry`) |
| Mainmatter | Wide margin (`\mainmattergeometry`) |
| Backmatter | Symmetric (`\frontmattergeometry`) |
| Back cover | Original wide-margin (but full page) |

### Why Split?

- **Frontmatter** (copyright, preface, ToC) doesn't need margin notes — it uses the full width.
- **Mainmatter** (chapters) needs the wide outer margin for `\mnote` and `\marginfig`.
- **Backmatter** (bibliography, index) is reference material — no margin notes needed.

### Technical Note

`\newgeometry` (used inside `\frontmattergeometry`) **cannot change** `paperwidth` or `paperheight`. Those are only set once by `\geometry`. This is why `\frontmattergeometry` omits them.

**End of Section 6-8**

## 9. Mathematics

### Equation Numbering (Iranian Standard)

MatinBook v1.1 uses the **Iranian standard** for equation numbering: `(formula-chapter)` format.

```latex
\numberwithin{equation}{chapter}
\renewcommand{\theequation}{\arabic{equation}-\thechapter}
```

Example output: `(۱-۱)` means "formula 1 of chapter 1".

### Equation Numbering in Practice

| Chapter | Equation | Display |
|---------|----------|---------|
| 1 | 1st | (۱-۱) |
| 1 | 2nd | (۲-۱) |
| 2 | 1st | (۱-۲) |
| 2 | 2nd | (۲-۲) |

> **Note:** The rightmost number is the **chapter**, the leftmost is the **formula number within that chapter**. This matches University of Tehran and UMZ standards.

### Allowed Display Breaks

`\allowdisplaybreaks` is enabled — long `align` environments can break across pages.

### Math Operators

MatinBook defines custom operators via `\DeclareMathOperator` (wrapped in `\AtBeginDocument` because `unicode-math` overrides them at `\begin{document}`):

#### Vector Calculus
```latex
\grad    → grad
\curl    → curl
\diver   → div
```

#### Linear Algebra
```latex
\rank    → rank
\diag    → diag
\trace   → trace
```

#### Optimization
```latex
\argmax  → argmax
\argmin  → argmin
```

#### Number Theory
```latex
\lcm     → lcm
\gcdop   → gcd
```

#### Special Functions
```latex
\sinc    → sinc
\sgn     → sgn
\erf     → erf
```

### Number Sets

```latex
\N  → ℕ
\Z  → ℤ
\Q  → ℚ
\R  → ℝ
\C  → ℂ
```

> **Note:** These use `\providecommand` so they can be overridden by other packages.

### Smart Delimiters

MatinBook uses `\DeclarePairedDelimiter` from `mathtools`:

| Command | Output |
|---------|--------|
| `\abs{x}` | \|x\| |
| `\norm{x}` | ‖x‖ |
| `\ceil{x}` | ⌈x⌉ |
| `\floor{x}` | ⌊x⌋ |
| `\inner{u}{v}` | ⟨u,v⟩ |
| `\paren{x}` | (x) |

These commands **automatically scale** with `\left` and `\right`:

```latex
\abs{\frac{a}{b}}    % Scaled bars
\norm{\sum_{i=1}^{n}} % Scaled norm
```

### Set Notation

```latex
\set{1, 2, 3}                   % {1, 2, 3}
\setbuilder{x \in \R}{x > 0}    % {x ∈ ℝ | x > 0}
```

### Matrix Commands

| Command | Output |
|---------|--------|
| `\mat{1 & 2 \\ 3 & 4}` | [matrix with brackets] |
| `\pmat{1 & 2 \\ 3 & 4}` | (matrix with parens) |
| `\vmat{1 & 2 \\ 3 & 4}` | \|matrix (determinant)\| |

### Derivatives and Integrals

| Command | Output |
|---------|--------|
| `\dd{x}` | dx |
| `\D` | d (short form) |
| `\deriv{f}{x}` | df/dx |
| `\pderiv{f}{x}` | ∂f/∂x |

### Usage Examples

```latex
% Basic equation
\begin{equation}
    \label{eq:pythagoras}
    a^{2} + b^{2} = c^{2}
\end{equation}

% Aligned equations
\begin{align}
    f(x) &= a_{0} + a_{1}x + a_{2}x^{2} \nonumber \\
         &\quad + a_{3}x^{3} + \cdots \\
    &= \sum_{i=0}^{\infty} a_{i}x^{i}
\end{align}

% Custom operators
\[
    \grad f = \nabla f, \quad
    \diver \vec{F} = \nabla \cdot \vec{F}, \quad
    \curl \vec{F} = \nabla \times \vec{F}
\]

% Number sets
\[
    \N \subset \Z \subset \Q \subset \R \subset \C
\]

% Matrices
\[
    A = \mat{1 & 2 & 3 \\ 4 & 5 & 6 \\ 7 & 8 & 9}
\]

% Derivatives
\[
    \deriv{f}{x} = \lim_{h \to 0} \frac{f(x + h) - f(x)}{h}
\]

% Sets
\[
    S = \setbuilder{x \in \R}{x^{2} < 2}
\]
```

### Math Writing Rules

1. **No math mode in section titles** — use Unicode characters:
   ```latex
   % WRONG:
   \section{تحلیل $O(n)$}
   
   % CORRECT:
   \section{تحلیل O(n)}
   ```

2. **Use `\lr{}` for inline math with Latin content**:
   ```latex
   پیچیدگی این الگوریتم \lr{$O(n \log n)$} است.
   ```

3. **Punctuate equations** — they are part of sentences:
   ```latex
   % CORRECT:
   اگر $a = b$، آنگاه:
   \[
       a^{2} = b^{2}.
   \]
   
   % WRONG (no period):
   اگر $a = b$، آنگاه:
   \[
       a^{2} = b^{2}
   \]
   ```

4. **Break long equations at logical points**:
   ```latex
   \begin{align}
       f(x) &= a_{0} + a_{1}x + a_{2}x^{2} + \cdots \nonumber \\
            &\quad + a_{n}x^{n}
   \end{align}
   ```

---

## 10. Code Display

### Configuration (in `mb-code.sty`)

```latex
\setminted{
    fontsize=\footnotesize,
    linenos=true,
    numbersep=8pt,
    frame=lines,               % NOT single (breaks with breaklines)
    framesep=10pt,
    rulecolor=\color{matinbordergray},
    bgcolor=matinlightgray!30,
    breaklines=true,
    breakanywhere=false,       % Avoids breaking identifiers
    autogobble=true,
    tabsize=4,
    escapeinside=||,           % For Persian comments
    baselinestretch=0.95,
    style=friendly
}
```

> **Note:** `bgcolorpadding` is **NOT used** because it requires `fvextra` v1.8+ (TeX Live 2024+). In TeX Live 2023, `bgcolor` already includes padding.

### Persian Code Font

```latex
\defpersianfont\persiancodingfont{DejaVu Sans Mono}[Script=Arabic,Scale=0.9]
\newcommand{\pc}[1]{\rl{\persiancodingfont #1}}
```

> **Note:** This is wrapped in `\AtBeginDocument` because `mb-code` is loaded before `xepersian`.

### Code Block Pattern

```latex
\begin{latin}
\begin{minted}{python}
def factorial(n: int) -> int:
    """Calculate n! recursively."""
    # Comments MUST be in English
    if n <= 1:
        return 1
    return n * factorial(n - 1)
\end{minted}
\end{latin}
\codecaption{محاسبه فاکتوریل}
\label{code:factorial}
```

### Code with Persian Comments (using `\pc`)

```latex
\begin{latin}
\begin{minted}{python}
def greet(name: str) -> str:
    """|\pc{تابع سلام}|"""
    # |\pc{فراخوانی تابع با نام فارسی}|
    return f"Hello, {name}!"
\end{minted}
\end{latin}
\codecaption{تابع سلام}
\label{code:greet}
```

> **CRITICAL:** Persian comments inside code MUST use `|\pc{...}|` syntax (with `escapeinside=||`).

### Inline Code

```latex
تابع \inlcode{factorial()} یک تابع بازگشتی است.
```

### Supported Languages

All languages supported by Pygments (300+):

- **Programming:** `python`, `cpp`, `c`, `java`, `javascript`, `typescript`, `rust`, `go`, `ruby`, `php`, `swift`, `kotlin`, `scala`
- **Markup:** `html`, `xml`, `markdown`, `latex`, `yaml`, `json`, `toml`
- **Shell:** `bash`, `zsh`, `powershell`
- **Database:** `sql`, `postgresql`, `mysql`
- **Other:** `text` (plain), `diff`, `makefile`, `docker`

### Code Writing Rules

1. **All comments in English** — Persian comments only via `|\pc{...}|`
2. **Max 80 characters per line** — longer lines wrap automatically
3. **4-space indentation** — Python standard, also works for other languages
4. **Meaningful variable names** — no `a`, `b`, `c` unless mathematical
5. **Docstrings for functions** — Google or NumPy style
6. **No trailing whitespace** — clean code
7. **Always introduce code with a sentence** before the block
8. **Always reference code with `\cref{}`** or `\coderef{}`

### Code Length Guidelines

| Type | Ideal | Maximum |
|------|-------|---------|
| Inline code | 1-20 chars | 40 chars |
| Short snippet | 5-15 lines | 25 lines |
| Full listing | 15-40 lines | 60 lines |
| If longer | Split into multiple listings | |

---

## 11. Algorithms and Pseudocode

### IMPORTANT: MatinBook v1.1 Uses Standard `algorithm` Package

In v1.1, there is **no `\algcaption`** command. `xepersian` provides `algorithm-xepersian.def` which automatically translates:

- `\ALG@name` → «الگوریتم»
- `\listalgorithmname` → «فهرست الگوریتم‌ها»

You just use the standard `\caption{}` inside the `algorithm` environment.

### Algorithm Pattern (MUST follow exactly)

```latex
\begin{latin}
\begin{algorithm}
\caption{جستجوی دودویی}
\label{alg:binary-search}
\begin{algorithmic}[1]
    \Require Sorted array $A[1..n]$ of integers
    \Require Target value $x$
    \Ensure Index of $x$ in $A$, or $-1$ if not found
    \State $left \gets 1$
    \State $right \gets n$
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
```

### RULES FOR ALGORITHMS

1. **The entire `algorithm` environment MUST be inside `\begin{latin}...\end{latin}`**
2. **All pseudocode text inside `algorithmic` MUST be in English**
3. **The caption (`\caption{}`) can be in Persian**
4. Every `\If` must have `\EndIf`
5. Every `\For` must have `\EndFor`
6. Every `\While` must have `\EndWhile`
7. Every `\Function` must have `\EndFunction`
8. Every `\ForAll` must have `\EndFor`
9. `\Return` inside `\If` still requires `\EndIf` before the next statement
10. **Labels MUST be inside the `algorithm` environment** (after `\caption`)
11. **Use `\begin{algorithmic}[1]` for numbered lines**

### Available Algorithmic Commands

```latex
\Require, \Ensure               % Pre/post conditions
\State                         % Simple statement
\Statex                        % Unnumbered statement
\If, \ElsIf, \Else, \EndIf      % Conditionals
\For, \EndFor                   % For loops
\ForAll, \EndFor                % For-all loops
\While, \EndWhile               % While loops
\Repeat, \Until                 % Repeat-until loops
\Function, \EndFunction         % Function definitions
\Call{name}{args}               % Function calls
\Return                        % Return statement
\Comment{text}                  % Inline comment
\textbf{text}                   % Bold text
\text{text}                     % Normal text
```

### Algorithm Naming Convention

| Type | Convention | Example |
|------|------------|---------|
| Input | Descriptive | `A`, `target`, `n` |
| Loop counter | `i`, `j`, `k` | `\For{$i \gets 1$}` |
| Temporary | `temp`, `tmp` | `\State $temp \gets A[i]$` |
| Result | `result`, `ans` | `\State \Return result` |

### Algorithm Length

- **Ideal:** 5-15 lines
- **Maximum:** 25 lines
- **If longer:** Split into sub-algorithms

### Referencing Algorithms

Use `\cref{}`:

```latex
الگوریتم \cref{alg:binary-search} فرآیند جستجوی دودویی را نشان می‌دهد.
```

Output: "الگوریتم ۱.۱ فرآیند جستجوی دودویی را نشان می‌دهد."

### List of Algorithms

To include a list of algorithms, uncomment in `main.tex`:

```latex
\listofalgorithms
```

> ⚠️ **Warning:** Only include this if your book actually uses algorithms. Otherwise, it produces an empty list with a title.

---

## 12. Graphics and Diagrams

### Graphics Packages (in `mb-graphics.sty`)

MatinBook v1.1 loads:

```latex
\RequirePackage{tikz}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18}
\RequirePackage{pgf-pie}
```

> **Note:** `pgf-pie` was moved from `mb-core` to `mb-graphics` in v1.1 (per review #3).

### Available TikZ Libraries

```latex
\usetikzlibrary{
    shapes,
    arrows,
    positioning,
    calc,
    patterns,
    decorations.pathreplacing,
    decorations.pathmorphing,
    decorations.markings,
    backgrounds,
    fit,
    matrix,
    mindmap,
    trees,
    shadows,
    arrows.meta,
    quotes,
    graphs,
    graphs.standard
}
```

### Custom TikZ Styles

MatinBook defines the following styles for flowcharts and diagrams:

```latex
% Standard block
block/.style={
    rectangle,
    draw=matindarkblue,
    fill=matinlightblue!20,
    text width=6em,
    text centered,
    rounded corners,
    minimum height=3em,
    font=\small
}

% Decision diamond
decision/.style={
    diamond,
    draw=matinorange,
    fill=matinlightorange!20,
    text width=3em,
    text centered,
    inner sep=0pt,
    font=\small
}

% Arrow
arrow/.style={
    thick,
    ->,
    >=stealth
}

% Node with shadow
shadowed/.style={
    draw,
    fill=white,
    drop shadow
}

% Binary tree node
treenode/.style={
    circle,
    draw=matinblue,
    fill=matinlightblue!30,
    minimum size=0.8cm,
    font=\small
}
```

### PGFPlots Settings

```latex
\pgfplotsset{
    every axis/.style={
        grid=major,
        grid style={dashed, gray!30},
        axis lines=center,
        axis line style={-stealth, thick},
        xlabel style={anchor=west},
        ylabel style={anchor=south},
        legend style={
            draw=none,
            fill=matinlightgray!30,
            rounded corners=3pt
        },
        title style={
            font=\bfseries
        },
        label style={
            font=\small
        },
        tick label style={
            font=\footnotesize
        }
    },
    ybar/.style={
        bar width=15pt,
        ymajorgrids=true,
        nodes near coords,
        nodes near coords align={vertical}
    }
}
```

### Plot Color Palette

MatinBook defines a custom cycle list for multi-curve plots:

```latex
\pgfplotscreateplotcyclelist{matinbook}{
    {matinblue, thick},
    {matingreen, thick},
    {matinorange, thick},
    {matinred, thick},
    {matinpurple, thick},
    {matindarkblue, thick},
    {matindarkgreen, thick},
    {matindarkorange, thick}
}

\pgfplotsset{
    cycle list name=matinbook
}
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

### Figure Pattern with TikZ

```latex
\begin{figure}[h]
\centering
\begin{latin}
\begin{tikzpicture}
    \begin{axis}[
        width=12cm,
        height=7cm,
        xlabel={$x$},
        ylabel={$f(x)$},
        title={Function Plot},
        legend pos=north west
    ]
        \addplot[matinblue, thick, smooth, domain=-3:3] {x^2};
        \addlegendentry{$y = x^2$}
        
        \addplot[matingreen, thick, smooth, domain=-3:3] {x^3/3};
        \addlegendentry{$y = x^3/3$}
    \end{axis}
\end{tikzpicture}
\end{latin}
\caption{نمودار توابع $f(x) = x^{2}$ و $g(x) = x^{3}/3$}
\label{fig:plot-example}
\end{figure}
```

### Flowchart Pattern

```latex
\begin{figure}[h]
\centering
\begin{latin}
\begin{tikzpicture}[node distance=2cm]
    \node[block] (start) {Start};
    \node[decision, below of=start] (check) {$x > 0$?};
    \node[block, below of=check] (positive) {Positive};
    \node[block, right of=check, node distance=3cm] (negative) {Negative};
    
    \draw[arrow] (start) -- (check);
    \draw[arrow] (check) -- node[left] {Yes} (positive);
    \draw[arrow] (check) -- node[above] {No} (negative);
\end{tikzpicture}
\end{latin}
\caption{نمودار جریان یک الگوریتم ساده}
\label{fig:flowchart-example}
\end{figure}
```

### Binary Tree Pattern

```latex
\begin{latin}
\begin{tikzpicture}[
    level/.style={sibling distance=3cm/#1, level distance=1.5cm}
]
    \node[treenode] {1}
        child { node[treenode] {2}
            child { node[treenode] {4} }
            child { node[treenode] {5} }
        }
        child { node[treenode] {3}
            child { node[treenode] {6} }
            child { node[treenode] {7} }
        };
\end{tikzpicture}
\end{latin}
```

### Pie Chart Pattern

```latex
\begin{latin}
\begin{tikzpicture}
    \pie[radius=2, text=legend, color={
        matinblue, matingreen, matinorange, matinred
    }]{
        30/Blue,
        25/Green,
        25/Orange,
        20/Red
    }
\end{tikzpicture}
\end{latin}
```

### IMPORTANT: Persian Text in TikZ

> ⚠️ **CRITICAL:** Persian text inside TikZ nodes MUST be wrapped in `\rl{}`:
> 
> ```latex
> \node {\rl{متن فارسی}};
> ```
> 
> **Why?** `bidi` (loaded by `xepersian`) automatically wraps `tikzpicture` in LTR context. Without `\rl{}`, Persian text renders left-to-right (scrambled).

### KNOWN LIMITATION: `lstlisting`/`minted` in TikZ Nodes

Due to a **LaTeX kernel change** (Tagging97, 2024-07-10), `lstlisting` and `minted` **cannot** be placed inside TikZ nodes. Attempting to do so causes a compile error.

**Workaround:** Use `\hbox{...}` around the listing, or avoid placing code inside TikZ nodes.

> **Note:** This is a LaTeX kernel issue, not a MatinBook issue. It may be fixed in future versions of PGF/TikZ.

### Figure Numbering (Iranian Standard)

Figures are numbered as `chapter-figure`:

```latex
\thefigure = \thechapter-\arabic{figure}
```

Example: `شکل ۱-۲` means "figure 2 of chapter 1".

### Figure Caption Position

- **Figures:** Caption **below** the figure (Iranian standard)
- **Tables:** Caption **above** the table (Iranian standard)

MatinBook handles this automatically via `caption` package settings.

---

## 13. Cross-References

### Cleveref Integration

MatinBook v1.1 uses **`cleveref`** as the primary cross-reference system. Persian names are provided by `fa-IR.sty`.

### Available Commands

| Command | Output Example |
|---------|----------------|
| `\cref{label}` | Smart reference (auto-detects type) |
| `\Cref{label}` | Same as `\cref` (Persian has no case) |
| `\crefrange{label1}{label2}` | Range reference |
| `\cref{a,b,c}` | Multiple references |

### Helper Commands (v1.1)

| Command | Equivalent |
|---------|------------|
| `\thmref{label}` | `\cref{label}` |
| `\lemref{label}` | `\cref{label}` |
| `\corref{label}` | `\cref{label}` |
| `\propref{label}` | `\cref{label}` |
| `\defref{label}` | `\cref{label}` |
| `\exref{label}` | `\cref{label}` |
| `\remref{label}` | `\cref{label}` |
| `\excref{label}` | `\cref{label}` |

### Label Naming Convention

Use descriptive prefixes for labels:

```latex
\label{eq:einstein}              % Equations
\label{thm:fundamental}          % Theorems
\label{lem:euclid}               % Lemmas
\label{cor:mycor}                % Corollaries
\label{prop:myprop}              % Propositions
\label{def:prime}                % Definitions
\label{ex:myexample}             % Examples
\label{rem:myremark}             % Remarks
\label{exc:myexercise}           % Exercises
\label{fig:mychart}              % Figures
\label{tab:mytable}              % Tables
\label{code:mycode}              % Code listings
\label{alg:myalgo}               % Algorithms
\label{chap:mychapter}           % Chapters
\label{sec:mysection}            % Sections
```

### Usage Examples

```latex
% Single reference:
طبق \cref{thm:fundamental}، هر عدد طبیعی...

% Multiple references:
\cref{def:graph,def:tree} مفاهیم اساسی گراف را تعریف می‌کنند.

% Range reference:
\crefrange{eq:a}{eq:c} سه معادله اول را نشان می‌دهند.

% Smart reference (auto-detects type):
\cref{fig:plot-example} نمودار تابع را نشان می‌دهد.
\cref{tab:comparison} نتایج را مقایسه می‌کند.
```

### Cleveref Configuration (in `fa-IR.sty`)

Persian names are defined via `\crefname`:

```latex
\crefname{equation}{معادله}{معادلات}
\crefname{chapter}{فصل}{فصول}
\crefname{section}{بخش}{بخش‌ها}
\crefname{figure}{شکل}{اشکال}
\crefname{table}{جدول}{جداول}
\crefname{algorithm}{الگوریتم}{الگوریتم‌ها}
\crefname{theorem}{قضیه}{قضایا}
\crefname{lemma}{لم}{لم‌ها}
\crefname{corollary}{نتیجه}{نتایج}
\crefname{definition}{تعریف}{تعاریف}
\crefname{example}{مثال}{مثال‌ها}
\crefname{remark}{نکته}{نکات}
\crefname{exercise}{تمرین}{تمرین‌ها}
\crefname{proposition}{گزاره}{گزاره‌ها}
```

### IMPORTANT: Load Order

`cleveref` is loaded in `mb-core.sty`, **before** `xepersian`. This is correct because:
- `cleveref` requires `hyperref` to be loaded first
- `hyperref` is loaded in `mb-core.sty` before `cleveref`
- `xepersian` is loaded later (in Phase 2 of `matinbook.cls`)

The `\crefname{}` commands are defined in `fa-IR.sty`, which is loaded **after** `xepersian`. This ensures the names are applied correctly in RTL context.

---

## 14. Bibliography

### Configuration (in `mb-core.sty`)

```latex
\RequirePackage[backend=biber,style=numeric,sorting=none]{biblatex}
```

| Setting | Value | Meaning |
|---------|-------|---------|
| `backend` | `biber` | Modern bibliography processor |
| `style` | `numeric` | Citations appear as [1], [2], ... |
| `sorting` | `none` | Bibliography sorted by citation order |

### Adding a Bibliography

In `main.tex` (in preamble):

```latex
\addbibresource{references.bib}
```

### Printing the Bibliography

In `main.tex` (in back matter):

```latex
\backmatter

\printbibliography[title={منابع و مراجع}]
```

> **CRITICAL:** In MatinBook v1.1, **do NOT wrap** `\printbibliography` in `\begin{latin}...\end{latin}`. The Persian title «منابع و مراجع» will render correctly in RTL context. (In v1.0, this was wrapped, which caused scrambling.)

### Citation Commands

| Command | Output | Usage |
|---------|--------|-------|
| `\cite{key}` | [1] | Standard citation |
| `\parencite{key}` | [1] | Parenthetical citation |
| `\textcite{key}` | Author [1] | Textual citation |
| `\autocite{key}` | [1] | Auto-detected |

### Sample `.bib` Entries

```bibtex
@book{knuth1984,
    author    = {Donald E. Knuth},
    title     = {The {\TeX}book},
    year      = {1984},
    publisher = {Addison-Wesley},
    address   = {Reading, MA}
}

@article{einstein1905,
    author  = {Albert Einstein},
    title   = {On the Electrodynamics of Moving Bodies},
    journal = {Annalen der Physik},
    volume  = {17},
    pages   = {891--921},
    year    = {1905}
}

@inproceedings{cormen2009,
    author    = {Thomas H. Cormen and Charles E. Leiserson
                 and Ronald L. Rivest and Clifford Stein},
    title     = {Introduction to Algorithms},
    booktitle = {MIT Press},
    year      = {2009},
    edition   = {3rd}
}

@online{latexproject,
    author  = {{The LaTeX Project}},
    title   = {{\LaTeX} -- A document preparation system},
    url     = {https://www.latex-project.org/},
    urldate = {2024-01-01}
}
```

### Bibliography Style Rules

1. **Minimum references:** 30-50 for a textbook, 50-100 for a monograph
2. **Use `@book` for books**, `@article` for journal papers, `@inproceedings` for conference papers
3. **Always include DOI or URL** for online sources
4. **Sort by citation order** (MatinBook default) — this is common in technical books
5. **Persian references:** Use `\lr{}` for Latin names within Persian entries

### Persian Bibliography Entries

For Persian sources, use the `langid` field:

```bibtex
@book{persian-book,
    author    = {نام نویسنده},
    title     = {عنوان کتاب},
    year      = {۱۴۰۴},
    publisher = {نام ناشر},
    langid    = {persian}
}
```

> **Note:** `biblatex` with `biber` supports `langid=persian` for proper RTL rendering.

---

## 15. Index Generation

### Configuration (in `mb-index.sty`)

MatinBook v1.1 uses **`xindy`** (not `makeindex`) for correct Persian sorting.

```latex
\makeindex[
    intoc,
    program=xindy,
    options={-L persian-variant2 -C utf8 -M texindy -M page-ranges}
]
```

### Why Xindy?

`makeindex` **cannot sort Persian correctly**. It fails to order the Persian-specific letters:

| Letter | Correct Position | makeindex Position |
|--------|------------------|-------------------|
| پ | After ب | Wrong |
| چ | After ج | Wrong |
| ژ | After ز | Wrong |
| گ | After ک | Wrong |
| ک | After گ | Wrong |

**Xindy** with `persian-variant2` handles these correctly.

### Requirements

Xindy and its Persian language module must be installed:

```bash
# Verify installation:
which xindy
which texindy
ls /usr/share/xindy/lang/persian/variant2-utf8.xdy
```

If missing, install via:

```bash
# On Debian/Ubuntu:
sudo apt install xindy
```

### Entry Types

| Command | Usage | Output |
|---------|-------|--------|
| `\index{term}` | Main entry | term, page |
| `\index{term!subterm}` | Sub-entry | term → subterm, page |
| `\index{term!sub!subsub}` | Sub-sub-entry | term → sub → subsub, page |
| `\idxbold{term}` | Bold entry | **term**, page |
| `\idxitalic{term}` | Italic entry | *term*, page |
| `\idxsee{from}{to}` | See reference | from, see to |
| `\idxseealso{from}{to}` | See also | from, see also to |
| `\idxsub{main}{sub}` | Quick sub-entry | main → sub, page |
| `\idxsubsub{main}{sub}{subsub}` | Quick sub-sub | main → sub → subsub, page |

### Usage Examples

```latex
% Simple index entry
الگوریتم\index{الگوریتم} یک مفهوم اساسی است.

% Sub-entry
برنامه‌نویسی\index{برنامه‌نویسی!پایتون} یک زبان محبوب است.

% Sub-sub-entry
ریاضیات\index{ریاضیات!جبر!گروه} شاخه‌ای از ریاضیات است.

% Bold entry (important terms)
مفهوم مهم\idxbold{مفهوم مهم}

% Italic entry (foreign terms)
الگوریتم مرتب‌سازی\idxitalic{Quick Sort}

% See reference
\idxsee{پایتون}{زبان برنامه‌نویسی}

% See also
\idxseealso{برنامه‌نویسی}{الگوریتم}

% Quick sub-entry
\idxsub{ریاضیات}{آنالیز}

% Quick sub-sub-entry
\idxsubsub{علوم کامپیوتر}{الگوریتم}{مرتب‌سازی}
```

### Printing the Index

In `main.tex` (in back matter):

```latex
\backmatter

\printbibliography[title={منابع و مراجع}]

\printindex
```

> **Note:** `intoc` option adds the index to the table of contents.

### Index Style Customization

MatinBook v1.1 uses the default `xepersian` index style. The following commands are available for customization (uncomment in `mb-index.sty`):

```latex
\indexFormat{...}          % Index title format
\indexEntryFormat{...}     % Each entry format
\indexEntryPageTxt{...}    % Text before page numbers
\indexEntryPageFormat{...} % Page number format
\indexEntrySeparator{...}  % Separator between entries
```

### Compilation with Index

Xindy is called automatically via `-shell-escape`:

```bash
xelatex -shell-escape document.tex
biber document
xelatex -shell-escape document.tex
xelatex -shell-escape document.tex
```

> **Note:** No manual `makeindex` or `xindy` command is needed. `imakeidx` handles it automatically when `-shell-escape` is enabled.

---

## 16. Cover System

### Overview

MatinBook v1.1 provides a **redesigned** professional front and back cover:

**Front cover:**
- Full-color dark green background
- Math symbols (`∑ ∫ ∂ π ∞ √ ∇ λ θ ε Σ Ω Δ`)
- Math formulas and programming keywords
  (`def`, `class`, `while`, `return`, `import`, `lambda`)
- Code symbols (`<\ />`, `{ }`, `[ ]`, `=>`, `===`, `!=`)

**Back cover:**
- Full-color dark green background
- **Fantasy math band (0–7cm)**: three rows of
  - Row 1: three parallel sine waves (orange, faded)
  - Row 2: five math formulas (`∫`, `∑`, `∂`, `∇`, `lim`)
  - Row 3: neural network, dotted graph, small formulas,
    code symbols, and large faint symbols
- **Mini-plot**: aligned with "درباره این کتاب" heading at 7cm,
  width scaled ×0.75, height scaled ×1.5
- **Concept tree**: 7 nodes, English labels (A–G), bottom-left
- Barcode strip + ISBN at the bottom

> ⚠️ **CRITICAL:** The cover uses `remember picture, overlay` (TikZ), which **requires at least 2 compilation passes**.

### Front Cover

```latex
\makecover
    {عنوان کتاب}
    {زیرعنوان کتاب}
    {نام نویسنده}
    {مهر ۱۴۰۵}
```

**Parameters:**

| # | Parameter | Example |
|---|-----------|---------|
| 1 | Title | عنوان کتاب |
| 2 | Subtitle | زیرعنوان کتاب |
| 3 | Author | نام نویسنده |
| 4 | Date | مهر ۱۴۰۵ |

### Back Cover

```latex
\makebackcover{%
    توضیحات پشت جلد کتاب را اینجا بنویسید...
}
```

> **CRITICAL:** `\makebackcover` MUST be at the **end** of the document (before `\end{document}`).

### Repository Info

The cover shows the repository URL. To customize:

```latex
\renewcommand{\repository}{github.com/your-username/your-book}
```

Default: `github.com/matinbook`

### Version Info

The cover shows `v\matinbookversion`. This is defined in `matinbook.cls`:

```latex
\def\matinbookversion{1.1}
\def\matinbookdate{2026/10/08}
```

### Cover Colors

The cover uses **aliases** mapped to the main CMYK palette:

| Cover Alias | Maps To |
|-------------|---------|
| `coverprimary` | `matindarkgreen` |
| `coveraccent` | `matinorange` |
| `covergray` | `matinmediumgray` |
| `coverlight` | `matinlightgray` |

This ensures the cover uses the same CMYK palette as the rest of the book.

### Compilation for Cover

```bash
# Pass 1 — TikZ position info written to .aux
xelatex -shell-escape document.tex

# Pass 2 — TikZ uses .aux to position elements correctly
xelatex -shell-escape document.tex
```

> 💡 **Tip:** If the cover appears misaligned or missing elements, run a third pass.


## 17. Theme System

### Default Theme

MatinBook v1.1 has a **single** theme: `default`.

**Components:**

| File | Purpose |
|------|---------|
| `mb-theme-colors.sty` | 20 CMYK colors in 5 families |
| `mb-theme-cover.sty` | Full-color front and back cover design |
| `mb-theme-default.sty` | Theme loader |

> **Note:** An earlier "Minimal" theme was removed in v1.0 due to incompatibility with core modules. The `default` theme is currently the only supported theme.

### Loading Order

`mb-theme-colors` is loaded **directly by `matinbook.cls`** (immediately after `mb-core`), NOT by `mb-theme-default`.

`mb-theme-default` only loads `mb-theme-cover`:

```latex
\RequirePackage{mb-theme-cover}
```

> **Why?** Colors must be defined **before** consumer modules (`mb-boxes`, `mb-code`, `mb-layout`, `mb-headings`, `mb-graphics`). The cover is loaded at the end.

### Creating a Custom Theme

1. Create a new directory: `tex/themes/mytheme/`
2. Create the following files:
   - `mb-theme-colors.sty` — Define your CMYK color palette
   - `mb-theme-cover.sty` — Design your cover
   - `mb-theme-default.sty` — Load theme components
3. In `matinbook.cls`, change:
   ```latex
   \RequirePackage{mb-theme-default}
   ```
   to:
   ```latex
   \RequirePackage{tex/themes/mytheme/mb-theme-default}
   ```
4. Make sure `mb-theme-colors` in `matinbook.cls` points to your new colors.

### Theme Components

**`mb-theme-colors.sty`:**
- Defines 20 CMYK colors via `\providecolor`
- `matinblue` is the dominant color

**`mb-theme-cover.sty`:**
- Defines `\makecover` (4 args)
- Defines `\makebackcover` (1 arg)
- Full-color front cover with math/code symbols
- Fantasy math band on the back cover
- Compact concept tree (7 nodes, A–G)

**`mb-theme-default.sty`:**
- Loads `mb-theme-cover`

---

## 18. Localization

### Persian Locale (`fa-IR.sty`)

All document element names are translated to Persian:

| LaTeX Name | Persian Translation |
|------------|---------------------|
| `\contentsname` | فهرست مطالب |
| `\listfigurename` | فهرست تصاویر |
| `\listtablename` | فهرست جداول |
| `\listalgorithmname` | فهرست الگوریتم‌ها |
| `\bibname` | منابع و مراجع |
| `\indexname` | نمایه |
| `\chaptername` | فصل |
| `\appendixname` | پیوست |
| `\proofname` | اثبات |
| `\abstractname` | چکیده |
| `\figurename` | شکل |
| `\tablename` | جدول |
| `\seename` | نگاه کنید به |
| `\alsoname` | همچنین نگاه کنید به |
| `\partname` | بخش |
| `\refname` | منابع |

### Cleveref Names (Persian)

| Counter | Singular | Plural |
|---------|----------|--------|
| equation | معادله | معادلات |
| chapter | فصل | فصول |
| section | بخش | بخش‌ها |
| subsection | زیربخش | زیربخش‌ها |
| figure | شکل | اشکال |
| table | جدول | جداول |
| algorithm | الگوریتم | الگوریتم‌ها |
| theorem | قضیه | قضایا |
| lemma | لم | لم‌ها |
| corollary | نتیجه | نتایج |
| definition | تعریف | تعاریف |
| example | مثال | مثال‌ها |
| remark | نکته | نکات |
| exercise | تمرین | تمرین‌ها |
| proposition | گزاره | گزاره‌ها |

### Theorem Names (Persian)

| Command | Persian |
|---------|---------|
| `\theoremname` | قضیه |
| `\lemmaname` | لم |
| `\corollaryname` | نتیجه |
| `\propositionname` | گزاره |
| `\definitionname` | تعریف |
| `\examplename` | مثال |
| `\remarkname` | نکته |
| `\exercisename` | تمرین |
| `\solutionname` | راه حل |
| `\codename` | کد |
| `\algorithmname` | الگوریتم |

### Cover Names (Persian)

| Command | Persian |
|---------|---------|
| `\coverpublisher` | ناشر |
| `\coveredition` | نسخه |
| `\coverisbn` | شابک |
| `\covertag` | آموزش برنامه‌نویسی و ریاضیات |
| `\coverabout` | درباره این کتاب |
| `\coversource` | مشاهده سورس کد |

### English Locale (`en-US.sty`)

Standard English names for all elements. Mirror structure of `fa-IR.sty`.

### Language Switching

MatinBook v1.1 does **not** currently support runtime language switching. The locale is determined by which file is loaded in `matinbook.cls`:

```latex
% Persian (default):
\RequirePackage{fa-IR}

% English (change to):
\RequirePackage{en-US}
```

### RTL/LTR Behavior

- **Persian text:** Written normally, LaTeX handles RTL via `xepersian`
- **English text (inline):** Wrap in `\lr{...}`
- **English text (block):** Wrap in `\begin{latin}...\end{latin}`
- **Math:** Handled by `xepersian` — Persian digits in Persian mode, Latin digits in LTR mode
- **Margin notes:** Wrap content in `\RL{}` (via `\mnote` macro)

### Number Format

- **Persian text:** Persian digits (۰-۹) automatically
- **English text:** Latin digits (0-9)
- **Math:** Follows context (Persian mode → Persian digits; `\lr{}` → Latin digits)

### Date Format

Use Persian calendar dates in Persian text:

```latex
\date{مهر ۱۴۰۵}
```

For `\today` in Persian mode, `xepersian` provides `\today` as a Persian date.

---

**End of Part II**

---

# Part III: Academic Writing Standards

These rules are inspired by the style guides of MIT Press, Springer, Oxford University Press, and the Chicago Manual of Style.

---

## 19. Professional Writing Rules

### Rule 1: One Idea Per Paragraph

Each paragraph should develop **one** main idea. If you find yourself switching topics mid-paragraph, start a new paragraph.

**Guideline:** 3-7 sentences per paragraph for technical content.

### Rule 2: Topic Sentence First

The first sentence of each paragraph should state the main idea. Subsequent sentences provide support, examples, or elaboration.

```latex
% GOOD:
الگوریتم دایکسترا یک الگوریتم حریصانه برای یافتن کوتاه‌ترین مسیر است.
این الگوریتم در هر گام، نزدیک‌ترین راس برش‌ندیده را انتخاب می‌کند.
پیچیدگی زمانی آن با هیپ دودویی \lr{$O((V+E)\log V)$} است.

% BAD:
این الگوریتم در هر گام نزدیک‌ترین راس را انتخاب می‌کند.
پیچیدگی آن \lr{$O((V+E)\log V)$} است.
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
    گراف \lr{$G = (V, E)$} مجموعه‌ای از رئوس \lr{$V$}
    و یال‌های \lr{$E$} است.
    \label{def:graph}
\end{definition}

طبق \cref{def:graph}، ...

% BAD:
گراف \lr{$G = (V, E)$} را در نظر بگیرید.  % گراف تعریف نشده!
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

MatinBook handles this automatically via:

```latex
\widowpenalty=10000
\clubpenalty=10000
```

But be aware: if you force line breaks (`\\`), you may create them.

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

Emoji are acceptable in code comments, but NEVER in formal book text.

```latex
% GOOD (formal):
این الگوریتم به درستی کار می‌کند.

% BAD (informal):
این الگوریتم به درستی کار می‌کند 🎉
```

### Rule 11: Use `\lr{}` for All Latin Content

Every English word, phrase, or technical term within Persian text must use `\lr{}`:

```latex
% GOOD:
این کتاب درباره \lr{machine learning} و \lr{deep neural networks} است.

% BAD:
این کتاب درباره machine learning و deep neural networks است.
```

### Rule 12: Reference Equations Properly

When referencing an equation, use `\cref{}`:

```latex
% GOOD:
طبق \cref{eq:einstein}، انرژی با جرم رابطه دارد.

% BAD:
طبق معادله \ref{eq:einstein}، انرژی با جرم رابطه دارد.
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
| Chapter title | 20pt | 30pt |
| Section title | 20pt | 10pt |
| Subsection title | 15pt | 8pt |
| Subsubsection title | 12pt | 6pt |
| Paragraph | 0pt | 0pt |
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

### Visual Weight Distribution

| Element | Visual Weight | Notes |
|---------|---------------|-------|
| Chapter title | Heavy | Large font, colored |
| Section title | Medium | 15pt bold |
| Subsection title | Light | 13pt bold |
| Body text | Normal | 10pt |
| Boxed content | Medium | Colored background |
| Figure/Table | Heavy | Visual anchor |

---

## 21. Content Density Guidelines

### Optimal Reading Speed

| Language | Words per Minute | Words per Page |
|----------|------------------|----------------|
| Persian | 180-220 | 300-400 |
| English | 200-250 | 350-450 |

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

### Page Density Targets

| Page Type | Text | Visual | Whitespace |
|-----------|------|--------|------------|
| Body page | 70-75% | 5-10% | 15-25% |
| Box page | 60-65% | 15-20% | 15-20% |
| Figure page | 50-60% | 25-30% | 10-15% |
| Chapter opening | 30-40% | 10-20% | 40-60% |

---

## 22. Mathematical Writing Standards

### Equation Punctuation

Equations are part of sentences. Punctuate them accordingly:

```latex
% CORRECT:
اگر \lr{$a = b$}، آنگاه:
\[
    a^{2} = b^{2}.
\]
بنابراین ...

% WRONG:
اگر \lr{$a = b$}، آنگاه:
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
| Scalar | lowercase italic | \lr{$x$, $y$, $n$} |
| Vector | lowercase bold | \lr{$\mathbf{v}$, $\vec{v}$} |
| Matrix | uppercase italic | \lr{$A$, $B$, $M$} |
| Set | uppercase blackboard | \lr{$\mathbb{R}$, $\mathbb{N}$} |
| Function | lowercase italic | \lr{$f$, $g$, $h$} |
| Constant | uppercase or Greek | \lr{$C$, $\pi$, $e$} |

### Theorems and Proofs

Every theorem should have a proof (unless it's a well-known result).

```latex
\begin{theorem}[قضیه اصلی]
    هر عدد طبیعی بزرگتر از ۱ به عوامل اول تجزیه می‌شود.
    \label{thm:fundamental}
\end{theorem}

\begin{proof}
    با استقرای قوی روی \lr{$n$} اثبات می‌کنیم.
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

### Math in Persian Text

Always wrap inline math with Latin content in `\lr{}`:

```latex
% GOOD:
پیچیدگی این الگوریتم \lr{$O(n \log n)$} است.

% BAD:
پیچیدگی این الگوریتم $O(n \log n)$ است.
```

### No Math in Section Titles

```latex
% GOOD:
\section{تحلیل پیچیدگی O بزرگ}

% BAD:
\section{تحلیل پیچیدگی $O$ بزرگ}
```

### Display Math Spacing

```latex
% Around display equations:
\[
    E = mc^{2}
\]
```
No blank lines before/after (LaTeX handles spacing automatically).

---

## 23. Algorithm Presentation Standards

### Algorithm Structure

Every algorithm should have:

1. **Input specification** (`\Require`)
2. **Output specification** (`\Ensure`)
3. **Clear variable names** (in English)
4. **Comments for non-trivial steps**
5. **Persian caption** (via `\caption{}`)

### Line Numbering

Use `\begin{algorithmic}[1]` for line numbers (recommended for algorithms with references).

### Algorithm Length

- **Ideal:** 5-15 lines
- **Maximum:** 25 lines
- **If longer:** Split into sub-algorithms

### Variable Naming in Algorithms

| Type | Convention | Example |
|------|------------|---------|
| Input | Descriptive | \lr{$A$, $target$, $n$} |
| Loop counter | \lr{$i$, $j$, $k$} | `\For{$i \gets 1$}` |
| Temporary | \lr{$temp$, $tmp$} | `\State $temp \gets A[i]$` |
| Result | \lr{$result$, $ans$} | `\State \Return $result$` |

### Algorithm Caption

In v1.1, use the standard `\caption{}` **inside** the `algorithm` environment:

```latex
\begin{latin}
\begin{algorithm}
\caption{جستجوی دودویی}
\label{alg:binary}
\begin{algorithmic}[1]
    ...
\end{algorithmic}
\end{algorithm}
\end{latin}
```

> **Note:** `xepersian` automatically translates the algorithm name to «الگوریتم».

### Example Algorithm

```latex
\begin{latin}
\begin{algorithm}
\caption{جستجوی دودویی}
\label{alg:binary-search}
\begin{algorithmic}[1]
    \Require Sorted array $A[1..n]$ of integers
    \Require Target value $x$
    \Ensure Index of $x$ in $A$, or $-1$ if not found
    \State $left \gets 1$
    \State $right \gets n$
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
```

### Referencing Algorithms

```latex
الگوریتم \cref{alg:binary-search} فرآیند جستجو را نشان می‌دهد.
```

---

## 24. Code Presentation Standards

### Code Length

- **Ideal:** 10-30 lines
- **Maximum:** 50 lines
- **If longer:** Split into multiple listings or reference a file

### Code Comments

- **All comments in English** (never Persian, except via `|\pc{...}|`)
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

همانطور که در \cref{code:factorial} می‌بینیم،
شرط پایه \lr{$n \leq 1$} است.
```

### Code Line Length

- **Maximum:** 80 characters per line
- **If longer:** Use `breaklines=true` (MatinBook default)
- **Avoid breaking:** identifiers, strings, URLs

### Code Block Density

- **Maximum:** 1-2 code blocks per page
- **Minimum:** 1 code block per 10 pages
- **Ideal:** 1 code block per 4-5 pages

### Code Caption

Every code block should have a caption and label:

```latex
\codecaption{توضیح کد}
\label{code:my-code}
```

### Inline Code

Use `\inlcode{}` for short code references:

```latex
تابع \inlcode{factorial()} یک تابع بازگشتی است.
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
\caption{نمودار تابع \lr{$f(x) = x^{2}$} برای \lr{$x \in [-2, 2]$}}
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
Binary Search & جستجو در آرایه مرتب & \lr{$O(\log n)$} \\
Merge Sort & مرتب‌سازی پایدار & \lr{$O(n \log n)$} \\
Quicksort & مرتب‌سازی سریع & \lr{$O(n \log n)$} \\
\bottomrule
\end{tabular}
\end{table}
```

### Figure/Table Density

- **Maximum:** 1 figure/table per 2 pages
- **Minimum:** 1 figure/table per 10 pages
- **Ideal:** 1 figure/table per 4-5 pages

### Figure/Table Naming

- **Labels:** Use `fig:` and `tab:` prefixes
- **References:** Use `\cref{}`
- **Captions:** Persian for Persian books, English for English books

### Figure/Table Placement Rules

| Placement | Use When |
|-----------|----------|
| `[h]` | Small figure, fits near text |
| `[t]` | Large figure, at top of next page |
| `[b]` | Large figure, at bottom |
| `[p]` | Full-page figure |
| `[H]` | Must be exactly here (use rarely) |

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

### Persian Bibliography Entries

For Persian sources, use the `langid` field:

```bibtex
@book{persian-book,
    author    = {نام نویسنده},
    title     = {عنوان کتاب},
    year      = {۱۴۰۴},
    publisher = {نام ناشر},
    langid    = {persian}
}
```

### Citation Rules

1. **Cite primary sources** when possible
2. **Avoid citing Wikipedia** (use it to find primary sources)
3. **Consistent formatting** — use `biblatex`'s automatic formatting
4. **Include DOIs** for journal articles when available
5. **Include URLs and access dates** for online sources
6. **Group citations** when referring to multiple sources: `\cite{ref1,ref2,ref3}`

### Reference Section Title

In Persian books: `منابع و مراجع`

```latex
\printbibliography[title={منابع و مراجع}]
```

> **CRITICAL:** Do **NOT** wrap `\printbibliography` in `\begin{latin}...\end{latin}`.

---

**End of Part III**

---

# Part IV: Implementation

## 27. Content Generation Rules

These rules are **mandatory** for AI-generated content.

### RULE 1: Persian Text is Natural

Persian body text is written normally without any special commands.

### RULE 2: Latin Text in Persian

Any English word, phrase, or technical term within Persian text must use `\lr{}`:

```latex
% CORRECT:
این کتاب درباره \lr{machine learning} است.

% WRONG:
این کتاب درباره machine learning است.
```

### RULE 3: Latin Blocks

Large blocks of English text, code, algorithms, and TikZ diagrams must be wrapped in `\begin{latin}...\end{latin}`.

### RULE 4: Code Comments in English

ALL comments inside `minted` code blocks MUST be in English (unless using `|\pc{...}|`).

### RULE 5: Persian Comments in Code via `\pc{}`

```latex
\begin{latin}
\begin{minted}{python}
x = 5  # |\pc{مقدار متغیر}|
\end{minted}
\end{latin}
```

### RULE 6: Algorithm Captions Inside the Environment

```latex
\begin{latin}
\begin{algorithm}
\caption{جستجوی دودویی}
\label{alg:binary}
\begin{algorithmic}[1]
    ...
\end{algorithmic}
\end{algorithm}
\end{latin}
```

### RULE 7: Labels Inside Environments

`\label` commands belong INSIDE the environment they reference.

### RULE 8: No Math in Section Titles

Do NOT use math mode (`$...$`) in section titles.

### RULE 9: Use `\lr{}` for Technical Terms

All technical terms in English should use `\lr{}`.

### RULE 10: Tables with Persian Text

Use `C{width}` column type for Persian text columns.

### RULE 11: Book Structure

Always follow this structure for a complete book:

```latex
\begin{document}

% 1. FRONT COVER
\makecover{Title}{Subtitle}{Author}{Date}

% 2. FRONT MATTER (no wide margin)
\frontmatter
\frontmattergeometry

% 3. Title page
\maketitle

% 4. Copyright page
\thispagestyle{empty}
...
\clearpage

% 5. Dedication (optional)
...

% 6. Preface
\chapter*{پیشگفتار}
...

% 7. Table of Contents
\tableofcontents
\clearpage

% 8. Lists
\listoffigures
\clearpage
\listoftables
\clearpage

% 9. MAIN MATTER (wide margin for notes)
\mainmatter
\mainmattergeometry

% 10. Chapters
\chapter{...}
...

% 11. Appendices (optional)
\appendix
\chapter{...}

% 12. BACK MATTER (no wide margin)
\backmatter
\frontmattergeometry

% 13. Bibliography
\printbibliography[title={منابع و مراجع}]

% 14. Index
\printindex

% 15. BACK COVER (must be at the very end)
\makebackcover{...}

\end{document}
```

### RULE 12: Use `\frontmatter`, `\mainmatter`, `\backmatter`

These commands change the page numbering AND geometry (with `\frontmattergeometry` / `\mainmattergeometry`).

### RULE 13: Bibliography Without `latin` Wrapper

```latex
% CORRECT:
\printbibliography[title={منابع و مراجع}]
```

### RULE 14: Use `\cref{}` for All References

```latex
% CORRECT:
طبق \cref{thm:fundamental}، ...

% ALSO CORRECT:
طبق \thmref{thm:fundamental}، ...
```

### RULE 15: Two Compilation Passes for Cover

The cover requires at least **2 compilation passes**.

### RULE 16: Index Requires Xindy

MatinBook v1.1 uses **xindy** (not `makeindex`) for correct Persian sorting.

### RULE 17: Use CMYK Colors

All MatinBook colors are defined in **CMYK**.

### RULE 18: Code Blocks Inside `latin` Environment

All `minted` code blocks MUST be inside `\begin{latin}...\end{latin}`.

### RULE 19: TikZ Diagrams Inside `latin` Environment

All TikZ diagrams (except the cover) MUST be inside `\begin{latin}...\end{latin}`.

### RULE 20: Persian Text in TikZ Nodes Requires `\rl{}`

```latex
% CORRECT:
\node {\rl{متن فارسی}};
```

### RULE 21: Use `\frontmattergeometry` After `\frontmatter`

```latex
\frontmatter
\frontmattergeometry    % ← switch to symmetric margins
```

### RULE 22: Use `\mainmattergeometry` After `\mainmatter`

```latex
\mainmatter
\mainmattergeometry     % ← restore wide margin
```

### RULE 23: Margin Notes (NEW in v1.1)

```latex
\mnote{یادداشت حاشیه}                    % plain margin note
\marginfig{figures/plot.png}{نمودار}     % figure + caption
```

**Limitations:**
- Cannot be used inside `tcolorbox` or `figure`.
- Requires wide outer margin (`mainmattergeometry`).

---

## 28. File Structure Templates

### Template 1: Minimal Book (3-5 chapters)

```latex
\documentclass{matinbook}

\title{عنوان کتاب}
\author{نام نویسنده}
\date{مهر ۱۴۰۵}

\booktitle{عنوان کتاب}

\begin{document}

\makecover
    {عنوان کتاب}
    {زیرعنوان کتاب}
    {نام نویسنده}
    {مهر ۱۴۰۵}

\frontmatter
\frontmattergeometry

\maketitle
\tableofcontents

\chapter*{پیشگفتار}
\addcontentsline{toc}{chapter}{پیشگفتار}
پیشگفتار کتاب...

\mainmatter
\mainmattergeometry

\chapter{فصل اول}
\label{chap:first}
محتوا...

\chapter{فصل دوم}
\label{chap:second}
محتوا...

\makebackcover{توضیحات پشت جلد...}

\end{document}
```

### Template 2: Standard Book (with Bibliography and Index)

```latex
\documentclass{matinbook}

\addbibresource{references.bib}

\title{عنوان کتاب}
\author{نام نویسنده}
\date{مهر ۱۴۰۵}

\booktitle{عنوان کتاب}

\renewcommand{\repository}{github.com/your-username/your-book}

\begin{document}

\makecover
    {عنوان کتاب}
    {زیرعنوان کتاب}
    {نام نویسنده}
    {مهر ۱۴۰۵}

\frontmatter
\frontmattergeometry

\maketitle

% Copyright
\thispagestyle{empty}
\vfill
\begin{center}
    {\large\textbf{حقوق نشر}}
    \vspace{1cm}
    تمامی حقوق این کتاب محفوظ است.
    \vspace{1cm}
    {\small نسخه \matinbookversion\ — \matinbookdate}
\end{center}
\clearpage

% Dedication
\thispagestyle{empty}
\vfill
\begin{flushright}
    {\Large\itshape تقدیم به...}
\end{flushright}
\clearpage

% Preface
\chapter*{پیشگفتار}
\addcontentsline{toc}{chapter}{پیشگفتار}
پیشگفتار کتاب...

\tableofcontents
\clearpage
\listoffigures
\clearpage
\listoftables
\clearpage

\mainmatter
\mainmattergeometry

\chapter{فصل اول}
\label{chap:first}
محتوا...

\chapter{فصل دوم}
\label{chap:second}
محتوا...

\backmatter
\frontmattergeometry

\printbibliography[title={منابع و مراجع}]
\printindex

\makebackcover{توضیحات پشت جلد...}

\end{document}
```

### Template 3: Multi-Part Book (8+ chapters)

```latex
\documentclass{matinbook}

\addbibresource{references.bib}

\title{راهنمای جامع}
\author{نام نویسنده}
\date{مهر ۱۴۰۵}

\booktitle{راهنمای جامع}

\begin{document}

\makecover
    {راهنمای جامع}
    {از مبتدی تا پیشرفته}
    {نام نویسنده}
    {مهر ۱۴۰۵}

\frontmatter
\frontmattergeometry

\maketitle
\tableofcontents
\clearpage
\listoffigures
\clearpage
\listoftables
\clearpage

\mainmatter
\mainmattergeometry

\part{مبانی}
\label{part:fundamentals}

\chapter{مقدمه}
\label{chap:intro}
محتوا...

\chapter{مفاهیم پایه}
\label{chap:basics}
محتوا...

\part{الگوریتم‌ها}
\label{part:algorithms}

\chapter{مرتب‌سازی}
\label{chap:sorting}
محتوا...

\appendix
\chapter{پیوست الف}
\label{app:a}
محتوا...

\backmatter
\frontmattergeometry

\printbibliography[title={منابع و مراجع}]
\printindex

\makebackcover{توضیحات پشت جلد...}

\end{document}
```

### Template 4: Chapter File

```latex
% chapters/chapter-01.tex

\chapter{مقدمه}
\label{chap:intro}

\section{انگیزه}
\label{sec:motivation}

متن مقدمه...

\begin{definition}[الگوریتم]
    تعریف الگوریتم...
    \label{def:algorithm}
\end{definition}

\begin{theorem}[قضیه اصلی]
    متن قضیه...
    \label{thm:main}
\end{theorem}

\begin{proof}
    اثبات...
\end{proof}

\mnote{این یک یادداشت حاشیه‌ای است.}
```

---

## 29. Compilation Instructions

### Minimal Compilation (no bibliography or index)

```bash
xelatex -shell-escape document.tex
xelatex -shell-escape document.tex
```

### Standard Compilation (with bibliography)

```bash
xelatex -shell-escape document.tex
biber document
xelatex -shell-escape document.tex
xelatex -shell-escape document.tex
```

### Full Compilation (with bibliography, index, cover)

```bash
xelatex -shell-escape document.tex
biber document
xelatex -shell-escape document.tex
xelatex -shell-escape document.tex
xelatex -shell-escape document.tex
```

> ⚠️ **CRITICAL:** Always use `-shell-escape` because:
> - `minted` requires it for Pygments
> - `xindy` requires it for index processing

### Using latexmk (Automated)

```bash
latexmk -xelatex -shell-escape document.tex
```

To clean auxiliary files:

```bash
latexmk -c document.tex
```

### Using the Project's `compile.sh` Script

```bash
cd tests/v1.1
./compile.sh                    # Compile all .tex files
./compile.sh stage-cls-01.tex   # Compile specific file
```

### Required Tools

| Tool | Purpose | Verify |
|------|---------|--------|
| `xelatex` | Main engine | `which xelatex` |
| `biber` | Bibliography | `which biber` |
| `xindy` | Index | `which xindy` |
| `texindy` | Index wrapper | `which texindy` |
| `pygmentize` | Code highlighting (minted v2) | `which pygmentize` |
| `latexminted` | Code highlighting (minted v3) | `which latexminted` |

### Troubleshooting Compilation

| Problem | Cause | Solution |
|---------|-------|----------|
| `File matinbook.cls not found` | TEXINPUTS not set | Set `TEXINPUTS` or install in `texmf` |
| `Package minted Error` | Missing `-shell-escape` | Add `-shell-escape` |
| `xindy: command not found` | Xindy not installed | Install xindy |
| `persian-variant2.xdy not found` | Xindy-persian not installed | Install xindy-persian |
| `Font X not found` | Font not installed | Install font + `fc-cache -fv` |
| `remember picture` issues | Only 1 pass | Run 2+ passes |

---

## 30. Common Patterns and Recipes

### Pattern 1: Theorem with Proof

```latex
\begin{theorem}[قضیه اصلی]
    هر عدد طبیعی بزرگ‌تر از ۱ به عوامل اول تجزیه می‌شود.
    \label{thm:fundamental}
\end{theorem}

\begin{proof}
    با استقرای قوی روی \lr{$n$} اثبات می‌کنیم.
    ...
\end{proof}

طبق \cref{thm:fundamental}، ...
```

### Pattern 2: Definition with Example

```latex
\begin{definition}[گراف]
    گراف \lr{$G = (V, E)$} مجموعه‌ای از رئوس \lr{$V$}
    و یال‌های \lr{$E$} است.
    \label{def:graph}
\end{definition}

\begin{example}
    گراف \lr{$K_{4}$} یک گراف کامل با ۴ راس است.
    \label{ex:k4}
\end{example}

طبق \cref{def:graph}، ...
```

### Pattern 3: Exercise with Solution

```latex
\begin{exercise}
    ثابت کنید مجموع دو عدد زوج، زوج است.
    \label{exc:sum-even}
\end{exercise}

\begin{solution}
    فرض کنید \lr{$a = 2m$} و \lr{$b = 2n$}.
    آنگاه \lr{$a + b = 2(m + n)$} که زوج است.
\end{solution}

\cref{exc:sum-even} را حل کنید.
```

### Pattern 4: Code with Reference

```latex
تابع زیر فاکتوریل را محاسبه می‌کند:

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

همانطور که در \cref{code:factorial} می‌بینیم، ...
```

### Pattern 5: Code with Persian Comment

```latex
\begin{latin}
\begin{minted}{python}
x = 5   # |\pc{مقدار متغیر}|
y = 10  # |\pc{مقدار دیگر}|
result = x + y  # |\pc{جمع دو متغیر}|
\end{minted}
\end{latin}
\codecaption{جمع دو متغیر}
\label{code:sum}
```

### Pattern 6: Algorithm with Reference

```latex
\begin{latin}
\begin{algorithm}
\caption{جستجوی دودویی}
\label{alg:binary}
\begin{algorithmic}[1]
    \Require Sorted array $A[1..n]$
    \Require Target value $x$
    \Ensure Index of $x$ in $A$, or $-1$
    \State $left \gets 1$
    \State $right \gets n$
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

الگوریتم \cref{alg:binary} فرآیند جستجو را نشان می‌دهد.
```

### Pattern 7: Figure with TikZ

```latex
\begin{figure}[h]
\centering
\begin{latin}
\begin{tikzpicture}
    \begin{axis}[
        width=12cm,
        height=7cm,
        xlabel={$x$},
        ylabel={$f(x)$},
        title={Function Plot},
        grid=major
    ]
        \addplot[matinblue, thick, domain=-3:3, samples=100] {x^2};
        \addlegendentry{$y = x^2$}
    \end{axis}
\end{tikzpicture}
\end{latin}
\caption{نمودار تابع \lr{$f(x) = x^{2}$}}
\label{fig:parabola}
\end{figure}

نمودار \cref{fig:parabola} تابع درجه دوم را نشان می‌دهد.
```

### Pattern 8: Table with Persian Text

```latex
\begin{table}[h]
\centering
\caption{مقایسه پیچیدگی الگوریتم‌ها}
\label{tab:complexity}
\begin{tabular}{@{}lC{4cm}c@{}}
\toprule
\textbf{Algorithm} & \textbf{Description} & \textbf{Complexity} \\
\midrule
Binary Search & جستجو در آرایه مرتب & \lr{$O(\log n)$} \\
Merge Sort & مرتب‌سازی پایدار & \lr{$O(n \log n)$} \\
Quicksort & مرتب‌سازی سریع & \lr{$O(n \log n)$} \\
\bottomrule
\end{tabular}
\end{table}

جدول \cref{tab:complexity} پیچیدگی الگوریتم‌ها را مقایسه می‌کند.
```

### Pattern 9: Margin Note

```latex
\chapter{فصل اول}

این یک متن اصلی است.
\mnote{این یک یادداشت حاشیه‌ای است.}
و این ادامه‌ی متن اصلی است.

\marginfig{figures/plot.png}{نمودار نمونه}
```

### Pattern 10: Frontmatter/Mainmatter Split

```latex
\frontmatter
\frontmattergeometry          % symmetric margins

\maketitle
\tableofcontents

\mainmatter
\mainmattergeometry           % wide margin for notes

\chapter{...}

\backmatter
\frontmattergeometry          % symmetric margins again
\printbibliography
\printindex
```

---

## 31. Error Prevention Guide

### Error 1: "Extra \middle" when using \given

**Cause:** Using `\given` without `\left` and `\right`.

**Solution:** Use `\setbuilder{cond}{cond}` or `\mid`.

### Error 2: "Extra \fi" in section titles with math

**Cause:** Using `$...$` inside section titles.

**Solution:** Use Unicode characters.

### Error 3: "Dimension too large" with tan(x)

**Cause:** tan(x) has asymptotes.

**Solution:** Add `restrict y to domain`:

```latex
\addplot[thick, restrict y to domain=-5:5] {tan(deg(x))};
```

### Error 4: Algorithmic blocks not closed

**Cause:** Missing `\EndIf`, `\EndFor`, `\EndWhile`, `\EndFunction`.

**Solution:** Ensure every opening block has a matching close.

### Error 5: "Undefined control sequence" with `\pc`

**Cause:** Using `\pc` without `escapeinside=||`.

**Solution:** Ensure `escapeinside=||` is set (MatinBook does this by default).

### Error 6: References showing "??"

**Cause:** Need additional LaTeX compilation passes.

**Solution:** Run XeLaTeX at least 2-3 times.

### Error 7: Empty bibliography

**Cause:** `biber` not run.

**Solution:** Run the full compilation sequence.

### Error 8: Persian text scrambled in TikZ nodes

**Cause:** Missing `\rl{}`.

**Solution:** Wrap Persian text in `\rl{}`.

### Error 9: Code not displaying

**Cause:** Missing `-shell-escape`.

**Solution:** Always use `xelatex -shell-escape`.

### Error 10: Overfull hbox warnings

**Cause:** Long unbreakable text.

**Solution:** Use `\emergencystretch=1em` (already set) or break manually.

### Error 11: Cover missing elements

**Cause:** Only 1 compilation pass.

**Solution:** Run 2+ passes.

### Error 12: Index not sorted correctly

**Cause:** Using `makeindex` instead of `xindy`.

**Solution:** Ensure `mb-index.sty` uses `xindy`.

### Error 13: "Package xepersian Error"

**Cause:** Loading a package after `xepersian`.

**Solution:** `xepersian` MUST be the last package.

### Error 14: "Undefined color: matinblue"

**Cause:** `mb-theme-colors` not loaded before consumer.

**Solution:** Don't change load order.

### Error 15: `\algcaption` undefined

**Cause:** `\algcaption` was removed in v1.1.

**Solution:** Use `\caption{}` inside `algorithm`.

### Error 16: `\thmref` undefined

**Cause:** Actually still defined in v1.1 as helper. If undefined, use `\cref`.

### Error 17: Persian text in `\printbibliography` title scrambled

**Cause:** `\printbibliography` wrapped in `\begin{latin}`.

**Solution:** Do NOT wrap it.

### Error 18: `\endL` or `\endR` problem

**Cause:** Using `\lr{}` inside TikZ nodes with `remember picture, overlay`.

**Solution:** Remove `\lr{}` from TikZ nodes.

### Error 19: B Nazanin glyphs missing

**Cause:** B Nazanin has incomplete glyph coverage.

**Solution:** Use XB Niloofar or Vazirmatn.

### Error 20: Margin note on wrong side

**Cause:** Using `\reversemarginpar` (v1.1 doesn't use it).

**Solution:** Use `\mnote` macro (which handles RTL correctly).

### Error 21: Margin note text LTR on verso pages

**Cause:** Content not wrapped in `\RL{}`.

**Solution:** Use `\mnote` macro (which wraps in `\RL{}`).

### Error 22: `\mnote` inside `tcolorbox` causes error

**Cause:** `\marginpar` cannot be used inside `tcolorbox`.

**Solution:** Place `\mnote` outside the box.

### Error 23: `\frontmattergeometry` causes "paperwidth not available"

**Cause:** `\newgeometry` cannot change `paperwidth` or `paperheight`.

**Solution:** `\frontmattergeometry` omits them (already done in v1.1).

### Error 24: Wide margin shrinks text too much

**Cause:** `outer=5.9cm` reduces text width to ~10.3cm.

**Solution:** Use `\frontmattergeometry` for frontmatter/backmatter, or reduce `marginparwidth`.

---

## 32. Complete Example

Below is a complete, compilable example demonstrating the most common patterns:

```latex
% main.tex — Complete example

\documentclass{matinbook}

\addbibresource{references.bib}

\title{مقدمه‌ای بر الگوریتم‌ها}
\author{نام نویسنده}
\date{مهر ۱۴۰۵}

\booktitle{مقدمه‌ای بر الگوریتم‌ها}

\renewcommand{\repository}{github.com/matinbook/algorithms-book}

\begin{document}

% ========================================
% FRONT COVER
% ========================================
\makecover
    {مقدمه‌ای بر الگوریتم‌ها}
    {راهنمای جامع}
    {نام نویسنده}
    {مهر ۱۴۰۵}

% ========================================
% FRONT MATTER
% ========================================
\frontmatter
\frontmattergeometry

\maketitle

% Copyright
\thispagestyle{empty}
\vfill
\begin{center}
    {\large\textbf{حقوق نشر}}
    \vspace{1cm}
    تمامی حقوق این کتاب محفوظ است.
    \vspace{1cm}
    {\small نسخه \matinbookversion\ — \matinbookdate}
\end{center}
\clearpage

% Preface
\chapter*{پیشگفتار}
\addcontentsline{toc}{chapter}{پیشگفتار}

این کتاب یک مقدمه جامع بر الگوریتم‌ها و ساختار داده‌هاست.
هدف این کتاب، آموزش مفاهیم اساسی به دانشجویان
علوم کامپیوتر است.

\clearpage

% Table of Contents
\tableofcontents
\clearpage

% ========================================
% MAIN MATTER
% ========================================
\mainmatter
\mainmattergeometry

% ========================================
% CHAPTER 1
% ========================================
\chapter{مقدمه}

\section{الگوریتم چیست؟}

\begin{definition}[الگوریتم]
    یک \textbf{الگوریتم}\index{الگوریتم} دنباله‌ای متناهی
    از دستورات خوش‌تعریف برای حل یک مسئله است.
    \label{def:algorithm}
\end{definition}

\begin{example}[جستجوی دودویی]
    جستجوی دودویی\index{جستجوی دودویی} یک عنصر را
    در آرایه مرتب در زمان \lr{$O(\log n)$} پیدا می‌کند.
    \label{ex:binary-search}
\end{example}

\mnote{الگوریتم‌ها پایه‌ی علوم کامپیوتر هستند.}

\section{نماد مجانبی}

\begin{definition}[O بزرگ]
    \lr{$f(n) = O(g(n))$} اگر ثابت‌های \lr{$c > 0$}
    و \lr{$n_{0} \geq 0$} وجود داشته باشند به‌طوری که
    \lr{$0 \leq f(n) \leq c \cdot g(n)$}
    برای همه \lr{$n \geq n_{0}$}.
    \label{def:big-o}
\end{definition}

\begin{theorem}[قضیه اصلی]
    فرض کنید \lr{$T(n) = aT(n/b) + f(n)$}.
    آنگاه رفتار مجانبی \lr{$T(n)$} با مقایسه
    \lr{$f(n)$} با \lr{$n^{\log_{b}a}$} تعیین می‌شود.
    \label{thm:master}
\end{theorem}

\begin{proof}
    اثبات از روش درخت بازگشت استفاده می‌کند
    و سه حالت را بر اساس نرخ رشد \lr{$f(n)$}
    در نظر می‌گیرد.
\end{proof}

\begin{remark}
    قضیه اصلی \cref{thm:master} یکی از
    مفیدترین ابزارها برای تحلیل
    الگوریتم‌های تقسیم و غلبه است.
    \label{rem:master-importance}
\end{remark}

% ========================================
% CHAPTER 2
% ========================================
\chapter{الگوریتم‌های مرتب‌سازی}

\section{مرتب‌سازی سریع}

مرتب‌سازی سریع\index{مرتب‌سازی سریع} یک الگوریتم
تقسیم و غلبه است که توسط \lr{C.A.R. Hoare} ابداع شد.

\begin{latin}
\begin{algorithm}
\caption{مرتب‌سازی سریع}
\label{alg:quicksort}
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

الگوریتم \cref{alg:quicksort} پیچیدگی
\lr{$O(n \log n)$} در حالت میانگین دارد.

\section{پیاده‌سازی}

پیاده‌سازی پایتون در ادامه آمده است:

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
\codecaption{پیاده‌سازی مرتب‌سازی سریع}
\label{code:quicksort}

\section{مقایسه پیچیدگی}

\begin{table}[h]
\centering
\caption{مقایسه الگوریتم‌های مرتب‌سازی}
\label{tab:sorting}
\begin{tabular}{@{}lC{4cm}c@{}}
\toprule
\textbf{Algorithm} & \textbf{Description} & \textbf{Average Case} \\
\midrule
Bubble Sort & مرتب‌سازی حبابی & \lr{$O(n^{2})$} \\
Quicksort & مرتب‌سازی سریع & \lr{$O(n \log n)$} \\
Merge Sort & مرتب‌سازی ادغامی & \lr{$O(n \log n)$} \\
\bottomrule
\end{tabular}
\end{table}

جدول \cref{tab:sorting} مقایسه‌ای بین
الگوریتم‌های مرتب‌سازی ارائه می‌دهد.

% ========================================
% EXERCISES
% ========================================
\section{تمرین‌ها}

\begin{exercise}
    الگوریتم مرتب‌سازی سریع را به زبان \lr{C++}
    پیاده‌سازی کنید و عملکرد آن را با
    مرتب‌سازی ادغامی روی آرایه‌هایی با اندازه
    \lr{$10^{6}$} مقایسه کنید.
    \label{exc:quicksort-cpp}
\end{exercise}

\begin{solution}
    پیاده‌سازی باید از افراز درجا
    برای دستیابی به پیچیدگی فضایی \lr{$O(\log n)$}
    استفاده کند.
\end{solution}

% ========================================
% BACK MATTER
% ========================================
\backmatter
\frontmattergeometry

% Bibliography
\printbibliography[title={منابع و مراجع}]

% Index
\printindex

% ========================================
% BACK COVER
% ========================================
\makebackcover{%
    این کتاب یک مقدمه جامع بر الگوریتم‌ها
    و ساختار داده‌ها است.
    
    \textbf{موضوعات پوشش داده شده:}
    \begin{itemize}
        \item مرتب‌سازی و جستجو
        \item الگوریتم‌های گراف
        \item برنامه‌ریزی پویا
        \item نظریه اعداد
    \end{itemize}
}

\end{document}
```

---

## Summary Checklist for AI Content Generation

### Structural
- [ ] `\documentclass{matinbook}` is used
- [ ] `\addbibresource` is present (if bibliography)
- [ ] `\makecover{...}{...}{...}{...}` has 4 arguments
- [ ] `\frontmatter` + `\frontmattergeometry`
- [ ] `\mainmatter` + `\mainmattergeometry`
- [ ] `\backmatter` + `\frontmattergeometry`
- [ ] `\makebackcover{...}` is at the **very end**
- [ ] `\booktitle{...}` is set

### Bilingual
- [ ] All Latin text uses `\lr{}` or `\begin{latin}...\end{latin}`
- [ ] All code comments are in English (or `|\pc{...}|`)
- [ ] All algorithm environments are inside `\begin{latin}...\end{latin}`
- [ ] All TikZ diagrams (except cover) are inside `\begin{latin}...\end{latin}`
- [ ] Persian text in TikZ nodes is wrapped in `\rl{}`

### Technical
- [ ] All `\label` commands are **inside** their environments
- [ ] No math mode in section titles
- [ ] Tables use `C{width}` for Persian columns
- [ ] All blocks (`\If`/`\For`/`\While`/`\Function`) are closed
- [ ] All colors are in **CMYK**
- [ ] `\printbibliography` is **NOT** wrapped in `latin`
- [ ] `\cref{}` is used for all references
- [ ] `\caption{}` (not `\algcaption`) is used for algorithms
- [ ] `\mnote` is not used inside `tcolorbox` or `figure`

### Compilation
- [ ] `xelatex -shell-escape` is used
- [ ] At least **2 passes** for cover
- [ ] `biber` is run (if bibliography)
- [ ] `xindy` is installed (for index)

---

## Version-Specific Notes

### For MatinBook v1.1

These commands were **removed** in v1.1:

| Removed | Replacement |
|---------|-------------|
| `\algcaption` | `\caption{}` inside `algorithm` |
| `\figref`, `\tabref`, `\meqref` | `\cref{}` |
| `\coderef`, `\algref` | `\cref{}` |
| `\chref`, `\secref` | `\cref{}` |

These helper commands **still exist** in v1.1 (delegating to `\cref`):

| Command | Delegates to |
|---------|--------------|
| `\thmref{label}` | `\cref{label}` |
| `\lemref{label}` | `\cref{label}` |
| `\corref{label}` | `\cref{label}` |
| `\propref{label}` | `\cref{label}` |
| `\defref{label}` | `\cref{label}` |
| `\exref{label}` | `\cref{label}` |
| `\remref{label}` | `\cref{label}` |
| `\excref{label}` | `\cref{label}` |

These modules were **removed** in v1.1:

| Removed | Reason |
|---------|--------|
| `mb-engine.sty` | Merged into `matinbook.cls` |
| `mb-options.sty` | Merged into `matinbook.cls` (via `\DeclareKeys`) |
| `mb-fonts.sty` | Merged into `matinbook.cls` |
| `mb-rtl.sty` | `xepersian` loaded directly in `matinbook.cls` |
| `mb-algorithm.sty` | `xepersian` handles `algorithm` natively |
| `mb-colors.sty` | Empty placeholder |

These **features were added** in v1.1:

| Feature | Command |
|---------|---------|
| Wide outer margin (5.9cm) | `\geometry{outer=5.9cm}` |
| Margin notes | `\mnote{...}` |
| Margin figures | `\marginfig{file}{caption}` |
| Frontmatter geometry | `\frontmattergeometry` |
| Mainmatter geometry | `\mainmattergeometry` |
| Two box families | `matinbox` + `matin-outline` |
| Breakable outline boxes | `underlay first/middle/last` |
| Boyer/Stewart heading scale | 24/20/15/13/11pt |
| Book title for headers | `\booktitle{...}` |
| Theorem rewrite | `\newtcolorbox` + `\matin@thmtitle` |

These **layout settings changed** in v1.1:

| Setting | v1.0 | v1.1 |
|---------|------|------|
| Page size | A4 | **17.8 × 25.4 cm** |
| Outer margin | 2.5 cm | **5.9 cm** (wide) |
| Inner margin | 2.5 cm | **1.5 cm** |
| Line spacing | 1.15 | **1.15** |
| Paragraph indent | 1em | **1em** |
| Heading scale | 36/17/15/14/10 | **24/20/15/13/11** |

---

## Common AI Generation Mistakes to Avoid

### Mistake 1: Using `\ref{}` instead of `\cref{}`

### Mistake 2: Wrapping `\printbibliography` in `latin`

### Mistake 3: Using `\algcaption` (removed in v1.1)

### Mistake 4: Placing `\makebackcover` at the beginning

### Mistake 5: Using `\rl{}` in TikZ nodes

### Mistake 6: Using RGB for custom colors

### Mistake 7: Putting math in section titles

### Mistake 8: Not wrapping code in `latin`

### Mistake 9: Forgetting `-shell-escape`

### Mistake 10: Using `\mnote` inside `tcolorbox`

### Mistake 11: Forgetting `\frontmattergeometry`

### Mistake 12: Forgetting `\mainmattergeometry`

---

## Final Checklist

Before submitting AI-generated content, verify:

### Critical (Must Fix)
- [ ] `\documentclass{matinbook}` is used
- [ ] `\makecover` has 4 arguments
- [ ] `\makebackcover` is at the end
- [ ] All code is inside `\begin{latin}...\end{latin}`
- [ ] All algorithms are inside `\begin{latin}...\end{latin}`
- [ ] All TikZ diagrams are inside `\begin{latin}...\end{latin}`
- [ ] Algorithm uses `\caption{}` (not `\algcaption`)
- [ ] References use `\cref{}` (or helper macros)
- [ ] `\printbibliography` is **not** inside `latin`
- [ ] Compilation uses `-shell-escape`
- [ ] `\frontmattergeometry` after `\frontmatter`
- [ ] `\mainmattergeometry` after `\mainmatter`
- [ ] `\mnote` is not used inside `tcolorbox` or `figure`

### Important (Should Fix)
- [ ] No math in section titles
- [ ] Persian text in TikZ nodes is wrapped in `\rl{}`
- [ ] All labels are inside their environments
- [ ] All blocks (`\If`/`\For`/`\While`) are closed
- [ ] Colors are in CMYK (if custom)
- [ ] Line length ≤ 80 characters in code

### Nice to Have (Could Fix)
- [ ] Paragraphs have one main idea
- [ ] Topic sentences are first
- [ ] Terms are defined before use
- [ ] Visual hierarchy follows 60-30-10
- [ ] No emoji in formal text
- [ ] Parallel structure in lists

---

## References

1. Chicago Manual of Style, 17th Edition. University of Chicago Press, 2017.
2. The MIT Press. *Author Guidelines*. MIT Press, 2023.
3. Springer. *Book Manuscript Guidelines*. Springer Nature, 2023.
4. Oxford University Press. *Style Manual*. OUP, 2014.
5. Tufte, Edward R. *The Visual Display of Quantitative Information*. Graphics Press, 2001.
6. Bringhurst, Robert. *The Elements of Typographic Style*. Hartley & Marks, 2013.
7. Iranian Educational Publishing Standards (ز/۱-۱ to ز/۱-۲۱). Ministry of Education, 1403.
8. `xepersian` Documentation. Vafa Khalighi, 2024.
9. `xepersian-hm` Documentation. Hassan Mesgarha, 2023.
10. `tcolorbox` Manual. Thomas F. Sturm, 2023.
11. `minted` Documentation. Geoffrey Poore, 2024.
12. `cleveref` Documentation. Toby Cubitt, 2018.
13. `biblatex` Manual. Philipp Lehman et al., 2023.
14. `xindy` Manual. Joachim Schrod, 2022.
15. LaTeX Project Team. *LaTeX 2023 News*. ltnews37-40, 2023-2024.

---

## About This Guide

This guide is the definitive reference for generating content with MatinBook v1.1. It is maintained alongside the class itself and updated with each major release.

**Version:** 1.1
**Last Updated:** Mehr 1405 / October 2026
**Maintained by:** MatinBook Project
**License:** MIT (same as MatinBook)

For questions or issues, please open an issue on GitHub:
[github.com/matinbook/matinbook/issues](https://github.com/matinbook/matinbook/issues)

---

**Follow these instructions exactly for correct, compilable, and academically rigorous output.**

**Made with MatinBook — Written with passion for Persian technical writing.**
```
