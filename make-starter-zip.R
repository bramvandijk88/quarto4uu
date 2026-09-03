# Rebuild starter-book.zip from this project.
# Run it (Source, or Ctrl/Cmd-Shift-S) whenever you change the book, so the
# downloadable starter stays in step with what readers see.

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

skip <- c("^_book/", "^docs/", "^_site/", "^_freeze/", "^\\.quarto/", "^\\.git/",
          "^\\.Rproj\\.user/", "^_archive/", "^starter-book\\.zip$",
          "\\.DS_Store$", "^\\.RData$", "^\\.Rhistory$")

files <- list.files(".", recursive = TRUE, all.files = TRUE, no.. = TRUE)
files <- files[!Reduce(`|`, lapply(skip, function(p) grepl(p, files)))]

if (file.exists("starter-book.zip")) file.remove("starter-book.zip")
utils::zip("starter-book.zip", files)

cat("starter-book.zip rebuilt:", length(files), "files\n")
