#' Validate a license list
#' @param license A list with three named character vectors: `package`,
#' `project`, and `data`.
#' Each vector should contain unique license names as values and unique
#' package, project, or data names as names.
#' @return Invisibly returns `NULL` if the license list is valid, otherwise
#' throws an error.
#' @export
#' @family validation
#' @examples
#' validate_license_list(list(
#'   package = c("MIT" = "https://example.com/mit.md"),
#'   project = c("CC-BY-4.0" = "https://example.com/cc-by.md"),
#'   data = c("CC0-1.0" = "https://example.com/cc0.md")
#' ))
validate_license_list <- function(license) {
  stopifnot(
    "`license` must be a list" = inherits(license, "list"),
    "`license` must contain \`package\`, \`project\`, and \`data\`" = all(
      c("package", "project", "data") %in% names(license)
    ),
    "`license` must contain character vectors" = all(
      vapply(license, is.character, FUN.VALUE = logical(1))
    ),
    "`license` must contain named vectors" = all(
      vapply(
        license,
        function(x) {
          length(x) == 0 || (!is.null(names(x)) && all(names(x) != ""))
        },
        FUN.VALUE = logical(1)
      )
    ),
    "`license` must contain uniquely named vectors" = all(
      vapply(
        license,
        function(x) {
          length(x) == 0 || anyDuplicated(names(x)) == 0
        },
        FUN.VALUE = logical(1)
      )
    ),
    "`license` must contain vectors with unique licenses" = all(
      vapply(
        license,
        function(x) {
          length(x) == 0 || anyDuplicated(x) == 0
        },
        FUN.VALUE = logical(1)
      )
    )
  )
}
