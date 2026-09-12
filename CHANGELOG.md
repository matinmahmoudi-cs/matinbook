# Changelog

All notable changes to MatinBook will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Additional themes
- More Persian fonts
- Enhanced documentation

## [1.0.0] - 2026-09-12

### Added

#### Core System
- `mb-engine.sty` — XeLaTeX engine detection and validation
- `mb-options.sty` — Class option processing (draft/final, fonts)
- `mb-core.sty` — Central package loader with dependency ordering
- `mb-utils.sty` — Utility macros and version info

#### Localization
- `fa-IR.sty` — Complete Persian locale (structure names, cleveref, theorems)
- `en-US.sty` — English locale for bilingual documents

#### Typography & Layout
- `mb-rtl.sty` — RTL/bidi support via xepersian
- `mb-fonts.sty` — Font system integration
- `mb-typography.sty` — Microtype, line breaking, hyphenation
- `mb-layout.sty` — Page geometry, headers, footers
- `mb-headings.sty` — Chapter/section styles with colored rules

#### Mathematics
- `mb-math.sty` — Custom operators, number sets, smart delimiters, matrix commands
- `mb-theorem.sty` — 10 theorem-like environments with shared counters
- `mb-boxes.sty` — Colored tcolorbox styles for all environments

#### Code & Algorithms
- `mb-code.sty` — Minted integration with syntax highlighting
- `mb-algorithm.sty` — Algorithm environments with Persian captions

#### References & Indexing
- `mb-references.sty` — Hyperref and cleveref configuration
- `mb-index.sty` — Multi-level index with imakeidx
- `mb-colors.sty` — Color definitions (moved to theme)

#### Graphics
- `mb-graphics.sty` — TikZ styles, PGFPlots presets, flowchart templates

#### Theme System
- `tex/themes/default/colors.sty` — 15 colors in 5 families
- `tex/themes/default/fonts.sty` — Persian/Latin/Math/Code fonts
- `tex/themes/default/cover.sty` — Front and back cover design
- `tex/themes/default/theme.sty` — Theme loader

#### Main Class
- `matinbook.cls` — Main class file with modular architecture
- `main.tex` — Template main file

#### Testing
- 15 integration tests covering all modules
- `run-all-tests.sh` — Automated test runner

#### Examples
- `examples/matinbook-documentation.tex` — Complete user guide (12 chapters)
- `examples/advanced-algorithms-book.tex` — Sample technical book (12 chapters + appendices)

#### Documentation
- `README.md` — Project overview and quick start
- `CHANGELOG.md` — This file
- `AI_GUIDE.md` — Guide for AI-assisted development
- `LICENSE` — MIT License
- `references.bib` — Bibliography database

### Notes

- Initial public release
- Requires XeLaTeX (not compatible with pdfLaTeX or LuaLaTeX)
- Uses `biber` for bibliography and `makeindex` for index

[Unreleased]: https://github.com/matinbook/matinbook/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/matinbook/matinbook/releases/tag/v1.0.0