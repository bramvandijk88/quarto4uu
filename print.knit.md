---
toc: true
toc-depth: 2
search: false
execute:
  freeze: false
---

# Print book 🖨️ {.unnumbered}

::: {.screen-only}
This is the whole book in one document, so that a single print gives you
everything rather than one chapter at a time. Nothing here is a second copy:
the chapters are pulled straight from the same sources as the chapter pages,
so this page cannot fall behind them.

Pick a layout and the print dialog opens:

```{=html}
<div class="print-choices">
  <button type="button" onclick="printBook('print-1col')">
    🖨️ One column
  </button>
  <button type="button" onclick="printBook('print-2col')">
    🖨️ Two columns, smaller type
  </button>
</div>
<script>
  function printBook(mode) {
    const root = document.documentElement;
    root.classList.remove('print-1col', 'print-2col');
    root.classList.add(mode);
    window.print();
  }
  // Leave no trace on screen once the dialog closes.
  window.addEventListener('afterprint', function () {
    document.documentElement.classList.remove('print-1col', 'print-2col');
  });
</script>
```


**One column** is the readable default: full-width text, and the side-by-side
figure panels stay side by side. See left-hand side of image below.

**Two columns** fits noticeably more text on a sheet, which is worth real money
if students pay to print it. The type comes down a little with the measure, and
the side-by-side panels stack rather than squeeze into half a column. Wide code
blocks and long equations are the things to check before committing to it. See right-hand side of image below.

::: {.print-preview}
![](figures/layouts.png){fig-alt="One-column and two-column print layouts compared"}
:::

Either way the book opens on a cover page and every chapter starts on a fresh
sheet. Pressing <kbd>Cmd</kbd>/<kbd>Ctrl</kbd>+<kbd>P</kbd> without using a
button gives you the one-column version.
:::

```{=html}
<style>
/* This page is an unnumbered chapter, which makes Quarto drop numbering for
   the whole document -- including every chapter pulled in below. The numbers
   still matter though: "What Quarto is, and why bother" is chapter 1 on the
   website and must be chapter 1 here too. So they are counted back in.
   Welcome and About carry .unnumbered from their own headings and are
   skipped, exactly as they are in the sidebar. Scoped to this page. */
main { counter-reset: chapnum; }
main > section.level1:not(.unnumbered) > h1::before {
  counter-increment: chapnum;
  content: counter(chapnum) "\00a0\00a0";
}

@media print {
  /* The page's own heading is screen furniture -- on paper the book opens
     on its cover instead. Scoped here, so a single chapter still prints
     with its own title. */
  #title-block-header { display: none !important; }
}
</style>
```

::: {.cover-page}
![](figures/uu-logo.png){.cover-logo .nolightbox fig-alt="Utrecht University"}

[{{< meta book.title >}}]{.cover-title}

[{{< meta book.subtitle >}}]{.cover-subtitle}

[{{< meta book.author >}}]{.cover-author}
:::

# Welcome {.unnumbered}

This is a practical guide for teachers at Utrecht University who want to
offer students a course **website** along with their usual course book. For this,
we can use [Quarto](https://quarto.org), which generates interactive and easy-to-navigate
website, that is also printer-friendly. That means students can choose to read it on 
their screen, print it, and with very little extra effort, you can combine all this
into [an actual course book](https://tbb.bio.uu.nl/bvd/bms/slides/BMS_Cursusboek_2026.pdf)!

Here, I explain how do do all this by using Quarto in RStudio. However, Quarto itself
is a broader framework: it works just as happily from Jupyter notebooks or VS
Code, and with Python or Julia instead of R. We describe the RStudio route
because, within the Biology department, that is the environment most colleagues
already have open.

## What you end up with

Two course books in our own department are built exactly this way, and everything in
this guide is drawn from their source:

- **[Biologische Modellen en Statistiek](https://bioms-uu.github.io)** —
  a full Dutch-language course book with interactive statistics applets, shared
  LaTeX macros, and a printable PDF from the same source.
- **[Modeling Life](https://modelinglife-uu.github.io/)** — an English course
  website with embedded simulations and mini-projects. 


## What this explainer covers

- **Getting started**: installing stuff, making the project, and the one
  configuration file that decides everything.
- **Writing**: text, maths, code that runs, callouts, exercises, figures, and
  getting a decent PDF out of the same source.
- **Interactive material**: embedding simulations, code your students can
  edit and run in the browser, and self-contained applets. This is the part
  students love, so this makes a Quarto book worth the effort.
- **Building and publishing**: rendering the book and putting it online via Github
pages. 

## Starting from scratch or from a template

You can either start from scratch, or start from a template. **This explainer is itself also a
starter book**: every chapter is a working demonstration of the thing it
describes, so copying it yields you the UU house style, a working `_quarto.yml`,
an example live applet, how to use figures, and an example of every pattern you are likely to
need.

[**Download the starter book (.zip)**](starter-book.zip) — then see
@sec-starter for how to open it in RStudio.


# What Quarto is, and why bother {#sec-what}

Quarto is a free, open-source publishing system. You write in plain text —
`.qmd` files, which use Markdown syntax: `#` and `##` indicate chapter and
section headings, text between one or two asterisks (`*`) is italic/bold 
respectively, etc. Quarto can render this into a website or a PDF.

## Why it suits teaching

**Less worry about formatting, more focus on content ** Your book is a folder of plain text files. 
This enables you to think better about the content, rather than worry about
formatting. Quarto takes care of 90% of the formatting (I will not lie, sometimes
you will still need to tweak a bit if you're a prefectionist). 

**Maths renders properly.** You can use LaTeX to format all your math by putting
text between dollar signs. It prints beautifully, and students can copy/paste
either the image or the LateX code easily. 

**Code can run.** A plot in your reader can be generated by the code that
produced it, so the figure and the analysis never drift apart.

**Interactive explainers right next to the explanation.** A student can read about the material,
model and immediately turn some knobs (see section @sec-iframes). In fact, with @sec-webr they can
edit the R or Python code and run it **locally** in the browser, even if they have no R
or Python installed. 

**Navigational structure comes for free.** Sidebar, search box, chapter numbering,
cross-references and a table of contents are all generated for you.

## What you need to install

As said, we will go the Rstudio route here. Three things you need to install, 
in this order.

1. **[R](https://cran.r-project.org)**: the programming language itself.
2. **[RStudio Desktop](https://posit.co/download/rstudio-desktop/)**: the
   editor. RStudio v2022.07 and later have built-in Quarto support.
3. **[Quarto](https://quarto.org/docs/get-started/)** (sometimes optional)

Recent RStudio versions ship with a copy of Quarto bundled, so step 3 is
sometimes optional. But perhaps always good to jot down which version of Quarto 
you have. 

::: {.callout-note}
## Which version am I on?
In RStudio: <kbd>Tools</kbd> → <kbd>Terminal</kbd> → <kbd>New Terminal</kbd>,
then type `quarto --version`. This is one of the few times in this guide you need a
terminal, and you can skip it if you would rather not. But let's be honest, we
all like to feel like a hacker every now and then =) 
:::

## Document, website, or book?

The most important file, `_quarto.yml`, decides what you are building.

| `type:` | What you get | Good for |
|---|---|---|
| `default` | A single standalone document | A single web-page for a practical or lecture |
| `website` | Many pages with a top navigation bar | A course site: schedule, links, materials |
| `book` | Numbered chapters, a sidebar, cross-references, and a combined PDF | A course reader |

A book *is* a website with extra structure, so starting as a website and
graduating to a book later costs almost nothing. This guide assumes a book.

## Not an R user? {#sec-other-languages}

Almost nothing here is really about R. Write ```` ```{python} ```` instead
of ```` ```{r} ```` and your code chunks run Python; Julia and Observable JS
work too, and a book can mix them. However, I have no experience using Quarto with 
Python or other languages, so I cannot give you any advice on that. It's probably
just as easy. Either way, the structure, the figures, the callouts, the iframes, the
publishing, this is all identical whether you edit in RStudio, VS Code, or a plain text editor.

So let's get started. 


# Setting up in RStudio {#sec-setup}

Duration: ten minutes, once. At the end you will have a real book rendering in front of
you.

There are two ways in, and the second is usually the better one.

## Option A: start from this book {#sec-starter}

**The book you are reading is itself a starter template.** Every chapter in this 
guide is a working demonstration of the thing it describes. Download and
extract the folder below and you inherit all of it: the UU house style, 
a working `_quarto.yml`, a sensible `.gitignore`^[If you will follow the guide and
publish your book on Github pages, this files ensures you do not track every single temporary file
along with the actual contents of the book.], and an example
of each pattern you are likely to need.

[**Download the starter book (.zip)**](starter-book.zip)


## Opening a downloaded folder in RStudio
1. Unzip it somewhere sensible and **rename the folder** to your course.
2. In RStudio: <kbd>File</kbd> → <kbd>New Project…</kbd> → **<kbd>Existing
   Directory</kbd>** → browse to that folder → <kbd>Create Project</kbd>.

   *Existing Directory* is the option people miss, because the wizard's first
   screen pushes you towards *New Directory*. It creates nothing of its own. It
   only tells RStudio "this folder is a project", writes an `.Rproj` file into
   it, and opens it. Everything already in the folder stays exactly as it is.
   (The zip deliberately contains no `.Rproj`, so the one RStudio makes will be
   named after *your* folder.)
3. Press **Render**. You should get this book back, running locally. Nothing
   else needs installing.
4. Now start replacing. Open `_quarto.yml`, change the title and author, and
   work through the chapters one at a time: keep the scaffolding, delete our
   prose, write yours.


::: {.callout-note}
## What to keep, what to throw away
**Keep:** `_quarto.yml` (although you'll edit it), `uu.scss` (uu house style), 
`.gitignore`, and folder structure (e.g. `figures/` and `applets/`)., and `applets/AI-prompt-template.md`.
Keep `make-starter-zip.R` only if you want to hand *your* book on the same way.

**Throw away** once you no longer need them: the speicific chapter files for this book, 
and apps/figures only used for this explainer. 
:::

## Option B: start from nothing

If you would rather setup your book from an empty folder, which will help you
better understand how it works, you can start one from scratch with RStudio.

## Make the project

<kbd>File</kbd> → <kbd>New Project…</kbd> → <kbd>New Directory</kbd> →
<kbd>Quarto Book</kbd>.

Give the folder a name. Tick **Create a git repository** if you already know
you want to publish it (see @sec-publishing): it is easier to tick now than to
add later. Press **Create**.

RStudio opens the new project, and you are already looking at a working book.

## Press Render

The **Render** button sits in the toolbar above the editor. The first render
takes a few minutes (depending on the book size); the finished book then 
appears either in the RStudio's Viewer pane or in your web browser (system dependent).
All the HTML files are moved to a folder called `_book` (or later: `docs` — see @sec-yml). 
Note that you can open the HTML files in this directory from your file browser,
and everything will work with one exception: the live code chunks, which
either requires a local webserve (by typing `quarto preview` in the terminal), 
or simply an online copy of your book (see @sec-publishing).

If you use `quarto preview` to show your web book in the browser, there is a neat
little tick-box left of the Render button called `Render on Save`. Now every save refreshes the preview by
itself. 

![The Render button sits in the toolbare above the editor](figures/renderbutton.png)

## Source or Visual?

Note that the toolbar with the render button also contains a <kbd>Source</kbd>/<kbd>Visual</kbd>
toggle.

**Visual** gives you a Word-like view real bold text, real tables, menus for
inserting figures, equations and cross-references. If you dont want to see any markup at all,
you can live here permanently.

**Source** shows the markup. It is faster once you know it, and it is what the
rest of this guide shows. I do recommend this, with one exception, shown in the 
tip below.

::: {.callout-tip}
## Make tables in Visual mode
Markdown tables are miserable to write by hand and trivial in Visual mode.
Insert one there, then switch back to Source. Or ask AI to convert a table
into markdown. 
:::

## Important elements in a Quarto book folder

| Item | What it is |
|---|---|
| `_quarto.yml` | The book definition: which chapters, in which order, with which theme. **The only file you truly must understand** (see @sec-yml). |
| `index.qmd` | The front page. You cannot rename this file, it is required and it the 'home page' of your web book. |
| `*.qmd` | One file per chapter. This is where you write. You can enable / disable chapters by modifying `_quarto.yml`. |
| `_book/` | The finished website, generated by Quarto upon rendering. Don't edit these files, they will be overwritten next render anyway. |
| `*.Rproj` | RStudio's project file. Double-click it to reopen the book later. |
| `_freeze/` | Stored results of code that has already been run or rendered, helps speed up rendering later (see @sec-rendering). |


# Almost everything is controlled by one file: `_quarto.yml` {#sec-yml}

This one file is the table of contents, the theme, and the settings. It is probably
good to go through this step by step. Although the rest of working with Quarto
is ust writing, you need to know a little bit about this file. That being said,
if you end up using my template, you mostly need to modify the chapter organisation. If you want
to use your own style, you can change the theme and add your own SCSS. 

## A minimal book

```yaml
project:
  type: book
  output-dir: docs          # where the finished website is written

book:
  title: "My Course Book"
  author: "Your Name, Utrecht University"
  chapters:
    - index.qmd             # the front page
    - part: "Getting started"     # groups chapters under a heading
      chapters:
        - 01-writing.qmd
        - 02-figures.qmd
    - part: "Practicals"
      chapters:
        - 03-practical.qmd
  appendices:               # lettered instead of numbered
    - answers.qmd

format:
  html:
    theme: cosmo            # any Bootswatch theme
    toc: true
  pdf:
    documentclass: scrreprt # delete if you never want a PDF
```

Three blocks matter most:

- **`project`** — what you are building, and where the output goes.
- **`book`** — the structure, and which chapters in which order.
- **`format`** — how each output type looks.


## The side bar

Your book will render each chapter with a navigation sidebar, like the one
you can see to the left right now. Note that a very long chapter title makes 
an ugly sidebar entry. In fact, this specific chapter has a very long title.
Fortunately, you can give the sidebar its own shorter text, which was 
done for this chapter:

```yaml
    chapters:
      - text: "Quarto yml"
        href: 03-quarto-yml.qmd
```

Chapters can also live in subfolders, organising your websites into bigger
chunks of chapters (e.g. part 1 and part 2 of a course). 

## Indentation

YAML indentation is annoyingly strict, and must be **spaces, never tabs**. If Quarto
complains about the file and the message makes no sense, indentation is
almost always the cause. 

## CSS / UU house style {#sec-theming}

You can modify how your book looks by changing the style sheets. Some that
ship with Quarto are `cosmo`, `flatly`and `litera` (all read well as a textbook).
If you are familiar with CSS stylesheet, you can layer that on top:

```yaml
format:
  html:
    theme: [cosmo, uu.scss]
```

That is what this book uses. Quarto will also happily use a light/dark 
pair:

```yaml
    theme:
      light: [cosmo, uu.scss]
      dark:  [darkly, uu-dark.scss]
```


The theme listed as the first is the default, and the reader's choice is remembered in
their browser. Add `respect-user-color-scheme: true` and it follows their
operating system settings instead. 

::: {.callout-note}
## Why this book has no dark mode
The UU identity is specified on a white ground, and has no dark mode counter part.
So I decided not to add it. You can do it for your own book, of course, as we
have done for many of ours (see @fig-bmsdark). 
:::

![Example of a dark/light mode toggle in our (Dutch) course book for Biological Modelling and statistics.](figures/darkmode.png){#fig-bmsdark width=50%}

## Other options in the yaml 

The yaml has [many other options](https://quarto-tdg.org/yaml.html). With out listing all of them, you can look 
into these:


```yaml
book:
  favicon: figures/favicon.png    # the little (20x20) icon next the web address
  search: true  # search function enabled, really useful for students
  sidebar: # menu to the left
    logo: figures/uu-logo.png # logo's for your course / UU branding
    style: floating # other option: 'docked'
    collapse-level: 1 # how many levels of headings are collapsed (1=all)
    pinned: true # stays visible when scrolling down
  page-footer:
    left: "Utrecht University"
    right: "Quarto 4 UU"

format:
  html:
    toc-location: right  # paragraph menu to the right of web page
    lightbox: true       # click figures to enlarge it
    code-overflow: wrap  # wrap code that contain too many characters
    link-external-newwindow: true # external links are always opening in a new window
```

The official UU logo files are on the
[corporate identity site](https://www.uu.nl/en/organisation/corporate-identity);
download the right variant rather than taking one off a web random website.


# Writing a chapter {#sec-writing}

A `.qmd` file is written in Markdown (q=quarto, md=markdown). That means you
can write in plain text with a few marks for emphasis. It is extended with
additional options: maths, raw html, (runnable) code that is easy to copy/paste, and 
cross-references. This page discusses some basics.

## Text and headings

`**bold**`, `*italic*`, `` `code` ``, `[link text](url)`. A blank line starts a new
paragraph.

One `#` is the chapter title, `##` a section, `###` a subsection. They get automatically
numbered based on where they appear in the book (e.g. the second subsection of the first paragraph of chapter
3, will be 3.1.2). The sections (`##`) are headings are what fill the table of contents on the right of every page, so
they are worth naming well.

Add `{.unnumbered}` directly after a heading to keep a page out of the chapter
numbering. This is useful for a preface, a schedule, or a links page.

## Maths

Inline between single dollars: `$f(x) = x^3 + \alpha x` gives
$f(x) = x^3 + \alpha x$. You can also put maths between double dollars, with a label so you
can point at it later:

```markdown
$$
\frac{\mathrm{d}N}{\mathrm{d}t} = rN\left(1 - \frac{N}{K}\right)
$$ {#eq-logistic}
```

$$
\frac{\mathrm{d}N}{\mathrm{d}t} = rN\left(1 - \frac{N}{K}\right)
$$ {#eq-logistic}

Writing `@eq-logistic` anywhere in the book now produces a numbered, clickable
reference: @eq-logistic.

If you're familiar with LateX, I'm sure you'll find your way with this stuff.

## Code that produces a figure

A chunk marked `{r}` is executed when you render, and its output lands on the
page.


::: {.cell}

```{.r .cell-code}
t <- 0:40
logistic <- function(r, K = 100, N0 = 2) {
  N <- numeric(length(t)); N[1] <- N0
  for (i in 2:length(t)) N[i] <- N[i-1] + r * N[i-1] * (1 - N[i-1]/K)
  N
}
plot(t, logistic(0.10), type = "l", lwd = 2, ylim = c(0, 110),
     xlab = "time", ylab = "N")
lines(t, logistic(0.20), lwd = 2, lty = 2)
lines(t, logistic(0.35), lwd = 2, lty = 3)
legend("bottomright", c("r = 0.10", "r = 0.20", "r = 0.35"), lty = 1:3, lwd = 2)
```

::: {.cell-output-display}
![Logistic growth for three values of $r$.](print_files/figure-html/fig-growth-1.png){#fig-growth width=576}
:::
:::


Because that chunk carries `label: fig-growth`, it is referenceable as
@fig-growth.

Chunk options go one per line at the top of the chunk, each starting with `#|`:

| Option | Effect |
|---|---|
| `echo: false` | run the code, hide it from students |
| `eval: false` | show the code, don't run it |
| `code-fold: true` | hide the code behind a "Show the code" toggle |
| `code-summary: "..."` | the text on that toggle |
| `warning: false` | suppress R's warnings |
| `label: fig-…` | make the output referenceable as a figure |
| `fig-width`, `fig-height` | size in inches |

: Chunk options you will actually use. {#tbl-chunk-options}

::: {.callout-tip}
## Set the defaults once
Options that you with to apply, can be given in the main `_quarto.yml`:

```yaml
execute:
  echo: true
  warning: false
```
Individual chunks can still override them. 

:::

## Code that is only shown

To *display* code without running it (Python code that students will run
themselves, for instance) use a plain fenced block with no curly braces:
write ```` ```python ```` rather than ```` ```{python} ````. You still get
syntax highlighting, and nothing executes.

## Callouts

Five kinds, and they are the workhorse of a teaching book.

::: {.callout-note}
`note` background information. 
:::

::: {.callout-tip}
## A title
`tip` general advice. Here's a tip: a `##` heading on the first line becomes the callout's title.
:::

::: {.callout-important}
`important` the thing students must not miss!
:::

::: {.callout-warning}
`warning` a common mistake or pitfall
:::

::: {.callout-caution collapse="true"}
## Click to see the answer
A note (like this one: `caution`) that has `collapse="true"` enabled, starts folded shut. This is how you
put a hint or a worked answer right next to the question without giving it away immediately.
:::

```markdown
::: {.callout-caution collapse="true"}
## Click to see the answer
Hidden until the student expands it.
:::
```

## Exercises that number themselves

::: {#exr-carrying}
## Carrying capacity

Using @eq-logistic, what happens to $\mathrm{d}N/\mathrm{d}t$ when $N = K$?

  a. Write down the answer.
  b. Check it against @fig-growth.
:::

```markdown
::: {#exr-carrying}
## Carrying capacity
Using @eq-logistic, what happens when $N = K$?
:::
```

Refer to it as `@exr-carrying` → @exr-carrying. Reorder your chapters and every
number in the book renumbers itself.

## Cross-references, in one table

All the organisation and structure of the book is handled by Quarto. The **prefix decides how it will be 
referenced**, so it is
not optional decoration.

| Write this label | Refer to it as | Gives |
|---|---|---|
| `{#fig-cover}` | `@fig-cover` | Figure 2.1 |
| `{#tbl-params}` | `@tbl-params` | Table 3.2 |
| `{#eq-logistic}` | `@eq-logistic` | Equation 4.1 |
| `{#sec-writing}` | `@sec-writing` | Section 4 |
| `{#exr-carrying}` | `@exr-carrying` | Exercise 4.1 |
| `{#tip-setup}` | `@tip-setup` | Tip 1 |

: Cross-reference prefixes. {#tbl-xref}

Note that `{#cover}` does nothing at all, only `{#fig-cover}` works. A reference that renders
as `?@fig-cover` means the label is missing, misspelled, or lacking its prefix.


## Diagrams without a drawing program

```{mermaid}
%%| label: fig-approaches
%%| fig-cap: "Two ways to study a biological system."
flowchart TB
  A(Biological system) --> B(Model)
  A --> C(Data)
  B --> D(Simulate)
  C --> E(Statistics)
```

Six lines of [Mermaid](https://mermaid.js.org/) produce @fig-approaches, and it
restyles itself with the rest of the book. Far easier to maintain than a PNG
exported from PowerPoint. 


# Figures and tables {#sec-figures}

## Inserting a figure

Put the image in a `figures/` folder next to your chapters, and write one line:

```markdown
![A caption students will actually read.](figures/example-figure.svg)
```

![Two ways of coping with biological complexity: simplify it into a model, or measure it and use statistics.](figures/example-figure.svg)

The text in square brackets is the caption. `![]()` with an empty caption is
allowed, but a caption is nearly always worth writing.

## Sizing, alignment and labels

Options go in curly braces after the image:

```markdown
![Caption](figures/example-figure.svg){#fig-example width=55% fig-align="center"}
```

![The same figure at 55% width, centred.](figures/example-figure.svg){#fig-example width=55% fig-align="center"}

`width` is best given as a percentage so it adapts to the reader's screen (you'd
be surprised how many students will read from their phones...). 

`fig-align` takes `left`, `center` or `right`. The `#fig-` prefix makes it referred
to as @fig-example (rather than Table, Equation, etc.)


## Click to enlarge

`lightbox: true` in `_quarto.yml` makes every figure in the book open
full-screen when clicked. 

## Figures side-by-side

```markdown
::: {layout-ncol=2}
![Left panel](figures/a.svg)

![Right panel](figures/b.svg)
:::
```

::: {layout-ncol=2}
![Left panel](figures/example-figure.svg)

![Right panel](figures/example-figure.svg)
:::

## Tables

An ordinary Markdown table, with a caption line underneath to make it
referenceable:

```markdown
| Symbol | Meaning | Unit |
|---|---|---|
| $N$ | population density | individuals per square kilometer |
| $r$ | intrinsic growth rate | per day / day$^{-1}$ |
| $K$ | carrying capacity | maximum individuals per km$^2$ |

: Parameters of the logistic model. {#tbl-parameters}
```

| Symbol | Meaning | Unit |
|---|---|---|
| $N$ | population density | individuals per square kilometer |
| $r$ | intrinsic growth rate | per day / day$^{-1}$ |
| $K$ | carrying capacity | maximum individuals per km$^2$ |

: Parameters of the logistic model. {#tbl-parameters}

Which is @tbl-parameters.


# Maths and LaTeX {#sec-latex}

Quarto writes maths with **LaTeX** notation. You do not need to *learn LaTeX* itself,
but the math notation is maybe worth knowing. Here's a quick overview. 

## Inline and displayed

**Inline** maths sits between single dollars, inside a sentence:

``` markdown
The population grows at rate $r$ until it approaches $K$.
```

The population grows at rate $r$ until it approaches $K$.

**Displayed** maths sits between double dollars, on its own lines, and is
centred:

``` markdown
$$
\frac{\mathrm{d}N}{\mathrm{d}t} = rN\left(1 - \frac{N}{K}\right)
$$
```

$$
\frac{\mathrm{d}N}{\mathrm{d}t} = rN\left(1 - \frac{N}{K}\right)
$$

::: {.callout-important}
## Leave the dollars tight against the maths
`$r$` works. `$ r $` may not — Quarto uses the spacing to tell maths from an
ordinary dollar sign. If you need a literal dollar in your text, escape it with 
a slash: `\$`.
:::

## Common notation for LateX equation

| You want | You write | You get |
|---|---|---|
| subscript | `$N_t$` | $N_t$ |
| superscript | `$e^{-x}$` | $e^{-x}$ |
| more than one character | `$N_{t+1}$` | $N_{t+1}$ |
| fraction | `$\frac{a}{b}$` | $\frac{a}{b}$ |
| derivative | `$\frac{\mathrm{d}N}{\mathrm{d}t}$` | $\frac{\mathrm{d}N}{\mathrm{d}t}$ |
| partial derivative | `$\frac{\partial u}{\partial x}$` | $\frac{\partial u}{\partial x}$ |
| square root | `$\sqrt{x}$`, `$\sqrt[3]{x}$` | $\sqrt{x}$, $\sqrt[3]{x}$ |
| sum | `$\sum_{i=1}^{n} x_i$` | $\sum_{i=1}^{n} x_i$ |
| product | `$\prod_{i=1}^{n} p_i$` | $\prod_{i=1}^{n} p_i$ |
| integral | `$\int_0^\infty f(x)\,\mathrm{d}x$` | $\int_0^\infty f(x)\,\mathrm{d}x$ |
| limit | `$\lim_{t \to \infty} N_t$` | $\lim_{t \to \infty} N_t$ |
| mean / hat / tilde | `$\bar{x}$, $\hat{p}$, $\tilde{N}$` | $\bar{x}$, $\hat{p}$, $\tilde{N}$ |
| vector | `$\vec{v}$`, `$\mathbf{v}$` | $\vec{v}$, $\mathbf{v}$ |

: Notation for everyday use. {#tbl-latex-basics}

| You want | You write | You get |
|---|---|---|
| times / divide | `$a \times b$`, `$a \div b$` | $a \times b$, $a \div b$ |
| plus-minus | `$\pm$` | $\pm$ |
| approximately | `$\approx$` | $\approx$ |
| proportional to | `$\propto$` | $\propto$ |
| not equal | `$\neq$` | $\neq$ |
| less/greater or equal | `$\leq$, $\geq$` | $\leq$, $\geq$ |
| much less/greater | `$\ll$, $\gg$` | $\ll$, $\gg$ |
| arrow | `$\to$`, `$\rightarrow$` | $\to$ |
| implies / equivalent | `$\Rightarrow$, $\Leftrightarrow$` | $\Rightarrow$, $\Leftrightarrow$ |
| infinity | `$\infty$` | $\infty$ |
| element of | `$x \in \mathbb{R}$` | $x \in \mathbb{R}$ |
| dots | `$x_1, \ldots, x_n$` | $x_1, \ldots, x_n$ |

: Symbols and relations. {#tbl-latex-symbols}

Greek letters are their names with a backslash: `$\alpha \beta \gamma \delta
\lambda \mu \sigma \tau \phi \theta \rho$` gives
$\alpha \beta \gamma \delta \lambda \mu \sigma \tau \phi \theta \rho$.
Capitalise the first letter for the capital form: `$\Delta$, $\Sigma$, $\Omega$`
gives $\Delta$, $\Sigma$, $\Omega$.

## Statistics notation

| You want | You write | You get |
|---|---|---|
| sample mean | `$\bar{x}$` | $\bar{x}$ |
| estimate | `$\hat{\beta}$` | $\hat{\beta}$ |
| expectation | `$\mathbb{E}[X]$` | $\mathbb{E}[X]$ |
| variance / sd | `$\mathrm{Var}(X)$, $\mathrm{SD}(X)$` | $\mathrm{Var}(X)$ |
| probability | `$P(X > x)$` | $P(X > x)$ |
| conditional | `$P(A \mid B)$` | $P(A \mid B)$ |
| distributed as | `$X \sim N(\mu, \sigma^2)$` | $X \sim N(\mu, \sigma^2)$ |
| null hypothesis | `$H_0: \mu = \mu_0$` | $H_0: \mu = \mu_0$ |
| degrees of freedom | `$t_{n-1}$` | $t_{n-1}$ |

: Notation for the statistics chapters. {#tbl-latex-stats}


## Words inside formulas

Anything you type in maths mode is set in italic, letter by letter, as if every
character were a variable. That is wrong for words and for units:

``` markdown
Wrong:  $rate = births per day - deaths per day$
Right:  $\text{rate} = \text{births per day} - \text{deaths per day}$
```

Wrong: $rate = births per day - deaths per day$

Right: $\text{rate} = \text{births per day} - \text{deaths per day}$

## Multi-line equations

Two environments cover almost everything. **`aligned`** lines equations up on a
chosen character — put an `&` where the alignment should happen and `\\` at the
end of each line:

``` markdown
$$
\begin{aligned}
\frac{\mathrm{d}R}{\mathrm{d}t} &= aR - bRC \\
\frac{\mathrm{d}C}{\mathrm{d}t} &= cRC - dC
\end{aligned}
$$
```

$$
\begin{aligned}
\frac{\mathrm{d}R}{\mathrm{d}t} &= aR - bRC \\
\frac{\mathrm{d}C}{\mathrm{d}t} &= cRC - dC
\end{aligned}
$$

**`cases`** is for a piecewise definition:

``` markdown
$$
f(x) =
\begin{cases}
0 & \text{if } x < 0 \\
1 & \text{if } x \geq 0
\end{cases}
$$
```

$$
f(x) =
\begin{cases}
0 & \text{if } x < 0 \\
1 & \text{if } x \geq 0
\end{cases}
$$

A matrix, if you need one:

``` markdown
$$
J = \begin{pmatrix}
\partial f / \partial x & \partial f / \partial y \\
\partial g / \partial x & \partial g / \partial y
\end{pmatrix}
$$
```

$$
J = \begin{pmatrix}
\partial f / \partial x & \partial f / \partial y \\
\partial g / \partial x & \partial g / \partial y
\end{pmatrix}
$$

`pmatrix` gives round brackets, `bmatrix` square ones, `vmatrix` the vertical
bars of a determinant.


## Numbering and referring to an equation

Put a `#eq-` label after the closing `$$`:

``` markdown
$$
\frac{\mathrm{d}N}{\mathrm{d}t} = rN\left(1 - \frac{N}{K}\right)
$$ {#eq-logistic2}
```

$$
\frac{\mathrm{d}N}{\mathrm{d}t} = rN\left(1 - \frac{N}{K}\right)
$$ {#eq-logistic2}

Then `@eq-logistic2` gives @eq-logistic2, numbered and clickable, and the
numbering fixes itself when you reorder chapters. For a custom label, you can use
square brackets: `[see @eq-logistic2]` gives [see @eq-logistic2].

## Define your notation once {#sec-macros}

I write $\mathrm{d}N/\mathrm{d}t$, $\mathrm{d}X/\mathrm{d}t$, and $\mathrm{d}Y/\mathrm{d}t$ a lot, 
and to do the math formatting correctly, I make the 'd' non-italic (correct for derivative). 
This is a bit long and annoying to to write: `$\mathrm{d}N/\mathrm{d}t$`.

So in my books, I use a macro to define it once. Put your macros in a file
called `_macros.tex` at the top of the project:

``` tex
\newcommand{\dt}[1]{\frac{\mathrm{d}#1}{\mathrm{d}t}}
```

The `[1]` means "this macro takes one argument", and `#1` is where that
argument lands. So `\dt{N}` expands to the whole thing for $\mathrm{d}N/\mathrm{d}t$.

Then start every chapter that needs them with an include shortcode on the very
first line:

``` markdown
{{{< include _macros.tex >}}}
```

`_macros.tex` can also contain `\usepackage{…}` lines that only make sense for
the PDF. MathJax simply ignores them, which is why one include is safe for both
formats.


## When something does not render

A formula that shows as raw `\frac{...}` text, or a chunk of the page that has
gone blank, is nearly always one of these:

| Symptom | Cause |
|---|---|
| Raw LaTeX visible on the page | Unbalanced `$` or `$$` somewhere *earlier* in the chapter |
| Everything after a point is italic | An unclosed `$` |
| `\left` error | A `\left` with no matching `\right` |
| Nothing renders in one chapter | This one give no useful errors, but a missing `{{{< include _macros.tex >}}}` is often the culprit. |

: Maths that will not render. {#tbl-latex-trouble}

::: {.callout-tip}
## A tools worth knowing
[Detexify](https://detexify.kirelabs.org) lets you *draw* a symbol and tells you
its LaTeX name.
:::


# Getting it onto paper {#sec-pdf}

There are a few ways of getting your webbook onto paper. 

## A real PDF, rather than printing a web page

The easiest (but not always best) way to give a web book as both html and
PDF, is to add both to the format section of `_quarto.yml`:

```yaml
format:
  html:
    theme: [cosmo, uu.scss]
  pdf:
    documentclass: scrreprt
    include-in-header: _macros.tex
```

Rendering then produces both. This needs a LaTeX installation; if you have none,
`quarto install tinytex` sets up a small self-contained one.

However, we ended up not using this options for our course books. It remains 
a little difficult to ensure the web book and the PDF really looked the same. Instead,
we ensured the entire web-book was printer friendly, and decided to work from there. And
if the student then decides to print it themselves, it will also look nice for 
them!

## Printing the web page {#sec-printing}

Although a minority, some students enjoy printing your book. We found that approximately 1
in 8 students still wanted a printed version, which is why we decided to offer 
not only a printer-friendly web book, but also compiled our own PDF via the printing route.

First things first: you do **not** have to worry about all the web elements, like the side bars
and logos. Try it: hit print on this web page and you'll they dont get printed. But
what about interactive elements, like simulations and videos? How will these get printed?
We did a bit of additional hacking to fix this.

### A trick applied in this template

The trick below is already in this template, but if you have interactive materials
and are **not** using this template, it is really worth copying. 
In our course material, every interactive embed in that book is a pair:
a screenshot with a short caption for the printed version, and the live thing for screen.

```` markdown
:::{.print-only}
<center>*Interactive content available on the website.*
![](figuren/interactive_plife.png){fig-align=center}
</center>
:::

:::{.screen-only}
```{=html}
<iframe width="100%" height="550"
  src="https://jsfiddle.net/…/embedded/result" title="Simulation"></iframe>
```
:::
````

The cost is that you have to take the screenshots, which can be a little extra work. 
Without a doubt, there will be better solutions for this soon-ish, but this enables
us to be fully in control of what ends up being shown in the printed version 
of the web book. 

::: {.callout-tip collapse="true"}
## Going further: a two-column print layout
If you wish, you can apply a two-column layout, which we have use for one of our
books (saving 70 pages that students did not need to pay for). To do this, 
us `column-count: 2` inside the `@media print` part of the uu.scss file. But carefully
check your equations and wide code blocks, which do not enjoy narrow columns.
:::

::: {.callout-tip collapse="true"}
## Printing the whole book

When you press print on one of these pages, you get a nice PDF, but only of that one chapter. For the *whole*
book you would have to print all of them and stitch the pieces together, and with 
this template, you do not have to do that by hand.

In the sidebar there is a page called **Print book 🖨️**. It is the entire book
in one document: open it, press <kbd>Cmd</kbd>/<kbd>Ctrl</kbd>+<kbd>P</kbd> and
save as PDF. Everything on this page applies, so the `.print-only` screenshots
appear and the live embeds do not.

That page contains no prose of its own. `print.qmd` is a heading followed by a
list of includes, one per chapter:

```` markdown
# Print book 🖨️ {.unnumbered}

# What Quarto is, and why bother {#sec-what}

Quarto is a free, open-source publishing system. You write in plain text —
`.qmd` files, which use Markdown syntax: `#` and `##` indicate chapter and
section headings, text between one or two asterisks (`*`) is italic/bold 
respectively, etc. Quarto can render this into a website or a PDF.

## Why it suits teaching

**Less worry about formatting, more focus on content ** Your book is a folder of plain text files. 
This enables you to think better about the content, rather than worry about
formatting. Quarto takes care of 90% of the formatting (I will not lie, sometimes
you will still need to tweak a bit if you're a prefectionist). 

**Maths renders properly.** You can use LaTeX to format all your math by putting
text between dollar signs. It prints beautifully, and students can copy/paste
either the image or the LateX code easily. 

**Code can run.** A plot in your reader can be generated by the code that
produced it, so the figure and the analysis never drift apart.

**Interactive explainers right next to the explanation.** A student can read about the material,
model and immediately turn some knobs (see section @sec-iframes). In fact, with @sec-webr they can
edit the R or Python code and run it **locally** in the browser, even if they have no R
or Python installed. 

**Navigational structure comes for free.** Sidebar, search box, chapter numbering,
cross-references and a table of contents are all generated for you.

## What you need to install

As said, we will go the Rstudio route here. Three things you need to install, 
in this order.

1. **[R](https://cran.r-project.org)**: the programming language itself.
2. **[RStudio Desktop](https://posit.co/download/rstudio-desktop/)**: the
   editor. RStudio v2022.07 and later have built-in Quarto support.
3. **[Quarto](https://quarto.org/docs/get-started/)** (sometimes optional)

Recent RStudio versions ship with a copy of Quarto bundled, so step 3 is
sometimes optional. But perhaps always good to jot down which version of Quarto 
you have. 

::: {.callout-note}
## Which version am I on?
In RStudio: <kbd>Tools</kbd> → <kbd>Terminal</kbd> → <kbd>New Terminal</kbd>,
then type `quarto --version`. This is one of the few times in this guide you need a
terminal, and you can skip it if you would rather not. But let's be honest, we
all like to feel like a hacker every now and then =) 
:::

## Document, website, or book?

The most important file, `_quarto.yml`, decides what you are building.

| `type:` | What you get | Good for |
|---|---|---|
| `default` | A single standalone document | A single web-page for a practical or lecture |
| `website` | Many pages with a top navigation bar | A course site: schedule, links, materials |
| `book` | Numbered chapters, a sidebar, cross-references, and a combined PDF | A course reader |

A book *is* a website with extra structure, so starting as a website and
graduating to a book later costs almost nothing. This guide assumes a book.

## Not an R user? {#sec-other-languages}

Almost nothing here is really about R. Write ```` ```{python} ```` instead
of ```` ```{r} ```` and your code chunks run Python; Julia and Observable JS
work too, and a book can mix them. However, I have no experience using Quarto with 
Python or other languages, so I cannot give you any advice on that. It's probably
just as easy. Either way, the structure, the figures, the callouts, the iframes, the
publishing, this is all identical whether you edit in RStudio, VS Code, or a plain text editor.

So let's get started. 


# Setting up in RStudio {#sec-setup}

Duration: ten minutes, once. At the end you will have a real book rendering in front of
you.

There are two ways in, and the second is usually the better one.

## Option A: start from this book {#sec-starter}

**The book you are reading is itself a starter template.** Every chapter in this 
guide is a working demonstration of the thing it describes. Download and
extract the folder below and you inherit all of it: the UU house style, 
a working `_quarto.yml`, a sensible `.gitignore`^[If you will follow the guide and
publish your book on Github pages, this files ensures you do not track every single temporary file
along with the actual contents of the book.], and an example
of each pattern you are likely to need.

[**Download the starter book (.zip)**](starter-book.zip)


## Opening a downloaded folder in RStudio
1. Unzip it somewhere sensible and **rename the folder** to your course.
2. In RStudio: <kbd>File</kbd> → <kbd>New Project…</kbd> → **<kbd>Existing
   Directory</kbd>** → browse to that folder → <kbd>Create Project</kbd>.

   *Existing Directory* is the option people miss, because the wizard's first
   screen pushes you towards *New Directory*. It creates nothing of its own. It
   only tells RStudio "this folder is a project", writes an `.Rproj` file into
   it, and opens it. Everything already in the folder stays exactly as it is.
   (The zip deliberately contains no `.Rproj`, so the one RStudio makes will be
   named after *your* folder.)
3. Press **Render**. You should get this book back, running locally. Nothing
   else needs installing.
4. Now start replacing. Open `_quarto.yml`, change the title and author, and
   work through the chapters one at a time: keep the scaffolding, delete our
   prose, write yours.


::: {.callout-note}
## What to keep, what to throw away
**Keep:** `_quarto.yml` (although you'll edit it), `uu.scss` (uu house style), 
`.gitignore`, and folder structure (e.g. `figures/` and `applets/`)., and `applets/AI-prompt-template.md`.
Keep `make-starter-zip.R` only if you want to hand *your* book on the same way.

**Throw away** once you no longer need them: the speicific chapter files for this book, 
and apps/figures only used for this explainer. 
:::

## Option B: start from nothing

If you would rather setup your book from an empty folder, which will help you
better understand how it works, you can start one from scratch with RStudio.

## Make the project

<kbd>File</kbd> → <kbd>New Project…</kbd> → <kbd>New Directory</kbd> →
<kbd>Quarto Book</kbd>.

Give the folder a name. Tick **Create a git repository** if you already know
you want to publish it (see @sec-publishing): it is easier to tick now than to
add later. Press **Create**.

RStudio opens the new project, and you are already looking at a working book.

## Press Render

The **Render** button sits in the toolbar above the editor. The first render
takes a few minutes (depending on the book size); the finished book then 
appears either in the RStudio's Viewer pane or in your web browser (system dependent).
All the HTML files are moved to a folder called `_book` (or later: `docs` — see @sec-yml). 
Note that you can open the HTML files in this directory from your file browser,
and everything will work with one exception: the live code chunks, which
either requires a local webserve (by typing `quarto preview` in the terminal), 
or simply an online copy of your book (see @sec-publishing).

If you use `quarto preview` to show your web book in the browser, there is a neat
little tick-box left of the Render button called `Render on Save`. Now every save refreshes the preview by
itself. 

![The Render button sits in the toolbare above the editor](figures/renderbutton.png)

## Source or Visual?

Note that the toolbar with the render button also contains a <kbd>Source</kbd>/<kbd>Visual</kbd>
toggle.

**Visual** gives you a Word-like view real bold text, real tables, menus for
inserting figures, equations and cross-references. If you dont want to see any markup at all,
you can live here permanently.

**Source** shows the markup. It is faster once you know it, and it is what the
rest of this guide shows. I do recommend this, with one exception, shown in the 
tip below.

::: {.callout-tip}
## Make tables in Visual mode
Markdown tables are miserable to write by hand and trivial in Visual mode.
Insert one there, then switch back to Source. Or ask AI to convert a table
into markdown. 
:::

## Important elements in a Quarto book folder

| Item | What it is |
|---|---|
| `_quarto.yml` | The book definition: which chapters, in which order, with which theme. **The only file you truly must understand** (see @sec-yml). |
| `index.qmd` | The front page. You cannot rename this file, it is required and it the 'home page' of your web book. |
| `*.qmd` | One file per chapter. This is where you write. You can enable / disable chapters by modifying `_quarto.yml`. |
| `_book/` | The finished website, generated by Quarto upon rendering. Don't edit these files, they will be overwritten next render anyway. |
| `*.Rproj` | RStudio's project file. Double-click it to reopen the book later. |
| `_freeze/` | Stored results of code that has already been run or rendered, helps speed up rendering later (see @sec-rendering). |



````

The chapters are pulled from the same sources the chapter pages use, so there
is no second copy of anything. Add a chapter to `_quarto.yml` and you add one
line here as well -- that is the whole maintenance burden.

On paper it opens on a cover built from the `book:` metadata in `_quarto.yml`,
so the title, subtitle and author cannot drift out of step with the website.
After that, every chapter starts on a fresh sheet.

Five settings are doing the work, and all five are worth copying:

| Setting | Lives in | Why |
|---|---|---|
| `{.unnumbered}` on the heading | `print.qmd` | keeps the page out of the chapter numbering, so it does not become chapter 14 |
| `number-sections: false` | `print.qmd` | stops the *included* chapters continuing the book's numbering -- without it the page opens at 14 and runs to 27 |
| `search: false` | `print.qmd` | keeps it out of the search index -- without it every chapter turns up twice in every result |
| `execute: freeze: false` | `print.qmd` | rebuilds the page on every render |
| `main > section.level1` | `uu.scss` | one chapter per sheet. `:first-of-type` is exempt, so a single chapter still prints without a blank leading page |

The freeze one is what will catch you out. Quarto's cache tracks the file it is
rendering, not the files that file includes -- so without it the long page
quietly serves yesterday's text while the chapter pages update, with no warning
of any kind. It costs a few seconds per render, and it saves you publishing a
printed book that no longer matches the website.

A couple of smaller things live in the `@media print` block of `uu.scss` and
apply to every page, not just this one. Links stop being red and underlined,
and only spell out their address in running prose -- in a heading or on the
cover a parenthesised URL is noise. The webR loading spinner is hidden, since
it is often still on screen when the print is taken. And `{layout-ncol}` panels
are forced back into a row: Quarto only lays those out side by side above
992px, and an A4 page is about 660px wide, so without help they silently stack.

One last thing: the page must be listed under `chapters:` in `_quarto.yml`. A
book renders only what is listed there. A loose `.qmd` sitting in the folder is
silently skipped, and adding `project: render:` does not override it.
:::


# Embedding interactive content {#sec-iframes}

An **iframe** is a whole webpage shown inside a box on your page. It's a tiny
website inside your website. It is the single most useful trick in our course books, 
because it lets you develop independent "apps" that you can then drop in the 
middle of the book. 

There are two flavours, written almost identically:

**External** — you point at a page on someone else's server: Desmos for mathmatics,
YouTube for videos, JSFiddle for javascript simulations, or one of my many [other simulations](tbb.bio.uu.nl/bvd/simulations).

**Internal** — you point at an HTML file that lives inside your own project.
Nothing external is involved and it keeps working forever. If you^[With or without the help of our robot overlords] develop your own
little app, you can ship it with your book. 

## How to embed iframes

Raw HTML must be wrapped into a `{=html}` block, or Quarto escapes it and
students see the angle brackets:

````markdown
```{=html}
<iframe src="…" width="100%" height="600"
        style="border:none; border-radius:8px;">
</iframe>
```
````

`width="100%"` makes it responsive to the page width (similar to images, probably
a great idea with students looking at your content on phones and laptops alike). 
`height` is typically fixed for my embeddings. The inline `style` (no border, rounded corners, a little vertical
margin) is what makes an embedded tool look like part of the page rather than a
box someone dropped in.

::: {.callout-important}
## Add a screenshot for the printed version
As discussed in the previous section, an iframe cannot exist on paper. Wrap every one of them in
`::: {.content-visible when-format="html"}` and give the PDF a screenshot and a
link instead — see @sec-pdf. Otherwise the PDF gets a mysterious blank gap, or worse,
something half cut-off or overlapping with your book's content. The simulation below 
has a replacement: if you press print now, you will see the stale image appear with
a remark that this interactive content is only available on the website.
:::

## External: a simulation on another server

::: {.screen-only}
```{=html}
<iframe src="https://tbb.bio.uu.nl/bvd/simulations/australia/"
        width="100%" height="560"
        title="Rabbits in Australia"
        style="border:none; border-radius:8px;">
</iframe>
```
:::

::: {.print-only}
**Simulation: rabbits in Australia.** The interactive version is at
<https://tbb.bio.uu.nl/bvd/simulations/australia/> 
![figures](figures/australia.png)
:::

```html
<iframe src="https://tbb.bio.uu.nl/bvd/simulations/australia/"
        width="100%" height="560" title="Rabbits in Australia"
        style="border:none; border-radius:8px;"></iframe>
```

## External: a Desmos graph

Build the graph on [desmos.com/calculator](https://www.desmos.com/calculator),
press **Share**, and use the URL you are given (something like 
`https://www.desmos.com/calculator/qxycdqwsdq`) directly as the `src`.
Students can then drag its sliders inside your book. We use these
quite often for students that struggle with maths. 


```html
<iframe src="https://www.desmos.com/calculator/qxycdqwsdq"
        width="100%" height="467"
        style="border:1px solid #ccc;" frameborder="0"></iframe>
```

Give you:

```{=html}
<iframe src="https://www.desmos.com/calculator/qxycdqwsdq"
        width="100%" height="467"
        style="border:1px solid #ccc;" frameborder="0"></iframe>
```


## External: a video

Do not hand-write an iframe for YouTube. Quarto has a shortcode that does it
properly, including on phones:

```markdown
{{{< video https://www.youtube.com/embed/wo9vZccmqwc >}}}
```

Give you: 

{{< video https://www.youtube.com/embed/wo9vZccmqwc >}}

## External: code students can edit and run

[JSFiddle](https://jsfiddle.net) hosts a small program together with its
output. Append `/embedded/result` to the share URL for output only, or
`/embedded/js,result` to show the code beside it so students can change a
parameter and press Run.

```html
<iframe src="https://tbb.bio.uu.nl/bvd/simulations/cooperation/"
        width="100%" height="600" title="Simulation"></iframe>
```

Give you:

```{=html}
<iframe src="https://tbb.bio.uu.nl/bvd/simulations/cooperation/"
        width="100%" height="600" title="Simulation"></iframe>
```

::: {.callout-warning}
## External things break
Fair warning: every external iframe relies on that web page staying online. 
Servers move, accounts expire, embedding gets blocked... Probably check
any external links at the start of each course year, and for anything
students are assessed on, best to make it internal.
:::

## Internal: an applet inside your own book

One self-contained `.html` file in a folder in your project. The `src` is then
just a relative path:

````markdown
```{=html}
<iframe src="applets/example-applet.html"
        width="100%" height="620"
        title="Logistic growth explorer"
        style="border:none; border-radius:8px; margin:1em 0;">
</iframe>
```
````

Which gives you what you see below, a real applet, running inside this page:

::: {.screen-only}
```{=html}
<iframe src="applets/example-applet.html"
        width="100%" height="620"
        title="Logistic growth explorer"
        style="border:none; border-radius:8px; margin:1em 0;">
</iframe>
```
:::

::: {.print-only}
**Applet: logistic growth explorer.** Sliders for $r$, $K$ and $N_0$, with the
resulting trajectory. Open the book in a browser to use it.
:::

Notice that this does not transfer well to a printed version of your book, but there
is a solution. See @sec-printing.



---
# This chapter has REAL runnable cells, so it needs the knitr engine, the
# include line below, and the quarto-live extension in _extensions/.
# To go back to a book that renders with nothing installed, see "Going back".
engine: knitr
---


::: {.cell}

:::




# Code students can run in the browser {#sec-webr}

To run Python and R code, we often have servers set up that can run the code
for our students. For big projects, that is still the way to go. But for small
bits of practice code, there's a better way: **run it locally in the student's browser**. 
No server, no accounts, and no other barriers related to installation. I will
spare you the technical details of how it works^[for those interested, look for
[WebAssembly](https://webassembly.org/)) online]. Let's see how it works. 

## A first example

Both cells below are real executable R code. Each is an editor with **Run Code** and **Start
Over** buttons: students can change stuff, run it, and reset it when they have made
a mess.

<!-- DEMO1-START -->

::: {.cell}
```{webr}
for (x in 1:5) {
  print(10 + x)
}
```
:::

<!-- DEMO1-END -->

Here is a second cell with some more advanced code, a toy-model of paracetamol in the 
blood, mostly a nice finger exercise I give to students to learn about for loops^[I know, not the best way to go about with R but they have to learn the concepts of loops]:

<!-- DEMO2-START -->

::: {.cell caption='Paracetamol in the blood' min-lines='12'}
```{webr}
#| caption: Paracetamol in the blood
#| min-lines: 12
p <- 400          # amount of paracetamol in the blood (mg)
d <- 0.7          # decay rate 

for (i in 1:100) { # little loop for "every hour"
  if (runif(1) < 0.1) {   # randomly take another dose of paracetamol 10% chance
    p[i] <- p[i] + 400 # bump dose
  }
  p[i+1] <- p[i] * d # apply decay
}

plot(p, type = 'l', lwd = 2, col = "#C00A35",
     xlab = "Tijd (uren)", ylab = "Paracetamol (mg)")
```
:::

<!-- DEMO2-END -->

Try running the code above, and you'll even see a plot appear! If you run it 
many times, you'll even see it's different every time. 

::: {.callout-note}
## Loading webR
Before you can press **Run Code**, the first cell has to fetch R itself, so give it a few
seconds; after that everything on the page is instant. @sec-webr-install
explains how this was set up, and how to switch it back off.
:::

## Where this sits among the other options

| Option | Who wrote the code | Can the student change it? | Where does it run |
|---|---|---|---|
| External iframe (@sec-iframes) | Someone else | Only what the tool allows | Their server |
| Internal applet (@sec-ai) | You, once | No — sliders only | The student's browser |
| **Runnable code cell** | **You** | **Yes, any of it** | **The student's browser** |

: The three kinds of interactive content. {#tbl-interactive}

An applet is the right choice when you want a student to *explore a
relationship*. A runnable code cell is right when you want them to *write the
code*.

## Installing it {#sec-webr-install}

The above setup requires an extension, [**Quarto Live**](https://r-wasm.github.io/quarto-live/), and
installing it can be done in the R terminal. It is one command, run once per project.

::: {.callout-tip}
## Step by step, in RStudio

1. Open the project (`File → Open Project`, or double-click its `.Rproj`).
2. Click the **Terminal** tab: bottom-left pane, next to Console.
3. **Check where you are.** Type `pwd` and press Enter. It must print your
   project folder. If it prints your home folder instead, move there first:

```{=html}
<div class="sourceCode"><pre class="sourceCode bash"><code class="sourceCode bash">cd ~/Files/…/YourBookFolder</code></pre></div>
```

4. Now install:

```{=html}
<div class="sourceCode"><pre class="sourceCode bash"><code class="sourceCode bash">quarto add r-wasm/quarto-live</code></pre></div>
```

5. It asks whether you trust the authors. Assuming you do trust the authors, press **Y**, Enter. 
   It may ask a  second time to confirm; **Y** again.
6. Check it worked: a folder `_extensions/r-wasm/live/` should now exist in the
   project. In RStudio's Files pane you may need the **More → Show Hidden
   Files** option to see it.
:::

::: {.callout-warning}
## The mistake that costs ten minutes
`quarto add` installs into **whatever folder the Terminal is currently in**,
not into the project you have open in RStudio. Those are usually the same
thing, but not always — a Terminal that opened in your home folder will
cheerfully create `_extensions` there, report success, and leave your book
exactly as broken as before. That is what step 3 is for. If it has already happened, either
re-run the command or drag the stray `_extensions` folder into your project^[That 
doesnt always work, but it does in this case]. 
:::

If you're going to use git to work on your book with multiple teachers, 
you can add the **`_extensions/` folder to Git** along with everything else. Then
your colleague does not need to install anything, it's simply some files with
configurations for your folder, not a local installation. 

## One more step before it works

Two edits, both one line.

**In `_quarto.yml`,** change the html format to `live-html`:

```{=html}
<div class="sourceCode"><pre class="sourceCode yaml"><code class="sourceCode yaml">format:
  live-html:          # was: html
    theme: [cosmo, uu.scss]
    toc: true</code></pre></div>
```

`live-html` is ordinary `html` with the WebAssembly machinery added, so
everything else — the theme, the sidebar, cross-references — carries on
unchanged.

**At the top of every chapter that has a live cell**, immediately below the
closing `---` of the YAML header:

```{=html}
<div class="sourceCode"><pre class="sourceCode markdown"><code class="sourceCode markdown">{{&lt; include ./_extensions/r-wasm/live/_knitr.qmd &gt;}}</code></pre></div>
```

That line then knows where to find the `webr` engine. If you forget this step, 
Quarto stops with *"Include directive failed"*. So if you get that error, you
know this step somehow didnt work. 

## Writing a cell

A live R cell is a `{webr}` block. That is the whole syntax — you write this:

```{=html}
<div class="sourceCode"><pre class="sourceCode markdown"><code class="sourceCode markdown">&#96;&#96;&#96;{webr}
#plot a sine 
plot(sin(seq(0, 4 * pi, 0.1)), type = 'l', lwd = 2, col = "#C00A35")
&#96;&#96;&#96;</code></pre></div>
```

…and your students get this:


::: {.cell}
```{webr}
# plot a since
plot(sin(seq(0, 4 * pi, 0.1)), type = 'l', lwd = 2, col = "#C00A35")

```
:::


## Cell options

Options go at the top of the cell, `#|` style, exactly like ordinary chunks —
the cell above uses `caption` and `min-lines`.

| Option | Effect |
|---|---|
| `autorun: true` | run once as the page loads, so the student sees output before touching anything |
| `edit: false` | show and run it, but do not let them change it |
| `runbutton: false` | no Run button — pair with `autorun` for a live demo |
| `startover: false` | remove the reset button |
| `persist: true` | remember the student's edits in their browser across reloads^[Note: if students delete their cache, they lose their edits!] |
| `min-lines`, `max-lines` | control the height of the editor box |
| `timelimit: 10` | seconds before a runaway loop is stopped (default 30) |
| `caption: "Try changing d"` | a title on the cell |
| `include: false` | run it invisibly — for setup code the student should not see |

: Live cell options. {#tbl-live-options}

Options change the cell quite a lot. This one is set to run itself on page
load and refuse edits — a live demonstration rather than an exercise:

```{=html}
<div class="sourceCode"><pre class="sourceCode markdown"><code class="sourceCode markdown">&#96;&#96;&#96;{webr}
#| autorun: true
#| edit: false
#| caption: Exponentiële versus logistische groei
&#96;&#96;&#96;</code></pre></div>
```


::: {.cell autorun='true' edit='false'}
```{webr}
#| autorun: true
#| edit: false
t <- 0:40
exponential <- 2 * exp(0.12 * t)
logistic    <- 100 / (1 + 49 * exp(-0.12 * t))

plot(t, logistic, type = 'l', lwd = 2, col = "#C00A35", ylim = c(0, 120),
     xlab = "tijd", ylab = "N")
lines(t, exponential, lwd = 2, lty = 2, col = "#001240")
legend("topleft", c("logistisch", "exponentieel"),
       col = c("#C00A35", "#001240"), lty = c(1, 2), lwd = 2, bty = "n")
```
:::


Notice there is no Run button and no editor -- it simply appeared. Compare it
with the cells at the top of the chapter, which have both.

::: {.callout-warning}
## Live cells only on a *server*. Once you published your book online everything
will work, but if you simply open your HTML file localy, the live code will grow
stale: the editor never initialises. 

To see live cells locally, start a server yourself. In the **Terminal** tab,
from the project folder:

```{=html}
<div class="sourceCode"><pre class="sourceCode bash"><code class="sourceCode bash">quarto preview</code></pre></div>
```

That builds the book, serves it at a `http://localhost:####` address, opens
your browser at it, and re-renders whenever you save. Stop it with
<kbd>Ctrl</kbd>+<kbd>C</kbd>.

If it opens inside RStudio's Viewer pane rather than a real browser, click the
*Show in new window* icon; the Viewer is a cut-down browser and WebAssembly
is exactly the sort of thing it is bad at.

Published to GitHub Pages the book is served over `https://`, so students never
notice any of this. Once it works, it works. 
:::

::: {.callout-tip}
## The setup-cell pattern
If you load data or libraries, put that in a separate cell in the top of your page 
with `include: false`. This carries between cells on the same page, so the student's
cell can then be three lines about the actual idea instead of fifteen lines of
extra boilerplate code.
:::

## Packages

Packages must be declared in the YAML so they are fetched when the page loads:

```{=html}
<div class="sourceCode"><pre class="sourceCode yaml"><code class="sourceCode yaml">webr:
  packages:
    - dplyr
    - ggplot2</code></pre></div>
```

::: {.callout-warning}
## Not every package exists in WebAssembly
An R package has to have been compiled for WebAssembly. Most of the common ones
are, at [repo.r-wasm.org](https://repo.r-wasm.org), and R-universe builds
WebAssembly versions automatically — add a `repos:` key to pull from one. But
anything wrapping compiled C or Fortran that nobody has ported will simply not
be there.

**Check the packages you need before you rewrite a practical around this.**
Python has the same limitation, with a different list (see @sec-webr-python).
Every live cell in this chapter uses only base R or the Python standard
library, deliberately.
:::

## The same trick for Python {#sec-webr-python}

There is nothing extra to install (unless you skipped the previous installation). 
That extension you already added ships **Pyodide**
— CPython compiled to WebAssembly — alongside webR, and the include line at the
top of this chapter registers both engines. Write `{pyodide}` instead of
`{webr}` and it simply works:

```{=html}
<div class="sourceCode"><pre class="sourceCode markdown"><code class="sourceCode markdown">&#96;&#96;&#96;{pyodide}
#| caption: Exponentiële groei
r, N = 0.12, 2.0
for t in range(10):
    print(f"t = {t:2d}   N = {N:6.2f}")
    N = N * (1 + r)
&#96;&#96;&#96;</code></pre></div>
```

Which gives you a Python editor, with its own Run Code button:


::: {.cell caption='Exponentiële groei'}
```{pyodide}
#| caption: Exponentiële groei
r, N = 0.12, 2.0
for t in range(10):
    print(f"t = {t:2d}   N = {N:6.2f}")
    N = N * (1 + r)
```
:::


Packages work the same way, under their own key:

```{=html}
<div class="sourceCode"><pre class="sourceCode yaml"><code class="sourceCode yaml">webr:
  packages: [dplyr, ggplot2]
pyodide:
  packages: [numpy, matplotlib]</code></pre></div>
```

Pyodide ships the scientific stack, and `micropip` can fetch pure-Python wheels
from PyPI. But some packages with compiled parts have never been built for
WebAssembly. Same caveat as R.

::: {.callout-warning}
## One page, two runtimes
This page now loads **both** webR and Pyodide, because it has cells of both
kinds. That is roughly double the first-load cost, and this chapter only does
it to show you that it works.

In a real course book, keep a page to one language unless you genuinely need
both. Where you do — an introductory course where half the room knows R and
half knows Python — a `::: {.panel-tabset}` with an R cell in one tab and a
Python cell in the other is the tidy way to do it. But there's plenty
of documentation online already, so good luck! :)
:::


## Does it work in the PDF?

Of course not. Like everything else in this part of the book, a live cell needs a
browser. Wrap it the way @sec-pdf describes: the live version inside
`::: {.content-visible when-format="html"}`, and for the PDF a plain
non-executing code block showing the same code, so the printed book still has
something to read.



---
editor: 
  markdown: 
    wrap: 72
---

# Writing applets with an AI assistant {#sec-ai}

I am a programmer myself, and I have made a lot of teaching material by programming little simulations and apps. But, this takes a lot of time.

With AI, not only can I personally make these materials much faster, but anyone should now be able to bring these kinds of things to the classroom.

The catch: you have to be very, very careful. AI tends to mix your message with general learnings from all over the globa, muddying up your material. It can write code, but it cannot check that material is correctly portraying your course content.

## Example applet

Below is an example (Dutch) applet made with the help of AI. While I could have
spend a few days making this myself, it saved me a bunch of time and students
did appreciate the extra effort (e.g. the animations) to clarify the mathematical
procedure. 


```{=html}
<iframe src="applets/linearisatie_eq.html" width="100%" height="950"
        style="border:none; border-radius:8px;">
</iframe>
```


## Tips for making apps with AI.

Here's a few common constraints that helped me writing good applets with AI. Note
that the example above does not follow all of these as it was made a while ago. But in
the future, I will follow my own tips and tricks:

- **Ask for a single, stand-alone `.html` file.** This prevents the AI from creating many files and loading modules externally from sources that may/may not be available in the future. No build steps, no weird compilation things, no students having to install anything. Just a file that can be opened in a browser.
- **Say the width is fluid and give the height.** Tell the AI where you will use the applet: "It will be embedded in an iframe at `width: 100%`, `height: 620px`. Use a responsive layout; nothing may overflow at that height, and the width must be fluid."
- **Ask answers/settings to be stored locally.** Local storage means that students will not lose their settings/answers if they close the browser or refresh the page. Without AI, I find this far too much programming, so I never used it. Now, I do use it. Note that this is not a privacy/security risk, as the data is stored on the student's own computer. However, if the student clears their cache, the data will be lost. For this, I sometimes offer an additional `Copy answers to clipboard` or `Download answers to PDF` option for students that want to keep their answers in a file.
- **Request both light/dark mode** Most modern operating systems have a global setting for either light or dark mode, and browsers can retrieve this information. So you can request to make the app automatically adjust.
- **Ask for it to repeat your request in a hidden comment** This way, your original suggestion (maybe reprased) will always remain visible, and it remains transparent that the app was made with the help of AI. We often request students to show when/if they used AI, so we should do the same.

:::: {.callout-caution collapse="true"}
## Example prompt

::: {style="font-family: \"Courier New"}
Write me a small interactive teaching applet as **one single, self-contained HTML file**, that teaches \[topic\] (below).

**Topic:** \[what it should show — e.g. "the sampling distribution of the mean: the student sets the population SD and the sample size n, draws many samples, and sees the distribution of sample means beside the population distribution"\]

**Controls:** \[which sliders or inputs, and their ranges\]

**Language of all labels:** \[English / Dutch / Multiple languages with a button\]

Hard requirements:

- One stand-alone HTML file.
- It will be embedded in an iframe at `width: 100%`, `height: 600px`. Use a responsive layout; nothing may overflow or scroll inside the frame.
- Support both light and dark mode via `prefers-color-scheme`.
- It must be readable at phone width.
- Put a comment at the very top stating **exactly what I asked and what you implemented**
- Keep it simple and readable (no weird compsci tricks), I need to be able to check it.
- (optional: it must work with no internet connection)

Start with the simplest version that works. I will ask for adjustments afterwards.
:::
::::

## What not to do

- Do not forget to be transparent about AI usage to students. We are asking students to be transparent about their use of AI, so we should be too.
- Do not use AI applets as part of evaluating/assessing students (e.g. in a quiz). While the UU policy on AI
is still under development, I think one can make a moral case that students deserve to be graded by humans.  
- Do not assume that an AI applet is always correct. Always verify the results and logic yourself.
- Do not assume students will/want need less physical contact with AI. Quite the opposite; on-site education is
becoming the more important to gatekeep against AI misuse!


# Rendering, and keeping it fast {#sec-rendering}

## Two buttons, two commands

**Rendering** is the act of building the whole project into a self-contained book (in folder `_book/`). 
In RStudio there is a `Render Book → All Formats` in the build tab (there is a keyboard shortcut for this,
Shift+Command+B on Mac, Shift+Ctrl+B on Windows). You can also render it from the terminal using the
command `quarto render`.

**Preview** starts a local server that re-renders on save and refreshes the
browser. In RStudio this is what *Render on Save* gives you; from a terminal it
is `quarto preview`.

You can often also simply open the html-files from your computer. The only thing
that will not work are the live webR cells, which need a real web server to work. For 
these, `quarto preview` is the way to go. 

## YML options `freeze` and `cache`

These options can be defined globally in the `_quarto.yml` file^[You can also override the global settings per file or per chunk.].

```yaml
execute:
  freeze: auto
  cache: false
```

These options solve slightly **different** problems, but the names aren't too clear about this so the distinction is worth clarifying:

### `freeze` is about *portability*
With `freeze: auto`, Quarto runs a chapter's code once, stores the results in a
`_freeze/` folder, and reuses them until that `.qmd` has been changed by you
or a colleague. If your chapters use packages that your colleague doesn't use,
freeze should still enable the other colleague to compile the entire book; the
files and the data are all stored in `_freeze/`.

`freeze: true` never re-renders a chapter, while `freeze: false` always re-render everything.

### `cache` is about code-chunks and *speed while writing*
`cache: true` avoids re-running a code whose code has not changed, so a slow 
simulation or data analysis does not re-run on every preview. This cache
lives in per-chapter `<CHAPTER_NAME>_cache/` folders.



::: {.callout-warning}
## Despite working most of the time, cached results can sometimes go stale
Both mechanisms trust the source text, not cannot know if anything external has changed. For example, 
if a chunk reads a data file and the *file* changes but the *code* does not, you will keep the old
result. You can simply delete the relevant `_freeze/` or `*_cache/` files, 
and re-render. 
:::



::: {.callout-tip}
## Render one chapter while drafting
`quarto preview 08-iframes.qmd` renders just that file. In RStudio, pressing
Render while a single `.qmd` is open does the same thing. Cross-references to
other chapters will not resolve in that preview — that is expected, and they
come back in a full render.
:::


# Putting it online {#sec-publishing}

Once it renders, your book is just a folder of static files. Any web server can
host it, including many free ones.

## Three routes

| Route | Effort | Good for |
|---|---|---|
| **GitHub Pages** | Set up once, then Commit + Push | A course book you will keep editing. Free, versioned, and a colleague can contribute. |
| **A UU server** | Ask your local support to host the folder | Something that must live under a `uu.nl` address. The BMS book is served this way. |
| **Your own server** | Reupload every time, or write your own automated script | A quick demo or a one-off hand-out. |

The rest of this chapter is the first option: the GitHub Pages route. 

## The idea

Your book folder becomes a *repository*: a folder that GitHub keeps a copy of.
You render the website into a subfolder called `docs`, send it to GitHub, and
tell GitHub to serve that folder as a website. Some of the steps below already
apply to this template, but you will need to do them again for your own book. 

## Step by step

**1. Point Quarto at `docs`.** In `_quarto.yml`:

```yaml
project:
  type: book
  output-dir: docs
```

Render once. The finished website now appears in `docs/`.

**2. Add a file called `.nojekyll`.** An empty file, inside `docs/`. 
GitHub runs its own processor over whatever folder it publishes, and that 
processor quietly drops directories whose names begin with an underscore,
which is most of what Quarto generates. This file switches it off.

In RStudio: <kbd>File</kbd> → <kbd>New File</kbd> → <kbd>Text File</kbd>, then
<kbd>Save As</kbd>, navigate **into `docs/`**, and give it exactly that name,
leading dot included^[Rstudio may complain, but ignore this and create the file]. 
Nothing appears in the Files pane afterwards (a leading
dot means hidden). It is there; *⚙* → *Show Hidden Files* will show it.

Note: rendering again does **not** remove this file, so this step only needs to happen once per book. 

**3. Make the folder a repository.** If you did not tick "Create a git
repository" when making the project: <kbd>Tools</kbd> → <kbd>Project Options</kbd>
→ <kbd>Git/SVN</kbd> → set version control to *Git*, and restart RStudio. A
**Git** tab appears next to Environment and History.

**4. Create the repository on GitHub and connect it.** Make a free account,
press <kbd>New repository</kbd>, give it a name, choose a public repository^[Note: this means your raw .qmd files are public, so if you wish to keep them private, choose a different route of publishing your website.]. Do not add anything
to the repository (no Readme, no gitignore). Then, you can either run a few terminal
commands to get your book uploaded^[Assuming git is installed, the commands would be `git remote add origin https://github.com/USERNAME/REPOSITORY.git`, 
`git branch -M main`, and `git push -u origin main`]. If you wish to avoid the scary terminal and the messiness of git, install [GitHub Desktop](https://desktop.github.com), choose *Add existing repository*, point it at your book folder, then press *Publish repository*. If 
you already added something (like a licence) upon making your repository, you may need to first *Fetch* and then *Publish*. If you get stuck,
AI does a great job debuggin you when you give it the error messages. 

**5. Send your work up.** From then on, in RStudio's **Git** tab or in GitHub
Desktop: tick the changed files, write a one-line message saying what you
changed, press <kbd>Commit</kbd>, then <kbd>Push</kbd>. Those three actions are
the whole of Git for this purpose, and all the setup above will no longer be 
necessary. 

**6. Switch the website on.** On github.com, in your repository:
<kbd>Settings</kbd> → <kbd>Pages</kbd> → under *Build and deployment*, set
Source to *Deploy from a branch*, choose your main branch, and set the folder to
**`/docs`**. Save.

![Settings to be configures on your Github repository](figures/github_pages.png){#fig-ghpages}


A few minutes later your book is live at `https://<your-username>.github.io/<repository-name>/`.
Note that it is also possible to make a separate Gibhub account for your website, 
and host is with a domain name like we have for some of our course books (e.g. `https://bioms-uu.github.io/`).
The workflow is similar, but you can only have 1 github account per email address, so you may need to 
create a new email address for this.

::: {.callout-tip}
## Now the workflow is simple:

Write on your chapters. Render book. Commit changed files. Push to github. 
The website updates automatically within a minute or two. 

:::


## Note that the Github repository has to be public

A GitHub Pages site is visible to anyone with the link to the repository. This
means that even files that you never added to the book (not listed in `_quarto.yml`),
are public too. 

::: {.callout-warning}

Keep exam questions, model answers you do not want found, and anything with
student data **out of the book folder entirely**. Not merely unlisted: out.
Answer chapters that are *meant* to be public are fine; the danger is the file
you forgot was in there.
:::

To help you out, note that the file `.gitignore` helps to keep generated and 
personal files out of the repository. A sensible starting point is shipped
with this book:

```
.Rproj.user/
.Rhistory
.RData
.DS_Store

/.quarto/
_book/
**/*.quarto_ipynb
**/*_cache/

*.aux
*.log
*.toc
```

Note that `_freeze/` is deliberately **not** ignored, as this can help you and 
your colleague not needing to re-render each others files. See @sec-rendering.


# When it breaks {#sec-trouble}

Quarto can break, or you are not yet used to the workflow. It's usually not too complicated to fix errors or mistakes. AI is really good
at handling the stuff you may encounter, but here's a list of things I have encountered:

| Symptom | Almost certainly |
|---|---|
| A chapter doesn't appear on the website | It isn't listed under `chapters:` in `_quarto.yml` — see @sec-yml |
| Render fails with a YAML error | Nearly always indentation. A tab where spaces belong, or one level too many |
| `?@fig-something` appears in the text | The label is missing its `fig-` prefix, or is spelled differently where it's defined — see @tbl-xref |
| A figure is missing | The path is relative to the chapter file, not to the top of the book |
| Raw `<iframe>` text appears on the page | The ```` ```{=html} ```` wrapper is missing |
| Render is painfully slow | Add `execute: freeze: auto`; render HTML only while drafting |
| A plot doesn't update after changing the data | Stale `_freeze/` or `*_cache/`. Delete them and re-render |
| The PDF / print has a blank gap | An interactive element not wrapped in `content-visible when-format="html"` |
| Custom LaTeX macros work in the PDF but not the browser | The `{{{< include _macros.tex >}}}` line is missing from that chapter |
| The website is stale after pushing | You rendered but didn't commit `docs/`, or Pages is pointed at the wrong folder |
| Render dies with "Jupyter is not available" | A chapter *shows* a `{webr}`/`{pyodide}` fence as an example. Add `engine: markdown` to that chapter's YAML header — see @sec-webr |
| Render says "Output created" but no preview window opens | Rstudio only auto-previews formats it recognises, and the live extension is not one of them. Run `quarto preview` in the Tetminal instead. If you don't usewlive webr chunks, you can also add `format: html` to the chapter's YAML header, and auto-previews should work. |
| Live cells appear but never become editors, and nothing runs | You opened the HTML file from disk, not from a local server. It will work fine when published online (e.g. on Github pages) |
| A `{webr}` cell renders as a dead code block | The `{{{< include ./_extensions/r-wasm/live/_knitr.qmd >}}}` line is missing from that chapter — see @sec-webr |
| A live cell says a package is not available | That package has no WebAssembly build. Check `repo.r-wasm.org` before rewriting a practical around it |

: An incomplete but probably useful troubleshooting list. {#tbl-trouble}

## Reading an error message

Quarto's errors usually name the file and the line. Two habits help:

- **Render one chapter at a time** when hunting a problem. A full book render
  buries the useful line in a hundred others. If you render only chapter 1, then 
  1 and 2, then 1 and 2 and 3, *etc.*, you will quickly find the chapter that is failing.
- **Look above the red text.** The actual cause is often the last thing Quarto
  said it was doing successfully, not the line where it finally gave up.
- **Give the red text to an AI tool** I found troubleshooting is one of the major strengths
of AI^[I use Claude code, which is exceptionally good at this, but others are decent at this as well]. 

## Other resources

- The [official Quarto documentation](https://quarto.org/docs/guide/) is
  genuinely good and searchable. The
  [authoring section](https://quarto.org/docs/authoring/) covers layout,
  callouts and cross-references; the
  [books section](https://quarto.org/docs/books/) covers structure.
- Start from the template starter book available [**here**](starter-book.zip) (.zip file)
- [Me](mailto:b.vandijk@uu.nl). Email me at any time if you have questions. 



# About this guide {.unnumbered}

This guide is written by Bram van Dijk in August/September 2026 as a means to transfer
knowledge about Quarto to colleagues at Utrecht University. In 2024, we received some help from the **facultair Utrechts Stimuleringsfonds Onderwijs** (fUSO, 2nd call 2024) to turn some old course material into a website, for which we remain very grateful. This website is my attempt
to return the favour. 

The theme tries to follow the [Utrecht University corporate identity](https://www.uu.nl/en/organisation/corporate-identity), 
but is not official. I just applied the correct fonts (Merriweather and Open Sans), the correct colours (UU red and UU yellow), 
and the logo. 


