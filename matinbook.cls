%%
%% This is file `matinbook.cls',
%% generated with the MatinBook project.
%% 
%% Copyright (C) 2025 MatinBook Project
%% 
%% MatinBook is a professional LaTeX class for Persian technical books
%% in programming and mathematics.
%% 
%% It may be distributed and/or modified under the conditions of
%% the MIT License.
%% 

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{matinbook}[2025/01/01 v1.0 MatinBook - Professional Persian Technical Book Class]

%----------------------------------------
% Bootstrap: Load Core Modules
%----------------------------------------

% 1. Engine Detection (XeTeX check)
\RequirePackage{tex/core/mb-engine}

% 2. Options System (draft, fonts, ...)
\RequirePackage{tex/core/mb-options}

% 3. Base Class (MUST be in .cls file)
\LoadClass[12pt,a4paper,twoside]{book}

% 4. Core Packages (all required LaTeX packages)
\RequirePackage{tex/core/mb-core}

% 5. RTL/Bidi Support (xepersian + Persian settings)
\RequirePackage{tex/modules/typography/mb-rtl}

% 6. Load Feature Modules (BEFORE locale to define environments)
\RequirePackage{tex/modules/color/mb-colors}
\RequirePackage{tex/modules/typography/mb-fonts}
\RequirePackage{tex/modules/typography/mb-typography}
\RequirePackage{tex/modules/layout/mb-layout}
\RequirePackage{tex/modules/layout/mb-headings}
\RequirePackage{tex/modules/math/mb-math}
\RequirePackage{tex/modules/boxes/mb-boxes}
\RequirePackage{tex/modules/theorem/mb-theorem}
\RequirePackage{tex/modules/code/mb-code}
\RequirePackage{tex/modules/algorithm/mb-algorithm}

% 7. Locale (NOW after theorem environments are defined)
\RequirePackage{tex/locales/fa-IR}

% 8. References System (hyperref, cleveref, biblatex config)
\RequirePackage{tex/modules/references/mb-references}

% 9. Graphics System (TikZ, PGFPlots, styles)
\RequirePackage{tex/modules/graphics/mb-graphics}

% 10. Index System (imakeidx configuration)
\RequirePackage{tex/modules/index/mb-index}

% 11. Utilities (helpers, version info)
\RequirePackage{tex/core/mb-utils}

%----------------------------------------
% Theme System
%----------------------------------------

% Default theme (always loaded)
\RequirePackage{tex/themes/default/theme}

% Uncomment to use minimal theme instead:
% \RequirePackage{tex/themes/minimal/theme}

%----------------------------------------
% Welcome Message
%----------------------------------------
\typeout{========================================}
\typeout{MatinBook v\matinbookversion\space loaded successfully!}
\typeout{Theme: Default (Professional)}
\typeout{Core (4): Engine, Options, Core, Utils}
\typeout{System (4): RTL, Locale, References, Index}
\typeout{Features (9): Colors, Fonts, Typography,}
\typeout{                 Layout, Headings, Math,}
\typeout{                 Boxes, Theorems, Code}
\typeout{Content (3): Algorithms, Graphics, Cover}
\typeout{Total: 20 modules + Theme system}
\typeout{========================================}

%----------------------------------------
% End of Class
%----------------------------------------
\endinput