#' Ask one or more licenses.
#' @param licenses A named vector of available licenses.
#'   The vector contains the URL to the markdown version of the license.
#'   Use the abbreviation of the license name as names.
#' @param type The type of license.
#'   Must be one of `"package"`, `"project"` or `"data"`.
#' @return A named character vector where each element is a URL to the
#' markdown version of the license and each name is the license abbreviation.
#' Returns an empty character vector when no license is selected.
#' @export
#' @family question
#' @examples
#' \dontrun{
#' ask_new_license(
#'   c("MIT" = "https://example.com/mit.md"),
#'   type = "package"
#' )
#' }
ask_new_license <- function(licenses, type = c("package", "project", "data")) {
  type <- match.arg(type)
  license <- character(0)
  repeat {
    license_choices <- c(names(licenses), "Other license", "No license")
    license_selected <- menu_first(
      choices = license_choices,
      title = sprintf("Select a %s license", type)
    )
    if (license_selected == length(licenses) + 2) {
      break
    }
    if (license_selected <= length(licenses)) {
      license <- c(license, licenses[license_selected])
      licenses <- licenses[-license_selected]
    } else {
      sprintf("Enter the %s license abbrevation: ", type) |>
        readline() -> short
      sprintf(
        "Enter the URL for a markdown version of the %s license: ",
        type
      ) |>
        readline() -> url
      names(url) <- short
      license <- c(license, url)
    }
    if (
      !ask_yes_no(sprintf("Add another a %s license", type), default = FALSE)
    ) {
      break
    }
  }
  return(license)
}
