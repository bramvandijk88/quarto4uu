# Undo enable-live-cells.R: plain html, demos shown but not run, so the book
# renders with nothing installed. (_extensions is left alone.)

if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable())
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

CHAPTER <- "09-runnable-code.qmd"
open_pre  <- '```{=html}\n<div class="sourceCode"><pre class="sourceCode markdown"><code class="sourceCode markdown">'
close_pre <- '</code></pre></div>\n```\n'
bt <- '&#96;&#96;&#96;'

shown1 <- paste0(open_pre, bt, '{webr}\n',
'for (x in 1:5) {\n',
'  print(10 + x)\n',
'}\n', bt, close_pre)

shown2 <- paste0(open_pre, bt, '{webr}\n',
'#| caption: Paracetamol in de bloedbaan\n',
'#| min-lines: 12\n',
'p &lt;- 400          # hoeveelheid paracetamol\n',
'd &lt;- 0.7          # afname (d van decay)\n',
'\n',
'for (i in 1:100) {\n',
'  if (runif(1) &lt; 0.1) {   # nieuwe pil met kans 0.1\n',
'    p[i] &lt;- p[i] + 400\n',
'  }\n',
'  p[i+1] &lt;- p[i] * d\n',
'}\n',
'\n',
'plot(p, type = \'l\', lwd = 2, col = "#C00A35",\n',
'     xlab = "Tijd (uren)", ylab = "Paracetamol (mg)")\n', bt, close_pre)

swap <- function(lines, tag, replacement) {
  a <- grep(paste0("^<!-- ", tag, "-START -->"), lines)
  b <- grep(paste0("^<!-- ", tag, "-END -->"), lines)
  if (length(a) != 1 || length(b) != 1)
    stop("Could not find the ", tag, " markers in ", CHAPTER, call. = FALSE)
  c(lines[seq_len(a)], strsplit(replacement, "\n", fixed = TRUE)[[1]], lines[b:length(lines)])
}

yml <- readLines("_quarto.yml", warn = FALSE)
writeLines(sub("^  live-html:\\s*$", "  html:", yml), "_quarto.yml")

qmd <- readLines(CHAPTER, warn = FALSE)
qmd <- swap(qmd, "DEMO1", shown1)
qmd <- swap(qmd, "DEMO2", shown2)
qmd <- sub("^engine: knitr$", "engine: markdown", qmd)
qmd <- qmd[!grepl("_knitr.qmd >}}", qmd, fixed = TRUE)]

# collapse the blank line the include left behind, so repeated toggling does
# not slowly grow a stack of empty lines under the YAML header
end_yaml <- grep("^---\\s*$", qmd)[2]
while (!is.na(end_yaml) && qmd[end_yaml + 1] == "" && qmd[end_yaml + 2] == "")
  qmd <- qmd[-(end_yaml + 1)]

writeLines(qmd, CHAPTER)
message("Back to plain html. Press Render.")
