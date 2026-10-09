# Changelog

All notable changes to the MatinBook project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added

#### Core

- **`mb-utils.sty`:** Added `\pnum{...}` helper for Persian numbers
  that contain a decimal point, a slash, or a thousands separator.
  Wraps the number in `\lr{}` to avoid the bidi/fontspec reversal
  bug (e.g. "1.2" rendering as "2.1"). Defined in
  `\AtBeginDocument` because `\lr` is provided by `xepersian`;
  falls back to plain output with a package warning if `\lr` is
  unavailable.

- **`matinbook.cls`:** Load the new `mb-table` module in Phase 1,
  after `mb-theme-colors` and before `mb-math`.

#### New Module — `mb-table.sty`

- **`tex/modules/table/mb-table.sty`:** New module that centralizes
  all table-related configuration:
  - Loads `tabularray` and its `booktabs` compatibility library.
  - Sets global `tblr` defaults (`colsep=8pt`, `rowsep=4pt`) tuned
    for Persian text at the default font scale.
  - Provides the `matintable` environment, a wrapper around a
    captioned, labelled, centered table float with `\small` text.
  - Keeps legacy p-based column types (`L`, `R`, `C`) for backward
    compatibility with bare `tabular` environments.
  - Provides `\matintablespacing` as a no-op for backward
    compatibility.

#### Back Cover Redesign

- **`mb-theme-cover.sty`:** Complete redesign of the back cover.
  The previous decorative artwork (sine waves, neural network,
  concept DAG, barcode, etc.) has been removed and replaced with a
  static two-block layout:
  - Block 1: "درباره این کتاب" (larger, primary).
  - Block 2: "درباره این نویسنده" (smaller, secondary).
  - Separated by exactly 0.7cm.
  - All content placed inside a fixed-height `minipage`
    (`\dimexpr\paperheight-8.9cm\relax`) to prevent overflow onto
    a second page.
  - Wrapped in `\beginR...\endR` so that the contents are laid out
    RTL. Uses `\raggedright` for Persian paragraphs.

- **`mb-theme-cover.sty`:** Added `\authorbio{...}` API for the
  author biography. If called before `\makebackcover`, a second
  block is rendered on the back cover. If omitted, only the book
  blurb is shown. Backward compatible with the existing
  `\makebackcover{...}` signature.

- **`fa-IR.sty` and `en-US.sty`:** Added `\coverauthorbio`
  ("درباره این نویسنده" / "About the Author").

#### `mb-boxes.sty` — Outline Family Fix

- **`mb-boxes.sty`:** Fixed the `matin-outline` family (used by
  `example`, `proof`, `solution`) so that both horizontal rules
  (under the title and under the content) are rendered correctly
  in every breakage state:
  - `underlay unbroken` draws BOTH rules when the box fits on a
    single page.
  - `underlay first` draws ONLY the top rule on the first
    fragment of a broken box.
  - `underlay last` draws ONLY the bottom rule on the last
    fragment of a broken box.
  - `borderline east` / `borderline west` draws the vertical rule
    on the outer margin, on every fragment.
  - All three rules are now 2pt thick, per project decision.
  - The parity dispatcher was renamed from `\matin@outline@apply`
    to `\matinOutlineApply` (no `@`), to avoid requiring
    `\makeatletter` in the `.sty` file.
  - The previous implementation relied on `overlay last` for the
    bottom rule, which drew it ON TOP of the content, and omitted
    `underlay unbroken`, which silently dropped both rules from
    unbroken boxes.

#### Tests Rewritten

- **`tests/v1/stage01-basic.tex`:** Rewritten in v1.1 style:
  - Full book skeleton (cover, frontmatter, mainmatter,
    backmatter, back cover).
  - Added `\booktitle`, `\repository`, `\authorbio`.
  - Added preface, ToC, LoF, LoT.
  - New chapter documenting the back cover API.
  - Replaced `\meqref` with `\cref` throughout.
  - Added `\mnote` in the Persian font chapter.
  - All Persian decimal numbers wrapped in `\pnum{...}`.

- **`tests/v1/stage02-fonts.tex`:** Rewritten in v1.1 style:
  - Full book skeleton.
  - Reorganized into six chapters (Persian, Latin, Math, Code,
    Multilingual, Summary).
  - Replaced `\meqref` with `\cref`.
  - Added `\mnote`.
  - Font status table rewritten with `tblr` (tabularray):
    `width = \textwidth`, `colspec = {l l X[c] X[c]}`,
    `hlines, vlines`, `colsep = 8pt`, `rowsep = 4pt`.
  - All Persian decimal numbers wrapped in `\pnum{...}`.
  - Removed emoji from the summary and conclusion.

- **`main.tex`:** Added an `\authorbio{...}` example before
  `\makebackcover`.

### Changed

- **`mb-typography.sty`:** Removed the `\newcolumntype{L}`, `R`,
  `C` definitions. They are now centralized in `mb-table.sty` to
  avoid duplicate definitions that would override each other
  depending on load order.

- **`mb-core.sty`:** Removed the `% TODO: move to mb-typography`
  comment in the Tables section. The higher-level table
  configuration now lives in `mb-table`.

- **`matinbook.cls`:** Updated the module count in the welcome
  message from "18 modules" to "19 modules".

### Fixed

- **`mb-boxes.sty`:** Fixed missing horizontal rules in the
  `matin-outline` family (see above).

- **`mb-boxes.sty`:** Fixed pgfkeys error
  `I do not know the key '/tcb/matin@outline'` by defining the
  public outline styles with `/.code` instead of `/.style`.

- **`mb-theme-cover.sty`:** Fixed back cover overflow onto a
  second page. The previous implementation used a `titlepage`
  environment with no fixed height, so long blurbs pushed the
  footer to a second page.

- **`mb-theme-cover.sty`:** Fixed LTR layout in the back cover
  minipage. A `minipage` does not inherit the surrounding RTL
  direction, so the content was rendered left-to-right. Wrapping
  the minipage in `\beginR...\endR` and using `\raggedright`
  (which means "flush right" in RTL) resolves the issue.

- **`stage02-fonts.tex`:** Fixed the font status table that was
  hugging the page margins. Root cause: `tabularx` is
  incompatible with `xepersian` (via `bidi`), producing
  `Package array: Illegal pream-token (\TX@col@width): 'c' used`.
  Switched to `tabularray`, which is RTL-native.

### Known Issues

- **`mb-table`:** The `tabularray` package requires TeX Live 2021
  or later. Users on older distributions should install it via
  `tlmgr install tabularray ninecolors`.

- **`mb-theorem`:** `\theoremstyle{remark}` produces italic title
  for 'نکته'. To be fixed in v1.2.

- **`mb-code`:** `bgcolorpadding` not available in TeX Live 2023's
  `fvextra`.

- **`mb-theme-colors`:** CMYK values are approximate (converted
  from RGB).

- **`mb-layout`:** `\mnote` uses `\marginpar`, which cannot be
  used inside `tcolorbox` or `figure`.

### Planned for v1.2

- **`matinbook.cls`:** Add `\DeclareRelease` for backward
  compatibility with v1.0.
- **`mb-theorem`:** Unify all `\theoremstyle` calls to
  `definition` (fix italic title for 'نکته').
- **`mb-code`:** Migrate to `minted` v3's `bgcolorpadding`
  (requires TeX Live 2024+).
- **`mb-code`:** Replace manual `codecounter` with minted's
  `listing` float.
- **`mb-theme-colors`:** Convert RGB→CMYK with a professional
  color tool for precise values.
- **`main.tex`:** Enable Bismillah page and Latin title page by
  default.
- **`tests/`:** Replace `run-all-tests.sh` with a modern test
  runner.
- **`tests/v1/`:** Rewrite the remaining 13 tests (`stage03` to
  `stage15`) in v1.1 style.
- **`examples/`:** Rewrite `matinbook-documentation.tex` and
  `advanced-algorithms-book.tex` in v1.1 style.

---

## [1.1.0] — 2026-10-08 (مهر ۱۴۰۵)

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
  - All files use `\NeedsTeXFormat{LaTeX2e}[2023/06/01]`
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
  - Reduced `\emergencystretch` from 3em to 1em

- **`mb-layout.sty`:**
  - **Wide outer margin** (5.9cm) with `marginparwidth=3.5cm` and
    `marginparsep=0.6cm`, for margin notes and figures.
  - **`\mnote{...}`** — plain margin note (RTL-aware, no numbering).
  - **`\marginfig{...}{...}`** — figure with caption in the margin.
  - **RTL fix**: standard `\marginpar` with `\RL{}` (from xepersian) to
    force note content into an RTL group. Fixes the LTR-direction issue
    on verso (even) pages.
  - **`\frontmattergeometry`** — switches to symmetric margins (no wide
    margin) for frontmatter (copyright, preface, ToC, ...).
  - **`\mainmattergeometry`** — restores the wide-margin geometry.
  - **`\setstretch{1.15}`** — Boyer/Stewart-style textbook leading.
  - **`headheight=15pt`** — fixes the `fancyhdr` warning.
  - Draft watermark (moved from `mb-core`).

- **`mb-headings.sty`:**
  - **Boyer/Stewart heading scale:**
    - Chapter number: 24pt (was 36pt)
    - Chapter title: 20pt (was `\LARGE` = 17pt)
    - `\section`: 15pt (was 17pt)
    - `\subsection`: 13pt (was 14pt)
    - `\subsubsection`: 11pt (was `\normalsize` = 10pt)
  - **`\chaptermark`**: format "فصل N  نام فصل", no bold, `\small`.
  - **`\sectionmark`**: no bold, `\small`.
  - Restored `\cftdotsep` from 0.5 to 4.5 (LaTeX default).
  - Removed `\renewcommand{\thechapter}` (preserves `\appendix`).

- **`mb-math.sty`:**
  - Wrapped all `\DeclareMathOperator` in `\AtBeginDocument`
  - Changed `\newcommand` to `\providecommand` for `\N, \Z, \Q, \R, \C, \D`
  - Equation numbering: `\theequation` redefined to `(formula-chapter)`
  - Removed duplicate `\thinmuskip`/`\medmuskip`/`\thickmuskip`

- **`mb-boxes.sty`:**
  - **Two-family box system:**
    - **Family 1 — `matinbox`** (Boyer-style): solid colored title bar,
      white body, sharp corners. Used by `theorem`, `lemma`,
      `corollary`, `proposition`, `definition`, `remark`, `exercise`.
    - **Family 2 — `matin-outline`** (RTL outline): right vertical line
      (2pt), horizontal rule under title (1pt), horizontal rule at
      bottom (1pt), no frame on other sides, white body, black bold
      title. Used by `example`, `proof`, `solution`.
  - **Breakable handling**: `underlay first/middle/last` +
    `overlay last` to keep the vertical line on the correct side of
    each broken piece.
  - **`fonttitle=\bfseries\normalsize`** — same size as body text,
    per AMS/Boyer standard.
  - Reduced color count from 5 to 3 (blue, orange, green).

- **`mb-theorem.sty`:**
  - **Complete rewrite using `\newtcolorbox`** (not `amsthm`).
  - Shared counter `matin@thmcounter` (reset per chapter).
  - `\matin@thmtitle` builds the title text without `\ifstrempty`.
  - `\let\proof\relax` + `\let\endproof\relax` before
    `\newtcolorbox{proof}` (fixes "Command \proof already defined").
  - Reference helpers: `\thmref`, `\lemref`, `\corref`, `\propref`,
    `\defref`, `\exref`, `\remref`, `\excref`.
  - `\crefalias` for each environment → shared counter.
  - Per-environment `fontupper`.

- **`mb-code.sty`:**
  - Added `escapeinside=||` for Persian comments
  - Added `\pc{}` command for Persian text inside code
  - Changed `fontsize` from `\small` to `\footnotesize`
  - Changed `frame` from `single` to `lines`
  - Changed `breakanywhere` from `true` to `false`
  - Added `baselinestretch=0.95`
  - Added `style=friendly`
  - Removed `python3=true`

- **`mb-graphics.sty`:**
  - Moved `pgf-pie` from `mb-core`
  - Documented `lstlisting` in TikZ nodes limitation

- **`mb-index.sty`:**
  - Switched from `makeindex` to `xindy` with `persian-variant2`

- **`mb-theme-colors.sty`:**
  - Converted all colors from RGB to CMYK
  - Changed `\definecolor` to `\providecolor`
  - Added `matincream` (off-white background)

- **`mb-theme-cover.sty`:**
  - **Full-color front cover**: dark green background with math symbols
    (`∑ ∫ ∂ π ∞ √ ∇ λ θ ε Σ Ω Δ`), math formulas, programming keywords
    (`def`, `class`, `while`, `return`, `import`, `lambda`), and code
    symbols (`<\ />`, `{ }`, `[ ]`, `=>`, `===`, `!=`).
  - **Back cover fantasy band (0–7cm)**: 3-row layout with
    - Row 1: three parallel sine waves (orange, faded)
    - Row 2: five math formulas (`∫`, `∑`, `∂`, `∇`, `lim`)
    - Row 3: neural network, dotted graph, small formulas,
      code symbols, and large faint symbols
  - **Mini-plot**: aligned with "درباره این کتاب" heading at 7cm,
    width scaled ×0.75, height scaled ×1.5.
  - **Concept tree**: 7 nodes, English labels (A–G), positioned at
    bottom-left.
  - **Barcode strip + ISBN** at the bottom.
  - Mapped all `cover*` colors to `matin*` palette via `\colorlet`.
  - Replaced hardcoded `v1.0.0` with `\matinbookversion`.
  - Replaced hardcoded `github.com/matinbook` with `\matin@repository`.
  - Added `\repository` public alias.

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
  - Added `\frontmattergeometry` after `\frontmatter`
  - Added `\mainmattergeometry` after `\mainmatter`
  - Added `\frontmattergeometry` after `\backmatter`

#### Tests

- **24 integration tests** in `tests/v1.1/`:
  - `compile.sh` — modern test compiler
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
  - **`stage-margin-01.tex`** — 20 margin notes, Latin terms,
    formulas, odd/even page coverage.

### 🔧 Changed

#### `matinbook.cls`

- Reorganized loading into three phases:
  1. **Phase 1 — Base packages (BEFORE xepersian):** `mb-core`, `mb-theme-colors`, `mb-boxes`, `mb-code`, `mb-layout`, `mb-headings`, `mb-math`, `mb-references`, `mb-graphics`, `mb-index`, `mb-utils`, `mb-theme-cover`
  2. **Phase 2 — xepersian (LAST package):** `\RequirePackage{xepersian}`
  3. **Phase 3 — Persian-specific settings (AFTER xepersian):** font configuration, `mb-typography`, `fa-IR`
- `\ProvidesClass{matinbook}[2026/10/08 v1.1]`
- `\NeedsTeXFormat{LaTeX2e}[2023/06/01]`

#### `fa-IR.sty` and `en-US.sty`

- Changed `\renewcommand` to `\providecommand` for names undefined in `book` class
- Added `\crefname` for `subsection`, `exercise`, `proposition`
- Added `\crefrangeformat` for `theorem`
- Added `\crefpairconjunction`, `\crefrangeconjunction`, `\crefmiddleconjunction`, `\creflastconjunction` via `\AtBeginDocument`
- Added plural forms
- Removed `\floatname{algorithm}`

#### `mb-utils.sty`

- Fixed `\matin@ifcmd` to accept 3 arguments
- Added `\makeatletter`/`\makeatother` block
- Pre-initialized `\@latintitle` and `\@latinauthor` with `\providecommand`
- Used `\gdef` for global assignment
- Removed dead code

#### `mb-layout.sty`

- Page geometry: `outer=5.9cm` (was 1.4cm), `marginparwidth=3.5cm`,
  `marginparsep=0.6cm`.
- `\setstretch{1.15}` (was 1.03).
- `headheight=15pt` (was 13pt).
- Margin notes: `\marginpar{\RL{\footnotesize #1}}` (no
  `\reversemarginpar`).

#### `mb-headings.sty`

- Heading scale: 24/20, 15, 13, 11pt (was 36/17, 15, 14, 10pt).
- `\chaptermark`: "فصل N  نام فصل" (was just chapter name).
- `\sectionmark`: no bold.

#### `mb-boxes.sty`

- `fonttitle`: `\bfseries\normalsize` (was `\bfseries\small`).
- Two families: `matinbox` (Boyer) + `matin-outline` (RTL outline).
- `matin-outline` uses `underlay first/middle/last` and
  `overlay last` instead of `borderline east`.

#### `mb-theorem.sty`

- Complete rewrite: `\newtcolorbox` instead of `\newtheorem` +
  `\tcolorboxenvironment`.
- `example`, `proof`, `solution` use `matin-outline` styles.
- `\let\proof\relax` + `\let\endproof\relax` before
  `\newtcolorbox{proof}`.

#### `mb-theme-cover.sty`

- Complete redesign: full-color front, fantasy math band on the back,
  compact concept tree with English labels.

#### `main.tex`

- Added `\frontmattergeometry` and `\mainmattergeometry`.

### 🐛 Fixed

- **`matinbook.cls`:** Removed stray `\n` character introduced by earlier `sed`
- **`mb-core.sty`:** Fixed `mathtools`/`amsmath` order
- **`mb-core.sty`:** Removed `amssymb` (unicode-math replaces it)
- **`mb-core.sty`:** Added explicit `\tcbuselibrary{minted}`
- **`mb-core.sty`:** Added `colortbl` (via `xcolor[table]`) for `\rowcolor`
- **`mb-boxes.sty`:** Fixed `\newcolumntype{L,R,C}` to accept width argument
- **`mb-boxes.sty`:** Fixed `underlay first` double-definition (merged
  two `\draw` commands into one `underlay first`).
- **`mb-theorem.sty`:** Fixed `Command \proof already defined` error
  (via `\let\proof\relax`).
- **`mb-theorem.sty`:** Fixed `Incomplete \ifx` error (removed
  `\ifstrempty` from `tcolorbox` title).
- **`mb-theorem.sty`:** Fixed `\crefname` to use environment names
- **`mb-theorem.sty`:** Fixed `\qedsymbol` preservation in proof environment
- **`fa-IR.sty`:** Fixed `\renewcommand{\abstractname}` → `\providecommand`
- **`fa-IR.sty`:** Fixed `\creflastconjunction` undefined error
- **`mb-layout.sty`:** Fixed margin note direction on verso pages
  (via `\RL{}`).
- **`mb-layout.sty`:** Fixed `fancyhdr` headheight warning
  (`headheight=15pt`).
- **`mb-layout.sty`:** Fixed `geometry: paperwidth not available in
  \newgeometry` (removed `paperwidth`/`paperheight` from
  `\frontmattergeometry`).
- **`mb-theme-cover.sty`:** Fixed TikZ `font=` syntax
- **`mb-theme-cover.sty`:** Fixed `\lr{}` in `tikzpicture`
- **`mb-theme-cover.sty`:** Fixed `\matin@repository` not accessible from tests
- **`mb-theme-cover.sty`:** Fixed Persian text not rendering in cover
  (was using `\sffamily`/`\rmfamily` which are Latin-only fonts;
  switched to default Persian font via `\fontsize...\selectfont`).
- **`main.tex`:** Fixed document order per Iranian publishing standards

### ⚠️ Known Issues

- **`mb-theorem`:** `\theoremstyle{remark}` produces italic title for 'نکته'. To be fixed in v1.2.
- **`mb-code`:** `bgcolorpadding` not available in TeX Live 2023's `fvextra`.
- **`mb-theme-colors`:** CMYK values are approximate (converted from RGB).
- **`mb-theme-cover`:** Cover still uses many decorative elements.
- **`mb-layout`:** `\mnote` uses `\marginpar`, which cannot be used inside `tcolorbox` or `figure`.
- **`mb-theme-cover`:** The fantasy band on the back cover may still show minor overlaps depending on TeX Live version.

### 📚 Documentation

- **`README.md`:** Complete rewrite
- **`CHANGELOG.md`:** Initial release (this file)
- **`AI_GUIDE.md`:** (pending update)

### 🔍 Review Reports

This release is based on 25 review reports covering LaTeX 2023 standards,
official documentation, open-source comparisons, and Iranian publishing
standards.

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

- **Repository:** [github.com/matinmahmoudi-cs/matinbook](https://github.com/matinmahmoudi-cs/matinbook)
- **Issues:** [github.com/matinmahmoudi-cs/matinbook/issues](https://github.com/matinmahmoudi-cs/matinbook/issues)
- **CTAN:** (planned)

---

**Made with MatinBook — Written with passion for Persian technical writing.**