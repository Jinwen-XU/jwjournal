%%
%% Copyright (C) 2023-2024 by Jinwen XU
%% ------------------------------------
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
  {2024/09/01} {}
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
    % \PassOptionsToClass { use indent = false } { minimart }
    \LoadClass { minimart }
  }
  {
    % \PassOptionsToClass { use indent = false } { einfart }
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

\colorlet { jwjournal-entry } { . }
\colorlet { jwjournal-sep-line } { .!27!paper }

\NewDocumentCommand \JWJournalSeperator { O{jwjournal-entry!60!main-text} }
  {
    \enspace
    \tikz [x=.75ex,y=.75ex,line~width=.2ex,line~join=round,baseline=-.3ex]
      \draw [#1] (0,.5) -- (.5,1) -- (1,.5) -- (.5,0) -- (0,.5) -- cycle;
    \enspace
  }

\NewDocumentCommand \JWJournalSepLine { O{.75pt} }
  {
    \vspace*{-.5\baselineskip}
    \noindent
    \hspace*{-\paperwidth}
    \makebox[\linewidth]{\color{jwjournal-sep-line}\rule{4\paperwidth}{#1}}
  }

\NewDocumentCommand \JWJournalEntry { m m }
  {
    \phantomsection
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
    \addcontentsline { toc } { section } { #1 }
    \begin{tcolorbox}[enhanced~jigsaw,
      enlarge~left~by=-3.5mm, width=\textwidth+3.5mm,
      colback=jwjournal-entry-background,
      boxrule=0pt,
      top=
        \bool_if:NTF \l__jwjournal_color_entry_bool
          { 2pt }
          { 0pt },
      bottom=
        \bool_if:NTF \l__jwjournal_color_entry_bool
          { 2pt }
          { 0pt },
      left=2.5mm,
      right=
        \bool_if:NTF \l__jwjournal_color_entry_bool
          { 2mm }
          { -1mm },
      borderline~west={1.5mm}{0mm}{jwjournal-entry!90!main-text}, frame~hidden]
        \sffamily \bfseries
        \bool_if:NT \l__jwjournal_color_entry_bool
          {
            \color {jwjournal-entry!30!main-text}
          }
        \ProjLibDate { #1 }
        \JWJournalSeperator{}
        \projlib_datetime_display_week_uppercase:n { #1 }
        \tl_if_blank:eF { #2 }
          {
            \JWJournalSeperator{}
            #2
          }
    \end{tcolorbox}
    \nopagebreak
  }

\RequirePackage { enumitem }
\setlist [ description ] { font = \normalfont\sffamily, leftmargin = 3em, topsep = 0pt, labelsep = 1em }
\newlist { jwjournal-continued-text } { itemize } { 1 }
\setlist [ jwjournal-continued-text ] { leftmargin = 3em, topsep = 0pt, label = {} }
\dim_new:N \l_jwjournal_labelsep_dim
\dim_set:Nn \l_jwjournal_labelsep_dim { \labelsep }
\setlist [ 2 ] { labelsep = \l_jwjournal_labelsep_dim, labelwidth = !}
\RenewDocumentCommand \descriptionlabel { m }
  {
    \makebox[\maxof{\width}{2em}][l]{
      \tcbox[enhanced~jigsaw, breakable, oversize,
      on~line, arc = .12em, outer~arc = .1em,
      colframe = jwjournal-entry, colupper=main-text, opacityback = 0,
      boxsep = .1em, boxrule = .125em,
      left = .1em, right = .1em, top = .05em, bottom = .05em] { #1 }
    }
  }
\NewDocumentCommand \JWJournalItem { m m }
  {
    \begin{description}
      \item[#1] #2
    \end{description}
  }
\NewDocumentCommand \JWJournalContinue { m }
  {
    \begin{jwjournal-continued-text}
      \item #1
    \end{jwjournal-continued-text}
  }

\NewDocumentCommand \JWJournalNote { m }
  {
    \bool_if:NTF \l__jwjournal_color_entry_bool
      {
        \colorlet { jwjournal-note-background } { jwjournal-entry!3!paper }
      }
      {
        \colorlet { jwjournal-note-background } { paper }
      }
    \begin{tcolorbox}[enhanced~jigsaw, breakable,
      colback=jwjournal-note-background,
      boxrule=0pt, top=2pt, bottom=2pt, left=1em-1mm, right=
        \bool_if:NTF \l__jwjournal_color_entry_bool
          { 2mm }
          { -1mm },
      borderline~west={1mm}{0mm}{jwjournal-entry!90!main-text!60!paper}, frame~hidden]
        #1
    \end{tcolorbox}
  }

\NewDocumentCommand \JWJournalSkip { D<>{.5} }
  {
    % \vspace{#1\baselineskip}
    % \vskip#1\baselineskip
    \par\vspace{#1\baselineskip}
  }
\NewDocumentCommand \JWJournalBack { D<>{.5} }
  {
    % \vspace{-#1\baselineskip}
    % \vskip-#1\baselineskip
    \par\vspace{-#1\baselineskip}
  }

\newenvironment{JWJournalCompactCenter}
  {\parskip=0pt\par\nopagebreak\centering}
  {\par\noindent\ignorespacesafterend}
\newenvironment{JWJournalCenter}
  {\parskip=0pt\par\medskip\nopagebreak\centering}
  {\par\noindent\ignorespacesafterend}
\newenvironment{JWJournalLeft}
  {\parskip=0pt\par\medskip\nopagebreak\raggedright}
  {\par\noindent\ignorespacesafterend}
\newenvironment{JWJournalRight}
  {\parskip=0pt\par\medskip\nopagebreak\raggedleft}
  {\par\noindent\ignorespacesafterend}
\NewDocumentCommand \JWJournalCompactCenterText { m }
  {
    \begin{JWJournalCompactCenter}
      #1
    \end{JWJournalCompactCenter}
  }
\NewDocumentCommand \JWJournalShowImageCenter { D<>{*} m D<>{*} }
  {
    \str_if_eq:nnTF { #1 } { * }
      {
        \str_if_eq:nnTF { #3 } { * }
          {
            \tl_set:Nn \l_tmpa_tl { 1 }
          }
          {
            \tl_set:Nn \l_tmpa_tl { #3 }
          }
      }
      {
        \tl_set:Nn \l_tmpa_tl { #1 }
      }
    \begin{JWJournalCenter}
      \includegraphics[width= \tl_use:N \l_tmpa_tl \linewidth]{#2}
    \end{JWJournalCenter}
  }
\NewDocumentCommand \JWJournalShowImageLeft { D<>{*} m D<>{*} }
  {
    \str_if_eq:nnTF { #1 } { * }
      {
        \str_if_eq:nnTF { #3 } { * }
          {
            \tl_set:Nn \l_tmpa_tl { 1 }
          }
          {
            \tl_set:Nn \l_tmpa_tl { #3 }
          }
      }
      {
        \tl_set:Nn \l_tmpa_tl { #1 }
      }
    \begin{JWJournalLeft}
      \includegraphics[width= \tl_use:N \l_tmpa_tl \linewidth]{#2}
    \end{JWJournalLeft}
  }
\NewDocumentCommand \JWJournalShowImageRight { D<>{*} m D<>{*} }
  {
    \str_if_eq:nnTF { #1 } { * }
      {
        \str_if_eq:nnTF { #3 } { * }
          {
            \tl_set:Nn \l_tmpa_tl { 1 }
          }
          {
            \tl_set:Nn \l_tmpa_tl { #3 }
          }
      }
      {
        \tl_set:Nn \l_tmpa_tl { #1 }
      }
    \begin{JWJournalRight}
      \includegraphics[width= \tl_use:N \l_tmpa_tl \linewidth]{#2}
    \end{JWJournalRight}
  }

\newtcbox \JWJournalCodebox
  {
    tcbox~raise~base,
    nobeforeafter,
    boxrule=.1pt, boxsep=1.5pt, arc=1pt,
    left=.5pt, right=.5pt, top=0pt, bottom=0pt,
    colframe=main-text!60!paper,
    colback=main-text!3!paper,
    fontupper=\small\normalfont\ttfamily,
  }
\NewDocumentCommand \JWJournalCode { m }
  {
    % \textcolor{emph-text}{\texttt{#1}}
    \JWJournalCodebox{\vphantom{Äpgjy}#1}
  }

\tl_new:N \g_jwjournal_content_tl
\NewDocumentEnvironment { jwjournal } { +b }
  {
    \tl_gset:Nn \g_jwjournal_content_tl { #1 }
    \jwjournal_parse_content:N \g_jwjournal_content_tl
    \tl_use:N \g_jwjournal_content_tl
  }
  {}
\tl_new:N \g_jwjournal_local_content_tl
\NewDocumentCommand \jwjournaltext { +m }
  {
    \tl_gset:Nn \g_jwjournal_local_content_tl { #1 }
    \jwjournal_parse_content:N \g_jwjournal_local_content_tl
    \tl_use:N \g_jwjournal_local_content_tl
  }
\NewDocumentCommand \InputJournal { m }
  {
    \file_get:nnN { #1 } { } \l_tmpa_tl
    \exp_args:No \jwjournaltext { \l_tmpa_tl }
  }
\NewDocumentCommand \IncludeJournal { m }
  {
    \clearpage
    \InputJournal { #1 }
    \clearpage
  }

\tl_const:Nn \c_jwjournal_new_line_with_skip_tl { \\[.3\baselineskip] }
\bool_new:N \l_jwjournal_regex_no_more_match_bool
\seq_new:N \l_jwjournal_tmp_seq
\tl_new:N \l_jwjournal_tmp_tl
\cs_generate_variant:Nn \regex_split:nnN { nVN }
\cs_new:Nn \jwjournal_regex_replace_case_once_skip_math:nN
  {
    \regex_replace_case_once:nN
      {
        { \$ (.*?) \$ } { \0 }
        { \c{\(} (.*?) \c{\)} } { \0 }
        { \c{\[} (.*?) \c{\]} } { \0 }
        #1
      } #2
  }
\cs_new:Nn \jwjournal_regex_replace_case_all_skip_math:nN
  {
    \regex_replace_case_all:nN
      {
        { \$ (.*?) \$ } { \0 }
        { \c{\(} (.*?) \c{\)} } { \0 }
        { \c{\[} (.*?) \c{\]} } { \0 }
        #1
      } #2
  }
\cs_new:Nn \jwjournal_parse_content:N
  {
    \regex_split:nVN { \c{par} } #1 \l_jwjournal_tmp_seq
    \tl_gclear:N #1
    \seq_map_inline:Nn \l_jwjournal_tmp_seq
      {
        \tl_set:Nn \l_jwjournal_tmp_tl { ❄️ ##1 }

        \regex_replace_all:nnN
          { ={3,} }
          { }
          \l_jwjournal_tmp_tl

        \regex_replace_all:nnN
          { \:\:\: }
          { \c{IncludeJournal} }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { \:\: }
          { \c{InputJournal} }
          \l_jwjournal_tmp_tl

        \regex_replace_all:nnN
          { \#\#\#\#\+ }
          { \c{subsubsection} }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { \#\#\#\+ }
          { \c{subsection} }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { \#\#\+ }
          { \c{section} }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { \#\#\#\# }
          { \c{subsubsection}\* }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { \#\#\# }
          { \c{subsection}\* }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { \#\# }
          { \c{section}\* }
          \l_jwjournal_tmp_tl

        \regex_replace_all:nnN
          { \`\` }
          { ❝ }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { \` (.*?) \` }
          { \c{JWJournalCode} {\1} }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { ❝ }
          { \`\` }
          \l_jwjournal_tmp_tl

        \regex_match:nVT { ❄️ \ *? -> } \l_jwjournal_tmp_tl
          {
            \regex_match:nVTF { ❄️ \ *? -> \ *? < [\+\-\ ]*(\d+|\d*\.\d+)\ * > } \l_jwjournal_tmp_tl
              {
                \exp_args:Nno \regex_extract_once:nnN
                  { ❄️ \ *? -> \ *? < ([\+\-\ ]*(?:\d+|\d*\.\d+)\ *) > }
                  { \l_jwjournal_tmp_tl }
                  \l_tmpa_seq
                \seq_pop_left:NN \l_tmpa_seq \l_tmpa_tl
                \seq_pop_left:NN \l_tmpa_seq \l_tmpa_tl
                \tl_gput_right:Nn #1 { \JWJournalSkip }
                \tl_gput_right:Nx #1 { < \l_tmpa_tl > }
                \regex_replace_once:nnN
                  { ❄️ \ *? -> \ *? < (?:[\+\-\ ]*(?:\d+|\d*\.\d+)\ *) > (.*)  }
                  { ❄️ \1 }
                  \l_jwjournal_tmp_tl
              }
              {
                \tl_gput_right:Nn #1 { \JWJournalSkip }
                \regex_replace_once:nnN
                  { ❄️ \ *? -> \ *? (.*)  }
                  { ❄️ \1 }
                  \l_jwjournal_tmp_tl
              }
          }
        \regex_replace_all:nnN
          { -> }
          { \c{JWJournalSkip} }
          \l_jwjournal_tmp_tl
        \regex_match:nVT { ❄️ \ *? <- } \l_jwjournal_tmp_tl
          {
            \regex_match:nVTF { ❄️ \ *? <- \ *? < [\+\-\ ]*(\d+|\d*\.\d+)\ * > } \l_jwjournal_tmp_tl
              {
                \exp_args:Nno \regex_extract_once:nnN
                  { ❄️ \ *? <- \ *? < ([\+\-\ ]*(?:\d+|\d*\.\d+)\ *) > }
                  { \l_jwjournal_tmp_tl }
                  \l_tmpa_seq
                \seq_pop_left:NN \l_tmpa_seq \l_tmpa_tl
                \seq_pop_left:NN \l_tmpa_seq \l_tmpa_tl
                \tl_gput_right:Nn #1 { \JWJournalBack }
                \tl_gput_right:Nx #1 { < \l_tmpa_tl > }
                \regex_replace_once:nnN
                  { ❄️ \ *? <- \ *? < (?:[\+\-\ ]*(?:\d+|\d*\.\d+)\ *) > (.*)  }
                  { ❄️ \1 }
                  \l_jwjournal_tmp_tl
              }
              {
                \tl_gput_right:Nn #1 { \JWJournalBack }
                \regex_replace_once:nnN
                  { ❄️ \ *? <- \ *? (.*)  }
                  { ❄️ \1 }
                  \l_jwjournal_tmp_tl
              }
          }
        \regex_replace_all:nnN
          { <- }
          { \c{JWJournalBack} }
          \l_jwjournal_tmp_tl

        % \regex_replace_all:nnN
        %   { \|\| }
        %   { \c{JWJournalShowImageCenter} }
        %   \l_jwjournal_tmp_tl
        % \regex_replace_all:nnN
        %   { \(\( }
        %   { \c{JWJournalShowImageLeft} }
        %   \l_jwjournal_tmp_tl
        % \regex_replace_all:nnN
        %   { \)\) }
        %   { \c{JWJournalShowImageRight} }
        %   \l_jwjournal_tmp_tl
        \jwjournal_regex_replace_case_all_skip_math:nN
          {
            { \|\| } { \c{JWJournalShowImageCenter} }
            { \(\( } { \c{JWJournalShowImageLeft} }
            { \)\) } { \c{JWJournalShowImageRight} }
          } \l_jwjournal_tmp_tl

        % \regex_replace_once:nnN
        %   { \| }
        %   { \c{hfill} }
        %   \l_jwjournal_tmp_tl
        \jwjournal_regex_replace_case_once_skip_math:nN
          {
            { \| } { \c{hfill} }
          } \l_jwjournal_tmp_tl

        \regex_replace_all:nnN
          { [^\:]// }
          { \c{c_jwjournal_new_line_with_skip_tl} }
          \l_jwjournal_tmp_tl

        % \regex_replace_all:nnN
        %   { \*\*\* (.*?) \*\*\* }
        %   { \c{textbf} { \c{emph} {\1} } }
        %   \l_jwjournal_tmp_tl
        % \regex_replace_all:nnN
        %   { \*\* (.*?) \*\* }
        %   { \c{textbf} {\1} }
        %   \l_jwjournal_tmp_tl
        % \regex_replace_all:nnN
        %   { \* (.*?) \* }
        %   { \c{emph} {\1} }
        %   \l_jwjournal_tmp_tl
        \jwjournal_regex_replace_case_all_skip_math:nN
          {
            { \*\*\* (.*?) \*\*\* } { \c{textbf} { \c{emph} { \1 } } }
            { \*\* (.*?) \*\* } { \c{textbf} { \1 } }
            { \* (.*?) \* } { \c{emph} { \1 } }
          } \l_jwjournal_tmp_tl

        \regex_replace_once:nnN
          { >>> \ *? (.*) }
          { \c{JWJournalNote} {\1} }
          \l_jwjournal_tmp_tl
        \regex_replace_all:nnN
          { \ *? >>> \ *? }
          { }
          \l_jwjournal_tmp_tl
        % \exp_args:Nno \regex_split:nnN { >>> } { \l_jwjournal_tmp_tl } \l_tmpa_seq
        % \seq_pop_left:NN \l_tmpa_seq \l_tmpa_tl
        % \tl_set_eq:NN \l_jwjournal_tmp_tl \l_tmpa_tl
        % \seq_map_inline:Nn \l_tmpa_seq
        %   {
        %     \tl_put_right:Nn \l_jwjournal_tmp_tl
        %       { \JWJournalNote { ####1 } }
        %   }

        \exp_args:Nno \regex_split:nnN { >> } { \l_jwjournal_tmp_tl } \l_tmpa_seq
        \seq_pop_left:NN \l_tmpa_seq \l_tmpa_tl
        \tl_set_eq:NN \l_jwjournal_tmp_tl \l_tmpa_tl
        \seq_map_inline:Nn \l_tmpa_seq
          {
            \tl_put_right:Nn \l_jwjournal_tmp_tl
              { \JWJournalCompactCenterText { ####1 } }
          }

        \bool_set_false:N \l_jwjournal_regex_no_more_match_bool
        \bool_do_until:nn \l_jwjournal_regex_no_more_match_bool
          {
            \regex_match:nVTF { ❄️ \ *? \+{3} } \l_jwjournal_tmp_tl
              {
                \tl_gput_right:Nn #1 { \c_jwjournal_enlarge_page_by_one_line_tl }
                \regex_replace_once:nnN
                  { ❄️ \ *? \+{3} (.*) }
                  { ❄️ \1 }
                  \l_jwjournal_tmp_tl
              }
              {
                \bool_set_true:N \l_jwjournal_regex_no_more_match_bool
              }
          }

        \tl_put_right:Nn \l_jwjournal_tmp_tl { ❄️ }
        \regex_match:nVT { ❄️ \ *? \-{3,} \ *? ❄️ } \l_jwjournal_tmp_tl
          {
            \regex_replace_once:nnN
              { ❄️ \ *? \-{3,} \ *? }
              { ❄️ \c{JWJournalSepLine} }
              \l_jwjournal_tmp_tl
          }
        \regex_replace_once:nnN { ❄️ (.*) ❄️ } { ❄️ \1 } \l_jwjournal_tmp_tl

        % \regex_replace_once:nnN
        %   { ❄️ (\ *)? (\d{4}-\d{1,2}-\d{1,2}) (\ *)? (.*) }
        %   { \c{JWJournalEntry} {\2} {\4} }
        %   \l_jwjournal_tmp_tl
        % \regex_replace_once:nnN
        %   { ❄️ (\ *)? (\d{1,2}-\d{1,2}-\d{4}) (\ *)? (.*) }
        %   { \c{JWJournalEntry} {\2} {\4} }
        %   \l_jwjournal_tmp_tl
        \regex_replace_once:nnN
          { ❄️ (\ *)? (\d{4} \D \d{1,2} \D \d{1,2}) (\ *)? (.*) }
          { \c{JWJournalEntry} {\2} {\4} }
          \l_jwjournal_tmp_tl
        \regex_replace_once:nnN
          { ❄️ (\ *)? (\d{1,2} \D \d{1,2} \D \d{4}) (\ *)? (.*) }
          { \c{JWJournalEntry} {\2} {\4} }
          \l_jwjournal_tmp_tl

        \regex_replace_once:nnN
          { ❄️ \ *? \[(.*?)\] (.*) }
          { \c{JWJournalItem} {\1} {\2} }
          \l_jwjournal_tmp_tl
        \regex_replace_once:nnN
          { ❄️ \ *? 【(.*?)】(.*) }
          { \c{JWJournalItem} {\1} {\2} }
          \l_jwjournal_tmp_tl

        \regex_replace_once:nnN
          { ❄️ \ *? \~\~ \ *? (.*) }
          { \c{JWJournalContinue} {\1} }
          \l_jwjournal_tmp_tl

        \regex_replace_once:nnN { ❄️ } { } \l_jwjournal_tmp_tl

        \tl_gput_right:NV #1 \l_jwjournal_tmp_tl
        \tl_gput_right:Nn #1 { \par }
      }
  }

\bool_if:NTF \l__jwjournal_scroll_bool
  {
    \tl_const:Nn \c_jwjournal_enlarge_page_by_one_line_tl {}
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
    \tl_const:Nn \c_jwjournal_enlarge_page_by_one_line_tl { \enlargethispage{\baselineskip} }
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

\def\textasterisk{*}
\def\textbacktick{`}
\def\textcolon{:}
\def\textequalsign{=}
\def\textleftparen{(}
\def\textrightparen{)}
\def\textsharp{\#}
\def\textvert{|}

\endinput
%%
%% End of file `jwjournal.cls'.
