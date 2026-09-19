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
%   2. Option declarations — Via \DeclareKeys (LaTeX 2023 standard)
%   3. Process options     — Execute declared options
%   4. Base class          — Load `book` with resolved options
%   5. Core packages       — All shared LaTeX packages
%   6. RTL support         — xepersian/bidi (before fonts)
%   7. Feature modules     — Define environments BEFORE locale
%   8. Locale              — Persian captions/strings
%   9. Systems             — References, graphics, index
%  10. Utilities           — Helpers, version info
%  11. Theme               — Colors, fonts, cover
%
%========================================================================


%------------------------------------------------------------------------
% 1. Engine Detection
%------------------------------------------------------------------------
\RequirePackage{iftex}
\RequirePackage{etoolbox}

\ifpdftex
    \ClassError{matinbook}{%
        MatinBook requires XeLaTeX\MessageBreak
        Please use: xelatex yourfile.tex%
    }{%
        pdfTeX cannot process Persian fonts correctly.%
    }
\fi

\RequireXeTeX


%------------------------------------------------------------------------
% 2. Option Declarations (LaTeX 2023 key-value system)
%------------------------------------------------------------------------
%
% Default values (set BEFORE \ProcessKeyOptions so user can override)
%
\def\matin@fontname{XBNiloofar}     % Default font: B Nazanin
\def\matin@mode{final}            % Default mode: final

%
% Option definitions
%
\DeclareKeys{
    % Mode
    draft   .code = \def\matin@mode{draft},
    final   .code = \def\matin@mode{final},
    
    % Font (choice)
    font            .choice:,
    font/bnazanin   .code = \def\matin@fontname{XBNiloofar},
    font/vazirmatn  .code = \def\matin@fontname{Vazirmatn},
    font/sahel      .code = \def\matin@fontname{Sahel},
    font/irlotus    .code = \def\matin@fontname{IRLotus},
    font/niloofar   .code = \def\matin@fontname{XBNiloofar},
    
    % Shorthand font options (for convenience)
    bnazanin        .code = \def\matin@fontname{XBNiloofar},
    vazirmatn       .code = \def\matin@fontname{Vazirmatn},
    sahel           .code = \def\matin@fontname{Sahel},
    irlotus         .code = \def\matin@fontname{IRLotus},
    niloofar        .code = \def\matin@fontname{XBNiloofar},
    
    % Layout (passed to book class)
    twoside .code = \PassOptionsToClass{twoside}{book},
    oneside .code = \PassOptionsToClass{oneside}{book},
}

% Unknown options → pass to book class
\DeclareUnknownKeyHandler{%
    \PassOptionsToClass{\CurrentOption}{book}%
}


%------------------------------------------------------------------------
% 3. Process Options
%------------------------------------------------------------------------
\ProcessKeyOptions

%------------------------------------------------------------------------
% 3.5. Backward Compatibility Flags
%------------------------------------------------------------------------
% Some modules (mb-core, mb-layout) still use \if@matin@draft.
% We define it here based on \matin@mode until they are refactored.
%
\newif\if@matin@draft
\expandafter\ifstrequal\expandafter{\matin@mode}{draft}{%
    \@matin@drafttrue
}{%
    \@matin@draftfalse
}



%------------------------------------------------------------------------
% 4. Load Base Class
%------------------------------------------------------------------------
%
% NOTE: Paper size defaults to A4. The vaziri format (16.5×23.5 cm)
%       will be configured in `mb-layout.sty` in a future update.
%       See: docs/reports/stage4-market-standards.md
%
\LoadClass[12pt,a4paper,twoside]{book}


%------------------------------------------------------------------------
% 5. Core Packages
%------------------------------------------------------------------------
\RequirePackage{mb-core}


%------------------------------------------------------------------------
% 6. RTL / Bidi Support
%------------------------------------------------------------------------
\RequirePackage{mb-rtl}


%------------------------------------------------------------------------
% 7. Feature Modules
%------------------------------------------------------------------------
\RequirePackage{mb-colors}
\RequirePackage{mb-fonts}
\RequirePackage{mb-typography}
\RequirePackage{mb-layout}
\RequirePackage{mb-headings}
\RequirePackage{mb-math}
\RequirePackage{mb-boxes}
\RequirePackage{mb-theorem}
\RequirePackage{mb-code}
\RequirePackage{mb-algorithm}


%------------------------------------------------------------------------
% 8. Locale (after environments are defined)
%------------------------------------------------------------------------
\RequirePackage{fa-IR}


%------------------------------------------------------------------------
% 9. Systems
%------------------------------------------------------------------------
\RequirePackage{mb-references}
\RequirePackage{mb-graphics}
\RequirePackage{mb-index}


%------------------------------------------------------------------------
% 10. Utilities
%------------------------------------------------------------------------
\RequirePackage{mb-utils}


%------------------------------------------------------------------------
% 11. Theme
%------------------------------------------------------------------------
\RequirePackage{mb-theme-default}


%========================================================================
% WELCOME MESSAGE
%========================================================================
\ClassInfo{matinbook}{========================================}
\ClassInfo{matinbook}{MatinBook v\matinbookversion}
\ClassInfo{matinbook}{Professional Persian Technical Book Class}
\ClassInfo{matinbook}{----------------------------------------}
\ClassInfo{matinbook}{Font:    \matin@fontname}
\ClassInfo{matinbook}{Mode:    \matin@mode}
\ClassInfo{matinbook}{----------------------------------------}
\ClassInfo{matinbook}{Core (2):     core, utils}
\ClassInfo{matinbook}{Typography (3): rtl, fonts, typography}
\ClassInfo{matinbook}{Locale (1):   fa-IR}
\ClassInfo{matinbook}{Features (8): colors, layout, headings, math,}
\ClassInfo{matinbook}{              boxes, theorem, code, algorithm}
\ClassInfo{matinbook}{Systems (3):  references, graphics, index}
\ClassInfo{matinbook}{Theme (1):    default}
\ClassInfo{matinbook}{----------------------------------------}
\ClassInfo{matinbook}{Total: 18 modules + Theme system}
\ClassInfo{matinbook}{========================================}


%========================================================================
% END OF CLASS
%========================================================================
\endinput
