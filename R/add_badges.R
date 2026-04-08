#' add badges to a README
#'
#' - `doi`: add a DOI badge
#' - `language`: add a language badge
#' - `license`: add a license badge
#' - `url`: add a website badge
#' - `version`: add a version badge
#' @param readme_path Directory containing the `README.md` or `README.Rmd` file.
#' @param ... Additional arguments
#' @importFrom assertthat assert_that
#' @export
#' @family utils
#' @examples
#' \dontrun{
#'   add_badges(url = "https://www.inbo.be")
#'   add_badges(doi = "10.5281/zenodo.8063503")
#'   add_badges(version = "v0.1.2")
#'   add_badges(url = "https://www.inbo.be", doi = "10.5281/zenodo.8063503")
#' }
add_badges <- function(readme_path = ".", ...) {
  stopifnot(
    inherits(readme_path, "character"),
    length(readme_path) == 1,
    dir.exists(readme_path)
  )
  list.files(readme_path, pattern = "README.R?md$", full.names = TRUE) |>
    sort() |>
    tail(1) -> readme
  assert_that(length(readme) == 1, msg = "No README.md or README.Rmd found")
  text <- readLines(readme)
  badges_start <- grep("<!-- badges: start -->", text)
  assert_that(
    length(badges_start) == 1,
    msg = "Problematic badge delimiters in README"
  )
  dots <- list(...)
  if ("language" %in% names(dots)) {
    dots$language <- validate_language(dots$language[1])
    dots$language <- c(dots$language, gsub("-", "--", dots$language))
  }
  if ("license" %in% names(dots)) {
    org <- org_list$new()$read(readme_path)
    dots$license <- c(
      dots$license,
      gsub("-", "_", dots$license),
      license_local_remote(org$get_listed_licenses[dots$license])$remote_file
    )
  }
  # fmt: skip
  formats <- c(
    doi = paste0(
      "[![DOI](https://zenodo.org/badge/DOI/%1$s.svg)]",
      "(https://doi.org/%1$s)"
    ),
    language =
      "![Language: %1$s](https://img.shields.io/badge/language-%2$s-c04384)",
    license =
      "[![%1$s](https://img.shields.io/badge/License-%2$s-brightgreen)](%3$s)",
    url =
      "[![website](https://img.shields.io/badge/website-%1$s-c04384)](%1$s)",
    version =
      "[![version](https://img.shields.io/badge/version-%1$s-c04384)(%1$s)]"
  )
  dots <- dots[names(dots) %in% names(formats)]
  formats <- formats[names(dots)]
  vapply(
    names(dots),
    FUN.VALUE = character(1),
    formats = formats,
    dots = dots,
    FUN = function(i, formats, dots) {
      list(fmt = formats[i]) |>
        c(dots[[i]]) |>
        do.call(what = sprintf)
    }
  ) -> new_badge
  head(text, badges_start) |>
    c(new_badge, tail(text, -badges_start)) |>
    writeLines(readme)
}
