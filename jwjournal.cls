%%
%% Copyright (C) 2023 by Jinwen XU
%% -------------------------------
%%
%% This file may be distributed and/or modified under the conditions of
%% the LaTeX Project Public License, either version 1.3c of this license
%% or (at your option) any later version.  The latest version of this
%% license is in:
%%
%%    http://www.latex-project.org/lppl.txt
%%
\NeedsTeXFormat{LaTeX2e}[2022-06-01]
\ProvidesExplClass
  {jwjournal}
  {2023/01/05a} {}
  {JW's journal class}

\keys_define:nn { jwjournal }
  {
    , scroll      .bool_set:N   = \l__jwjournal_scroll_bool
    , scroll      .initial:n    = { false }
    , color entry .bool_set:N   = \l__jwjournal_color_entry_bool
    , color entry .initial:n    = { false }
    , color~entry .bool_set:N   = \l__jwjournal_color_entry_bool
    , color-entry .bool_set:N   = \l__jwjournal_color_entry_bool
    , unknown     .code:n       = {
                                    \PassOptionsToClass { \CurrentOption } { minimart }
                                    \PassOptionsToClass { \CurrentOption } { einfart }
                                    \PassOptionsToPackage { \CurrentOption } { ProjLib }
                                  }
  }
\ProcessKeyOptions [ jwjournal ]

\sys_if_engine_pdftex:TF
  {
    \PassOptionsToClass { use indent = false } { minimart }
    \LoadClass { minimart }
  }
  {
    \PassOptionsToClass { use indent = false } { einfart }
    \LoadClass { einfart }
  }

\RequirePackage { ProjLib }

\PassOptionsToPackage { many } { tcolorbox }
\RequirePackage { tcolorbox }
\RequirePackage { needspace }

\colorlet { jwjournal-color-1 } { yellow!50!green  }
\colorlet { jwjournal-color-2 } { yellow!70!orange }
\colorlet { jwjournal-color-3 } { cyan!70!blue     }
\colorlet { jwjournal-color-4 } { violet           }
\colorlet { jwjournal-color-5 } { yellow!40!cyan   }
\colorlet { jwjournal-color-6 } { yellow!20!orange }
\colorlet { jwjournal-color-7 } { red!20!orange    }

\NewDocumentCommand \JWJournalEntry { m m }
  {
    \skip_vertical:n { .5 \baselineskip }
    \needspace { 2 \baselineskip }
    \projlib_datetime_calculate_week_according_to_format:n { #1 }
    \colorlet { jwjournal-entry } { jwjournal-color- \int_use:N \l__projlib_datetime_day_of_week_result_int }
    \bool_if:NTF \l__jwjournal_color_entry_bool
      {
        \colorlet { jwjournal-entry-background } { jwjournal-entry!10!paper }
      }
      {
        \colorlet { jwjournal-entry-background } { paper }
      }
    \begin{tcolorbox}[enhanced~jigsaw, breakable, enlarge~left~by=-3.5mm, width=\textwidth+3.5mm, colback=jwjournal-entry-background, boxrule=0pt, top=2pt, bottom=2pt, left=2.5mm, borderline~west={1.5mm}{0mm}{jwjournal-entry!90!main-text}, frame~hidden]
        \sffamily \bfseries
        \bool_if:NT \l__jwjournal_color_entry_bool
          {
            \color {jwjournal-entry!30!main-text}
          }
        \ProjLibDate {#1}
        \enspace
        \tikz [x=.75ex,y=.75ex,line~width=.2ex,line~join=round,baseline=-.3ex] \draw [jwjournal-entry!60!main-text] (0,.5) -- (.5,1) -- (1,.5) -- (.5,0) -- (0,.5) -- cycle;
        \enspace
        \projlib_datetime_display_week_uppercase:n { #1 }
        \tl_if_blank:eF { #2 }
          {
            \enspace
            \tikz [x=.75ex,y=.75ex,line~width=.2ex,line~join=round,baseline=-.3ex] \draw [jwjournal-entry!60!main-text] (0,.5) -- (.5,1) -- (1,.5) -- (.5,0) -- (0,.5) -- cycle;
            \enspace
            #2
          }
    \end{tcolorbox}
    \nopagebreak
  }

\RequirePackage { enumitem }
\setlist [ description ] { font = \normalfont\sffamily, leftmargin = 3em}
\RenewDocumentCommand \descriptionlabel { m }
  {
    \skip_horizontal:n { \labelsep }
    \makebox[\maxof{\width}{2.5em}]{
      \tcbox[enhanced~jigsaw, breakable, oversize,
      on~line, arc = .12em, outer~arc = .1em,
      colframe = jwjournal-entry, colupper=main-text, opacityback = 0,
      boxsep = .1em, boxrule = .125em,
      left = .1em, right = .1em, top = .05em, bottom = .05em] { #1 }
    }
  }
\NewDocumentCommand \JWJournalItem { m }
  {
    \begin{description}
      \item #1
    \end{description}
  }

\tl_new:N \g_jwjournal_content_tl
\NewDocumentEnvironment { jwjournal } { +b }
  {
    \tl_gset:Nn \g_jwjournal_content_tl { #1 }
    \jwjournal_parse_content:N \g_jwjournal_content_tl
    \tl_use:N \g_jwjournal_content_tl
  }
  {}

\seq_new:N \l_jwjournal_tmp_seq
\cs_generate_variant:Nn \regex_split:nnN { nVN }
\cs_new:Nn \jwjournal_parse_content:N
  {
    \regex_split:nVN { \c{par} } #1 \l_jwjournal_tmp_seq
    \tl_set:Nn \g_jwjournal_content_tl {}
    \seq_map_inline:Nn \l_jwjournal_tmp_seq
      {
        \tl_set:Nn \l_tmpa_tl { ❄️ ##1 }
        \regex_match:nVT { ❄️ === (.*) } \l_tmpa_tl
          {
            \tl_gput_right:Nn \g_jwjournal_content_tl
              {
                \end { jwjournal }
                \begin { jwjournal }
              }
            \regex_replace_once:nnN
              { ❄️ === (.*) }
              { ❄️ \1 }
              \l_tmpa_tl
          }
        \regex_match:nVT { ❄️ +++ (.*) } \l_tmpa_tl
          {
            \tl_gput_right:Nn \g_jwjournal_content_tl { \g_jwjournal_enlarge_page_by_one_line_tl }
            \regex_replace_once:nnN
              { ❄️ +++ (.*) }
              { ❄️ \1 }
              \l_tmpa_tl
          }
        \regex_replace_once:nnN
          { ❄️ (\ *)? (\d{4}-\d{1,2}-\d{1,2}) (\ *)? (.*) }
          { \c{JWJournalEntry} {\2} {\4} }
          \l_tmpa_tl
        \regex_replace_once:nnN
          { ❄️ (\ *)? (\d{1,2}-\d{1,2}-\d{4}) (\ *)? (.*) }
          { \c{JWJournalEntry} {\2} {\4} }
          \l_tmpa_tl
        \regex_replace_once:nnN
          { ❄️ (\ *)? (\d{4} \D \d{1,2} \D \d{1,2}) (\ *)? (.*) }
          { \c{JWJournalEntry} {\2} {\4} }
          \l_tmpa_tl
        \regex_replace_once:nnN
          { ❄️ (\ *)? (\d{1,2} \D \d{1,2} \D \d{4}) (\ *)? (.*) }
          { \c{JWJournalEntry} {\2} {\4} }
          \l_tmpa_tl
        \regex_replace_once:nnN
          { ❄️ (\[.*\] .*) }
          { \c{JWJournalItem} {\1} }
          \l_tmpa_tl
        \regex_replace_once:nnN { ❄️ } { } \l_tmpa_tl
        \tl_gput_right:NV \g_jwjournal_content_tl \l_tmpa_tl
        \tl_gput_right:Nn \g_jwjournal_content_tl { \par }
      }
  }

\bool_if:NTF \l__jwjournal_scroll_bool
  {
    \tl_const:Nn \g_jwjournal_enlarge_page_by_one_line_tl {}
    \geometry{
      papersize={7in,\maxdimen},
      top=.75in,bottom=.75in,
      left=.75in,right=.66in,
      marginparsep=.75em,
      marginparwidth=.75in,
      footnotesep=2em plus 2pt minus 2pt,
    }
    \hook_gput_code:nnn { begindocument } { jwjournal }
      {
        \setbox0=\vbox
        \bgroup
        \begin { jwjournal }
      }
    \providecommand{\pdfpageheight}{\pageheight}
    \hook_gput_code:nnn { enddocument } { jwjournal }
      {
        \end { jwjournal }
        \egroup
        \dimen0=\dp0
        \pdfpageheight=\dimexpr\ht0+1.5in\relax
        \ifdim\pdfpageheight<10in
            \pdfpageheight=10in
        \fi
        \unvbox0\kern-\dimen0
      }
  }
  {
    \tl_const:Nn \g_jwjournal_enlarge_page_by_one_line_tl { \enlargethispage*{\baselineskip} }
    \geometry{
      papersize={7in,10in},
      top=.75in,bottom=.75in,
      left=.75in,right=.66in,
      marginparsep=.75em,
      marginparwidth=.75in,
      footnotesep=2em plus 2pt minus 2pt,
    }
    \hook_gput_code:nnn { begindocument } { jwjournal }
      {
        \begin { jwjournal }
      }
    \hook_gput_code:nnn { enddocument } { jwjournal }
      {
        \end { jwjournal }
      }
  }

\pagestyle { empty }

\endinput
%%
%% End of file `jwjournal.cls'.
