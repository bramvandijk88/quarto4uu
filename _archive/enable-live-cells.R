# Turn the two demos in chapter 09 into REAL runnable webR cells.
#
#   Source this file (Ctrl/Cmd-Shift-S), then Render.
#   disable-live-cells.R puts everything back, exactly.
#
# Three steps:
#   1. install the quarto-live extension (needs internet, once per project)
#   2. switch the html format to live-html in _quarto.yml
#   3. turn the shown-only demos in 09-runnable-code.qmd into live cells

if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable())
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

CHAPTER <- "09-runnable-code.qmd"

live1 <- '```{webr}
for (x in 1:5) {
  print(10 + x)
}
```
'

live2 <- '```{webr}
#| caption: Paracetamol in de bloedbaan
#| min-lines: 12
p <- 400          # hoeveelheid paracetamol
d <- 0.7          # afname (d van decay)

for (i in 1:100) {
  if (runif(1) < 0.1) {   # nieuwe pil met kans 0.1
    p[i] <- p[i] + 400
  }
  p[i+1] <- p[i] * d
}

plot(p, type = \'l\', lwd = 2, col = "#C00A35",
     xlab = "Tijd (uren)", ylab = "Paracetamol (mg)")
```
'

swap <- function(lines, tag, replacement) {
  a <- grep(paste0("^<!-- ", tag, "-START -->"), lines)
  b <- grep(paste0("^<!-- ", tag, "-END -->"), lines)
  if (length(a) != 1 || length(b) != 1)
    stop("Could not find the ", tag, " markers in ", CHAPTER, call. = FALSE)
  c(lines[seq_len(a)], strsplit(replacement, "\n", fixed = TRUE)[[1]], lines[b:length(lines)])
}

## 1 -- the extension ---------------------------------------------------------
inc <- "_extensions/r-wasm/live/_knitr.qmd"
if (!file.exists(inc)) {
  message("Installing the quarto-live extension...")
  try(system2("quarto", c("add", "r-wasm/quarto-live", "--no-prompt")), silent = TRUE)
  if (!file.exists(inc))
    stop("Could not install the extension. Run this in the Terminal tab and read\n",
         "what it says:\n\n    quarto add r-wasm/quarto-live\n\n",
         "Nothing has been changed, so the book still renders.", call. = FALSE)
}
message("Extension present.")

## 2 -- _quarto.yml -----------------------------------------------------------
yml <- readLines("_quarto.yml", warn = FALSE)
i <- grep("^  html:\\s*$", yml)
if (length(i) == 1) {
  yml[i] <- "  live-html:"
  writeLines(yml, "_quarto.yml")
  message("_quarto.yml: html -> live-html")
} else if (any(grepl("^  live-html:", yml))) {
  message("_quarto.yml already set to live-html.")
} else {
  stop("Could not find the `  html:` line in _quarto.yml.", call. = FALSE)
}

## 3 -- the chapter -----------------------------------------------------------
qmd <- readLines(CHAPTER, warn = FALSE)
qmd <- swap(qmd, "DEMO1", live1)
qmd <- swap(qmd, "DEMO2", live2)
qmd <- sub("^engine: markdown$", "engine: knitr", qmd)

if (!any(grepl("_knitr.qmd >}}", qmd, fixed = TRUE))) {
  end_yaml <- grep("^---\\s*$", qmd)[2]
  qmd <- append(qmd, c("", "{{< include ./_extensions/r-wasm/live/_knitr.qmd >}}"),
                after = end_yaml)
}
writeLines(qmd, CHAPTER)

message("\nDone -- two live cells in chapter 9. Press Render.\n",
        "If anything goes wrong, Source disable-live-cells.R to undo it.")
