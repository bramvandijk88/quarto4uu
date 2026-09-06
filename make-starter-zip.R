# Rebuild starter-book.zip from this project.
# Run it (Source, or Ctrl/Cmd-Shift-S) whenever you change the book, so the
# downloadable starter stays in step with what readers see.
#
# Opening the .Rproj already puts the working directory at the project root,
# so this checks it is in the right place rather than depending on rstudioapi
# -- one less package to install, and the script then also runs from the
# terminal with `Rscript make-starter-zip.R`.

if (!file.exists("_quarto.yml")) {
  stop("Run this from the project root -- open the .Rproj first.\n",
       "  Working directory is currently: ", getwd())
}

# What never belongs in the starter: build output, caches, personal files,
# the archive, and this script itself. The _book/_site patterns are loose
# enough to catch the " 2" copies that Dropbox and macOS leave behind.
skip <- c("^_book[^/]*/", "^_site[^/]*/", "^docs/", "^_freeze/",
          "^site_libs/", "^\\.quarto/", "^\\.git/", "^\\.Rproj\\.user/",
          "^_archive/", "^starter-book\\.zip$", "^make-starter-zip\\.R$",
          "\\.Rproj$", "\\.DS_Store$", "^\\.RData$", "^\\.Rhistory$")

files <- list.files(".", recursive = TRUE, all.files = TRUE, no.. = TRUE)
files <- files[!Reduce(`|`, lapply(skip, function(p) grepl(p, files)))]

# Stage everything under a starter-book/ folder before zipping, so the
# archive unpacks into one named folder instead of scattering a hundred
# files into whatever directory the reader happens to be sitting in.
stage <- file.path(tempdir(), "starter-book-stage")
unlink(stage, recursive = TRUE)
for (f in files) {
  dest <- file.path(stage, "starter-book", f)
  dir.create(dirname(dest), recursive = TRUE, showWarnings = FALSE)
  file.copy(f, dest)
}

if (file.exists("starter-book.zip")) invisible(file.remove("starter-book.zip"))
zipfile <- file.path(getwd(), "starter-book.zip")

owd <- getwd()
on.exit(setwd(owd), add = TRUE)
setwd(stage)
utils::zip(zipfile, "starter-book", flags = "-rq")
setwd(owd)

cat("starter-book.zip rebuilt:", length(files), "files\n")
