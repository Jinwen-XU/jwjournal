<!-- Copyright (C) 2023 by Jinwen XU -->

# `jwjournal`, a personal LaTeX class for writing journals

## Introduction

A typical journal entry produced by `jwjournal` looks like this:
![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo1.png)

Codewise, it is as simple as below:
```
2023-01-01 Sunny | Botanical Garden

  Today I visited the botanical garden!

  [Food] And had *ice cream* for lunch!

  >>> This botanical garden has a history of nearly two hundred years, take a look at this photo:
      || <0.40> {example-image}

  (( <0.45> {example-image-a}
  <- <5>
  )) <0.50> {example-image-b}
  <- <5>
  (( <0.45> {example-image-c}
```

> It is also possible to write the date as `2023/01/01`.

> With the options `month-day-year` or `day-month-year`, you can also write date in the format `mm-dd-yyyy` or `dd-mm-yyyy`, respectively. You may refer to the English and French demo documents for examples.

Every day of the week has its unique color, like this:
![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo2.png)

By the way, the conversion from plain date string like `2023-01-01` to natural language like `January 1, 2023 ⬦ Sunday` is done by `jwjournal` automatically and has multilingual support. Thus, for example (via `\UseLanguage`):
- Chinese: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-cn.png)
- French: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-fr.png)
- German: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-de.png)
- Japanese: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-jp.png)
- Spanish: ![image](https://github.com/Jinwen-XU/jwjournal/raw/main/screenshots/demo3-es.png)
- ... and more...

## Usage

The structure of the document is very simple:
```latex
\documentclass[11pt, paperstyle = light yellow, color entry]{jwjournal}
\UseLanguage{⟨language⟩}
\begin{document}



% Your journal



\end{document}
```
The available class options include:
- `month-day-year` or `day-month-year` for using other date format;
- `paperstyle = ...` adjusts the paper color, choices include: `light yellow`, `yellow`, `parchment`, `green`, `light gray`, `gray`, `nord`, `dark`...
- `color entry` adds more color to the title of each entry;
- `scroll` turns the scroll mode on, which generates a single-page pdf similar to a long screenshot.

Here are the major syntaxes for your main text:
1) Title
    - Any line begins with date like `2023-01-01` or `2023/01/01` would be regard as the *Title* line.
    - You may write the weather and/or location after the date.
    - Example:
      ```
      2023-01-01 Sunny | Apartment
      ```
    > With the options `month-day-year` or `day-month-year`, you can also write date in the format `mm-dd-yyyy` or `dd-mm-yyyy`, respectively. You may refer to the English and French demo documents for examples.
1) Note
    - Any line begins with something like `[Note]` would be regard as the *Note* line.
    - Example:
      ```
      [Note] In hindsight, it was the right decision.
      ```
      The space(s) between `[Note]` and the text following it would be ignored.
    > You may also use `【` and `】`, which is especially useful when writing Chinese.
1) Emphasis
    - You may emphasize text as with Markdown:
      - `*⟨text⟩*` is emphasizing;
      - `**⟨text⟩**` is bolding;
      - `***⟨text⟩***` is bolding and emphasizing.
    - You may put text in a colored block via `>>>`, its usage is like the `>` in Markdown for blockquote.
1) Image
    - Displayed images can be included via one of the following ways:
      - `|| <⟨width⟩> {⟨image file name⟩}` or `|| {⟨image file name⟩} <⟨width⟩>`: show image in the middle.
      - `(( <⟨width⟩> {⟨image file name⟩}` or `(( {⟨image file name⟩} <⟨width⟩>`: show image on the left.
      - `)) <⟨width⟩> {⟨image file name⟩}` or `)) {⟨image file name⟩} <⟨width⟩>`: show image on the right.
    > The `<⟨width⟩>` is optional. Here `⟨width⟩` is a number like `0.75`, the unit is `\linewidth`. When `<⟨width⟩>` is not given, the width would be full `\linewidth`.

With a few more for icing on the cake:
- `|`: The first vertical bar would be interpreted as `\hfill`. This allows you to write the title line as
  ```
  2023-01-01 Sunny | Botanical Garden
  ```
  and then the address `Botanical Garden` would be printed at the end of the title line.
- `\\` and `//`: `\\` has its usual meaning in LaTeX for starting a new line, while `//` has been defined to be starting a new line with some vertical spacing. This allows you to write the annotations as:
  ```
  [Note] Some text.
    //
    More text.
    //
    (Some remark)
    \\
    (Another remark)
    \\
    (Final remark)
  ```
  As a result, all the text would be properly indented.
  > Note that images specified via `||`, `((` or `))` already contain line breaks, thus you don't need to (actually, *you can't*) write `//` or `\\` around them.
- `>>`: Text after `>>` would be centered. This is intended for writing annotations/captions for displayed images:
  ```
  || {image-name}
  >> (Some remark)
  >> (Another remark)
  ```
- `~~`: If you use `>>` or `>>>` inside a Note block (i.e. lines start with `[...]`), then there would no way to get out of the centered or boxed area and then continue the indented text; in such cases, you may start a new paragraph that start with `~~`, this will continue the indented text block:
  ```
  [Test] Here is some text.
    || {some-image} <.4>
    >> (Centered text)

  ~~
    Some more text.
    >>> Text in color box.

  ~~
    And more text.
  ```
- `->` and `<-`: Skip or retrieve certain vertical space, by default half of `\baselineskip`. You may specify the exact spacing in the unit of `\baselineskip`: for example, `-> <0.3>` would be skipping `0.3\baselineskip`, while `<- <.75>` means retrieving `0.75\baselineskip`.
- `+++`: If a single sentence or a few words fall to the next page, you may write a `+++` before that entry to enlarge the current page by one line.
  > You may write this `+++` several times if necessary, but do make sure that the number of the `+` sign is a multiple of 3.
- `===`: Three or more equal signs `=` would simply be ignored. This is for improving the readability of the code, allowing you to write your journal like:
  ```
  2023-01-01 Sunny | Botanical Garden
  ===================================

  Today I visited the botanical garden!

  [Food] And had ice-cream for lunch!
  ```

> You may also refer to the demo documents to see their behaviors in action.

> And don't forget that you are still using LaTeX! Thus if the provided syntax does not satisfy you, there are always LaTeX commands as a fallback.

Indentations are not important, but paragraphs need to be separated by a blank line. For the sake of readability, it is recommended to organize your text as one of the following ways:
- with indentation:
  ```
  2023-01-01
  Sunny | Botanical Garden

    ......
    ......
  ```
- with a separation line:
  ```
  2023-01-01 Sunny | Botanical Garden
  ===================================

  ......
  ......
  ```
- or maybe even:
  ```
  ==========
  2023-01-01    Sunny | Botanical Garden
  ==========

  ......
  ......
  ```

## TeXnical details

### Engines and base classes
- With pdfLaTeX, the base class is `minimart`.
- With XeLaTeX or LuaLaTeX, the base class is `einfart`.

### Regarding the fonts

If you are using XeLaTeX or LuaLaTeX to compile your document, then the current document class requires the following open-source fonts that are not included in the standard TeX collection:

- The Source Han font series at [Adobe Fonts](https://github.com/adobe-fonts). More specifically:
  - Source Han Serif, [go to its Release page](https://github.com/adobe-fonts/source-han-serif/releases).
  - Source Han Sans, [go to its Release page](https://github.com/adobe-fonts/source-han-sans/releases).
  - Source Han Mono, [go to its Release page](https://github.com/adobe-fonts/source-han-mono/releases).
  > It is recommended to download the Super-OTC version, so that the total download size would be smaller, and the installation would be easier.

These are necessary if you wish to write your document in Chinese (either simplified or traditional) or Japanese. Also, without these fonts installed, the compilation speed might be much slower — the compilation would still pass, but the system shall spend (quite) some time verifying that the fonts are indeed missing before switching to the fallback fonts.

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
The main features are achieved with the power of LaTeX3's regex functionality. It scans the content paragraph by paragraph and converts recognized patterns into corresponding TeX commands. Thus, `2023-01-01 Weather` becomes `\JWJournalEntry{2023-01-01}{Weather}`, `[Note] ...` becomes `\item[Note] ...` inside a `description` environment, and `+++` is essentially `\enlargethispage{\baselineskip}`, etc. However, this comes with a price: in order to scan the content, it is firstly stored in a macro `\g_jwjournal_content_tl`, and that means that you cannot use commands like `\verb` in your main text (unless explicitly `\end{jwjournal}`, write your code, and then `\begin{jwjournal}`).
Also, synctex won't work properly.

### Dates
The conversion of date string to natural language, and the calculation of the day of the week are accomplished by `projlib-date`, part of the `ProjLib` toolkit, which is still at its early stage, in some aspects not as functional as existing package such as `datenumber`, but should evolve through time.

### Language and date format
Language and date format can both be set in two ways: as class option or with corresponding commands.
- The user-level command for setting language is `\UseLanguage`, provided by `projlib-language`; the one for setting date format is `\SetDatetimeInputFormat`, provided by `projlib-date`.
- When you set the language, it is not exactly the same using class option or using command: when you select a language via class option, only the setting for this language would be loaded; however, with `\UseLanguage`, it would load *all* the language settings and then switch to your selected one. Sometimes the page breaking behavior differs slightly. Personally I prefer the `\UseLanguage` approach, for this would allow you to switch language in the middle of your document.

### Scroll mode
The scroll mode is achieved by directly accessing `\pdfpageheight` (pdfTeX and XeTeX) or `\pageheight` (LuaTeX). The minimal page height is set to be `10in`. It is worth noting that in order to calculate the height needed, the entire content are put into a single box, which puts a limitation on the length of your document (but this usually wouldn't be a problem).

# License

This work is released under the LaTeX Project Public License, v1.3c or later.
