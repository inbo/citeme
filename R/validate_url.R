#' Validate URL
#' Validate that a URL is a string of length 1 which is not NA and matches the
#' pattern of a valid URL.
#' @param url A URL to validate.
#' @return A logical value indicating whether the URL is valid.
#' @export
#' @family validation
validate_url <- function(url) {
  stopifnot(
    "`url` must be a string" = inherits(url, "character"),
    "`url` must have length 1" = length(url) == 1,
    "`url` cannot be NA" = !is.na(url)
  )
  grepl(
    "^https?://[a-z0-9-]+(\\.[a-z0-9-]+)+(:[0-9]+)?(/.*)?$",
    url,
    perl = TRUE
  )
}
