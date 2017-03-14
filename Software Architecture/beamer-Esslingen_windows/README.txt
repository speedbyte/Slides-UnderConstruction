%%
%% Copyright (C) Hochschule Esslingen, 2011
%%
%% $Id: README.txt 131 2011-10-16 01:11:22Z uwe $
%%
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.

This directory contains the theme files for the beamer class according to the
corporate design of the Hochschule Esslingen, University of Applied Sciences,
http://www.hs-esslingen.de

The following files are part of the macro package

   README.txt                      This file

   beamercolorthemeEsslingen.sty   colortheme
   beamerfontthemeEsslingen.sty    fonttheme
   beamerouterthemeEsslingen.sty   outertheme

   beamerthemeEsslingen.sty        included via \usetheme{Esslingen}


INSTALLATION

Copy the files
   beamercolorthemeEsslingen.sty
   beamerfontthemeEsslingen.sty
   beamerouterthemeEsslingen.sty
   beamerthemeEsslingen.sty
to a place where LaTeX can find them.

GETTING STARTED

You should first run the files 

  example-beamer.tex
  example-article.tex
  example-handout.tex

through latex or pdflatex and read the usage comments. Those files load the
content of the files

  preamble.tex
  example.tex

