%%
%% This is file `matinbook.cls',
%% generated with the MatinBook project.
%% 
%% Copyright (C) 2025-2026 Matin Mahmoudi
%% 
%% MatinBook is a professional LaTeX class for Persian technical books
%% in programming and mathematics.
%% 
%% It may be distributed and/or modified under the conditions of
%% the MIT License.
%% 
%% Repository: https://github.com/matinmahmoudi-cs/matinbook
%% 

\NeedsTeXFormat{LaTeX2e}[2023/06/01]
\ProvidesClass{matinbook}[2026/10/08 v1.1 MatinBook - Professional Persian Technical Book Class]

% Version Information
\def\matinbookversion{1.1}
\def\matinbookdate{2026/10/08}

%========================================================================
% MATINBOOK CLASS — BOOTSTRAP SEQUENCE
%========================================================================
%
% The loading order below is CRITICAL and must not be changed:
%
%   Phase 1 — Base packages (BEFORE xepersian)
%   Phase 2 — xepersian (MUST be the last package)
%   Phase 3 — Persian-specific settings (AFTER xepersian)
%
% Reference:
%   xepersian documentation states: "xepersian should be the last
%   package that you load, because otherwise you are certainly going
%   to overwrite bidi and XePersian package's definitions."
%
%========================================================================


%------------------------------------------------------------------------
% Engine Detection
%------------------------------------------------------------------------
\RequirePackage{iftex}

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
% Options (LaTeX 2023 key-value system)
%------------------------------------------------------------------------
\RequirePackage{etoolbox}

% Default values
\def\matin@fontname{XBNiloofar}
\def\matin@mode{final}
\def\matin@booktitle{کتاب من}

\DeclareKeys{
    % Mode
    draft   .code = \def\matin@mode{draft},
    final   .code = \def\matin@mode{final},

    % Font (choice)
    font            .choice:,
    font/bnazanin   .code = \def\matin@fontname{BNazanin},
    font/vazirmatn  .code = \def\matin@fontname{Vazirmatn},
    font/sahel      .code = \def\matin@fontname{Sahel},
    font/irlotus    .code = \def\matin@fontname{IRLotus},
    font/niloofar   .code = \def\matin@fontname{XBNiloofar},

    % Shorthand font options
    bnazanin        .code = \def\matin@fontname{BNazanin},
    vazirmatn       .code = \def\matin@fontname{Vazirmatn},
    sahel           .code = \def\matin@fontname{Sahel},
    irlotus         .code = \def\matin@fontname{IRLotus},
    niloofar        .code = \def\matin@fontname{XBNiloofar},

    % Layout
    twoside .code = \PassOptionsToClass{twoside}{book},
    oneside .code = \PassOptionsToClass{oneside}{book},
}

\DeclareUnknownKeyHandler{%
    \PassOptionsToClass{\CurrentOption}{book}%
}

\ProcessKeyOptions

% Book title command (used by mb-layout for even-page headers)
\newcommand{\booktitle}[1]{\gdef\matin@booktitle{#1}}

% Backward compatibility flags (used by mb-core, mb-layout)
\newif\if@matin@draft
\expandafter\ifstrequal\expandafter{\matin@mode}{draft}{%
    \@matin@drafttrue
}{%
    \@matin@draftfalse
}


%------------------------------------------------------------------------
% Base Class
%------------------------------------------------------------------------
\LoadClass[10pt,a4paper,twoside]{book}


%========================================================================
% PHASE 1 — BASE PACKAGES (BEFORE xepersian)
%========================================================================

\RequirePackage{mb-core}
\RequirePackage{mb-theme-colors}
\RequirePackage{mb-table}
\RequirePackage{mb-math}
\RequirePackage{mb-boxes}
\RequirePackage{mb-theorem}
\RequirePackage{mb-code}
\RequirePackage{mb-layout}
\RequirePackage{mb-headings}
\RequirePackage{mb-references}
\RequirePackage{mb-graphics}
\RequirePackage{mb-index}
\RequirePackage{mb-utils}
\RequirePackage{mb-theme-cover}


%========================================================================
% PHASE 2 — XEPERSIAN (MUST BE THE LAST PACKAGE)
%========================================================================
\RequirePackage{xepersian}


%========================================================================
% PHASE 3 — PERSIAN-SPECIFIC SETTINGS (AFTER xepersian)
%========================================================================

%------------------------------------------------------------------------
% Font Configuration
%------------------------------------------------------------------------
\defaultfontfeatures{Mapping=tex-text}

% Persian body font (dispatched via \matin@fontname)
\ifdefstring{\matin@fontname}{XBNiloofar}{%
    \settextfont[Script=Arabic,Scale=1.2]{XB Niloofar}%
}{%
\ifdefstring{\matin@fontname}{Vazirmatn}{%
    \settextfont[Script=Arabic,Scale=1.2]{Vazirmatn}%
}{%
\ifdefstring{\matin@fontname}{Sahel}{%
    \settextfont[Script=Arabic,Scale=1.2]{Sahel}%
}{%
\ifdefstring{\matin@fontname}{IRLotus}{%
    \settextfont[Script=Arabic,Scale=1.2]{IR Lotus}%
}{%
\ifdefstring{\matin@fontname}{BNazanin}{%
    \settextfont[Script=Arabic,Scale=1.0]{B Nazanin}%
}{%
    \PackageWarning{matinbook}{Unknown font '\matin@fontname'.\MessageBreak
        Using XB Niloofar as fallback}%
    \settextfont[Script=Arabic,Scale=1.2]{XB Niloofar}%
}}}}}

% Latin font
\IfFontExistsTF{Times New Roman}{%
    \setlatintextfont{Times New Roman}%
}{%
    \setlatintextfont{TeX Gyre Termes}%
    \PackageWarning{matinbook}{Times New Roman not found. Using TeX Gyre Termes}%
}

% Math font
\IfFontExistsTF{XITS Math}{%
    \setmathfont{XITS Math}%
}{%
    \IfFontExistsTF{XITSMath-Regular.otf}{%
        \setmathfont{XITSMath-Regular.otf}%
    }{%
        \IfFontExistsTF{Latin Modern Math}{%
            \setmathfont{Latin Modern Math}%
        }{%
            \PackageWarning{matinbook}{No math font found}%
        }%
    }%
}

% Monospace font
\IfFontExistsTF{DejaVu Sans Mono}{%
    \setmonofont{DejaVu Sans Mono}[Scale=0.9]%
}{%
    \IfFontExistsTF{Courier New}{%
        \setmonofont{Courier New}[Scale=0.9]%
    }{%
        \PackageWarning{matinbook}{No monospace font found}%
    }%
}

% Code font (for minted)
\IfFontExistsTF{JetBrains Mono}{%
    \newfontfamily\codefont{JetBrains Mono}[Scale=0.9,Ligatures=TeX]%
}{%
    \IfFontExistsTF{DejaVu Sans Mono}{%
        \newfontfamily\codefont{DejaVu Sans Mono}[Scale=0.9,Ligatures=TeX]%
    }{%
        \newfontfamily\codefont{Courier New}[Scale=0.9]%
    }%
}

%------------------------------------------------------------------------
% Typography (after xepersian)
%------------------------------------------------------------------------
\RequirePackage{mb-typography}

%------------------------------------------------------------------------
% Locale (after xepersian)
%------------------------------------------------------------------------
\RequirePackage{fa-IR}


%========================================================================
% WELCOME MESSAGE
%========================================================================
\ClassInfo{matinbook}{========================================}
\ClassInfo{matinbook}{MatinBook v\matinbookversion}
\ClassInfo{matinbook}{Professional Persian Technical Book Class}
\ClassInfo{matinbook}{----------------------------------------}
\ClassInfo{matinbook}{Font: \matin@fontname}
\ClassInfo{matinbook}{Mode: \matin@mode}
\ClassInfo{matinbook}{----------------------------------------}
\ClassInfo{matinbook}{Total: 19 modules + Theme system}
\ClassInfo{matinbook}{========================================}

\endinput
