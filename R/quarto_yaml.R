#' @importFrom utils file_test
#' @importFrom yaml read_yaml
quarto_yaml <- function(path) {
  stopifnot("`path` is not an existing file" = file_test("-f", path))
  if (basename(path) == "_quarto.yml") {
    return(read_yaml(path))
  }
  stopifnot(
    "please install the 'rmarkdown' package" = requireNamespace(
      "rmarkdown",
      quietly = TRUE
    )
  )
  rmarkdown::yaml_front_matter(path)
}
