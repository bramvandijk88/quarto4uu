# Making a course book with Quarto

A guide for teachers at Utrecht University on building a course book as a
website with Quarto and RStudio — and, at the same time, the starter book you
copy to make your own. There is only this: the guide and the starter book are
the same project.

Every chapter demonstrates the thing it describes: the figures are real
figures, the applet really runs, the maths really renders.

## What you need

R, RStudio and Quarto — plus the `quarto-live` extension, which is already in
`_extensions/` and travels with this folder. Nothing to install.

Chapter 9 has two **live** R cells: students edit the code and press Run, and
it executes in their browser. If the `_extensions/` folder ever goes missing,
restore it from the project folder with:

```
quarto add r-wasm/quarto-live
```

run in the Terminal **from inside the project directory** — `quarto add`
installs wherever the terminal happens to be, which is the usual way this goes
wrong. Chapter 9 also explains how to switch live cells off again if you would
rather not depend on the extension at all.

## To use it as a starting point

1. Unzip / copy this folder and **rename it** to your course.
2. In RStudio: **File → New Project… → Existing Directory** → pick that folder
   → **Create Project**. RStudio writes an `.Rproj` file and opens it; nothing
   else in the folder changes.
3. Press **Render**.
4. Edit `_quarto.yml` (title, author, chapter list), then replace our chapters
   with yours.

## What is here

| File | What it is |
|---|---|
| `_quarto.yml` | the book definition — chapters, theme, output folder |
| `uu.scss` | Utrecht University house style, commented and copyable |
| `index.qmd`, `01-…` … `13-…`, `about.qmd` | the chapters |
| `figures/` | images, including the UU logo and favicon |
| `applets/` | self-contained interactive HTML, plus an AI prompt template |
| `make-starter-zip.R` | rebuilds `starter-book.zip` after you change the book |
| `_extensions/` | the quarto-live extension — keep it, and commit it to Git |
| `.gitignore` | keeps build output and personal files out of Git |

Delete every `::: {.screenshot}` block once the real images are in place —
they are drafting markers.

## House style

Colours and fonts follow the
[UU corporate identity](https://www.uu.nl/en/organisation/corporate-identity):
Merriweather and Open Sans, UU red for links, UU yellow as the accent. The book
is deliberately single-theme, because the UU palette is defined against white
paper.
