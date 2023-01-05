<!-- Copyright (C) 2023 by Jinwen XU -->

# `jwjournal`, a personal LaTeX class for writing journals

## Introduction

A typical journal entry produced by `jwjournal` looks like this:
![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo1.png)

Codewise, it is as simple as below:
```
2023-01-01 Sunny --- Botanical Garden

  Today I visited the botanical garden!

  [Food] And had ice-cream for lunch!
```

Every day of the week has its unique color, like this:
![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo2.png)

By the way, the conversion from plain date string like `2023-01-01` to natural language like `January 1, 2023 | Sunday` is done automatically by `jwjournal` and has multilingual support. Thus, for example (with `\UseLanguage{...}`):
- Chinese: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-cn.png)
- French: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-fr.png)
- German: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-de.png)
- Japanese: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-jp.png)
- Spanish: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-es.png)
- ... and more...

## Usage

The structure of the document is very simple:
```latex
\documentclass[11pt, paperstyle=light yellow, color entry]{jwjournal}
\begin{document}

% Your journal

\end{document}
```
The options are:
- `paperstyle = ...` adjusts the paper color, options include: lightyellow、yellow、parchment、green、lightgray、gray、nord、dark...
- `color entry` adds more color to the title of each entry
- `scroll` turns on the scroll mode and can generate a single-page pdf similar to a long screenshot

And there are only three syntaxes for the main text:
1) Title
    - Any line begins with date like `2023-01-01` would be regard as the Title line.
    - You may write the weather and/or location after the date.
    - Example:
      ```
      2023-01-01 Sunny --- Apartment
      ```
2) Note
    - Any line begins with something like `[Note]` would be regard as the Note line.
    - Example:
      ```
      [Note] In hindsight, it was the right decision.
      ```
3) `+++`
    - In some rare case, if a single sentence or a few words fall to the next page, you may write a `+++` to enlarge the current page by one line.

> You may also refer to the demo documents to see their behaviors in action.

Indentations are not important, but paragraphs need to be separated by a blank line. For the sake of readability, it is recommended to organize your text as follows:
```
2023-01-01 Sunny

  ......
  ......



2023-01-02 Cloudy

  ......
  ......



2023-01-03 Rainy

  ......
  ......
```

## TeXnical details

### Engine
First of all, it is based on the document class `einfart`, thus can only be compiled with XeLaTeX or LuaLaTeX.

### Colors
The colors from Monday to Sunday have the internal names `jwjournal-color-1`, ..., `jwjournal-color-7`. Currently they are defined as:
```latex
\colorlet { jwjournal-color-1 } { yellow!50!green  }
\colorlet { jwjournal-color-2 } { yellow!70!orange }
\colorlet { jwjournal-color-3 } { cyan!70!blue     }
\colorlet { jwjournal-color-4 } { violet           }
\colorlet { jwjournal-color-5 } { yellow!40!cyan   }
\colorlet { jwjournal-color-6 } { yellow!20!orange }
\colorlet { jwjournal-color-7 } { red!20!orange    }
```

### Functionality
The main features are achieved with the power of LaTeX3's regex functionality. It scans the content paragraph by paragraph and converts recognized patterns into corresponding TeX commands. Thus, `2023-01-01 Weather` becomes `\JWJournalEntry{2023-01-01}{Weather}`, `[Note] ...` becomes `\item[Note] ...` inside a `description` environment, and `+++` is essentially `\enlargethispage*{\baselineskip}`.

### Scroll mode
The scroll mode is achieved by directly accessing `\pdfpageheight` (XeTeX) or `\pageheight` (LuaTeX). The minimal page height is set to be `10in`. It is worth noting that in order to calculate the height needed, the entire content are put into a single box, which puts a limitation on the length of your document.

# License

This work is released under the LaTeX Project Public License, v1.3c or later.
