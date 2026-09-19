%%
%% This is file `matinbook.cls',
%% generated with the MatinBook project.
%% 
%% Copyright (C) 2025-2026 MatinBook Project
%% 
%% MatinBook is a professional LaTeX class for Persian technical books
%% in programming and mathematics.
%% 
%% It may be distributed and/or modified under the conditions of
%% the MIT License.
%% 
%% Repository: https://github.com/matinbook/matinbook
%% 

\NeedsTeXFormat{LaTeX2e}[2023/06/01]
\ProvidesClass{matinbook}[2026/01/01 v1.1 MatinBook - Professional Persian Technical Book Class]

%========================================================================
% MATINBOOK CLASS — BOOTSTRAP SEQUENCE
%========================================================================
%
% The loading order below is critical and must not be changed:
%
%   1. Engine detection    — Abort early if not XeLaTeX
%   2. Options system      — Process class options (draft, fonts, ...)
%   3. Base class          — Load `book` (must happen before packages)
%   4. Core packages       — All shared LaTeX packages
%   5. RTL support         — xepersian/bidi (before fonts)
%   6. Feature modules     — Define environments BEFORE locale
%   7. Locale              — Persian captions/strings
%   8. Systems             — References, graphics, index
%   9. Utilities           — Helpers, version info
%  10. Theme               — Colors, fonts, cover
%
%========================================================================


%------------------------------------------------------------------------
% 1. Engine Detection
%------------------------------------------------------------------------
\input{tex/core/mb-engine.sty}


%------------------------------------------------------------------------
% 2. Options System
%------------------------------------------------------------------------
\input{tex/core/mb-options.sty}


%------------------------------------------------------------------------
% 3. Base Class
%------------------------------------------------------------------------
% NOTE: Paper size is currently set to A4 for backward compatibility.
%       The default Persian book format (vaziri: 16.5×23.5 cm) will be
%       configured in `mb-layout.sty` in a future update.
%       See: docs/reports/stage4-market-standards.md
\LoadClass[12pt,a4paper,twoside]{book}


%------------------------------------------------------------------------
% 4. Core Packages
%------------------------------------------------------------------------
\input{tex/core/mb-core.sty}


%------------------------------------------------------------------------
% 5. RTL / Bidi Support
%------------------------------------------------------------------------
\input{tex/modules/typography/mb-rtl.sty}


%------------------------------------------------------------------------
% 6. Feature Modules
%------------------------------------------------------------------------
\input{tex/modules/color/mb-colors.sty}
\input{tex/modules/typography/mb-fonts.sty}
\input{tex/modules/typography/mb-typography.sty}
\input{tex/modules/layout/mb-layout.sty}
\input{tex/modules/layout/mb-headings.sty}
\input{tex/modules/math/mb-math.sty}
\input{tex/modules/boxes/mb-boxes.sty}
\input{tex/modules/theorem/mb-theorem.sty}
\input{tex/modules/code/mb-code.sty}
\input{tex/modules/algorithm/mb-algorithm.sty}


%------------------------------------------------------------------------
% 7. Locale (after environments are defined)
%------------------------------------------------------------------------
\input{tex/locales/fa-IR.sty}


%------------------------------------------------------------------------
% 8. Systems
%------------------------------------------------------------------------
\input{tex/modules/references/mb-references.sty}
\input{tex/modules/graphics/mb-graphics.sty}
\input{tex/modules/index/mb-index.sty}


%------------------------------------------------------------------------
% 9. Utilities
%------------------------------------------------------------------------
\input{tex/core/mb-utils.sty}


%------------------------------------------------------------------------
% 10. Theme
%------------------------------------------------------------------------
\input{tex/themes/default/theme.sty}


%========================================================================
% WELCOME MESSAGE
%========================================================================
\ClassInfo{matinbook}{========================================}
\ClassInfo{matinbook}{MatinBook v\matinbookversion}
\ClassInfo{matinbook}{Professional Persian Technical Book Class}
\ClassInfo{matinbook}{----------------------------------------}
\ClassInfo{matinbook}{Core (4):     engine, options, core, utils}
\ClassInfo{matinbook}{Typography (3): rtl, fonts, typography}
\ClassInfo{matinbook}{Locale (1):   fa-IR}
\ClassInfo{matinbook}{Features (8): colors, layout, headings, math,}
\ClassInfo{matinbook}{              boxes, theorem, code, algorithm}
\ClassInfo{matinbook}{Systems (3):  references, graphics, index}
\ClassInfo{matinbook}{Theme (1):    default}
\ClassInfo{matinbook}{----------------------------------------}
\ClassInfo{matinbook}{Total: 19 modules + Theme system}
\ClassInfo{matinbook}{========================================}


%========================================================================
% END OF CLASS
%========================================================================
\endinput