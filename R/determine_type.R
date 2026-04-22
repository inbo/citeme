#' @importFrom stats setNames
#' @importFrom utils file_test head
determine_type <- function(path = ".") {
  stopifnot(
    "`path` must be a single string" = length(path) == 1,
    "`path` must be a single string" = inherits(path, "character"),
    "`path` must be a single string" = !is.na(path),
    "`path` does not exist" = file.exists(path)
  )
  # handle existing file
  if (file_test("-d", path)) {
    path <- list.files(path, full.names = TRUE)
  }
  c(
    "_quarto.yml"["_quarto.yml" %in% basename(path)],
    "index.qmd"["index.qmd" %in% basename(path)],
    "index.Rmd"["index.Rmd" %in% basename(path)],
    "index.md"["index.md" %in% basename(path)],
    "quarto.qmd"[length(path) == 1 && grepl(".qmd$", basename(path))],
    "DESCRIPTION"["DESCRIPTION" %in% basename(path)],
    "README.Rmd"["README.Rmd" %in% basename(path)],
    "README.md"["README.md" %in% basename(path)]
  ) |>
    head(1) -> type
  stopifnot("no supported file found in `path`" = length(type) == 1)
  if (type == "quarto.qmd") {
    return(c(quarto = path))
  }
  dirname(path[1]) |>
    file.path(type) |>
    setNames(
      c(
        `_quarto.yml` = "quarto",
        `index.qmd` = "quarto",
        `index.Rmd` = "quarto",
        `index.md` = "quarto",
        `DESCRIPTION` = "description",
        `README.Rmd` = "readme",
        `README.md` = "readme"
      )[type]
    )
}
