#' Validate language code
#'
#' A valid language code is a string in the format of `xx-YY`, where `xx` is a
#' two-letter lowercase language code and `YY` is a two-letter uppercase
#' country code.
#' For example, `en-GB` for English (United Kingdom) and `nl-BE` for Dutch
#' (Belgium).
#' @param language A string to validate
#' @return The input language code if it is valid, otherwise an error message.
#' @export
#' @importFrom assertthat assert_that is.string noNA
#' @family validation
validate_language <- function(language) {
  assert_that(is.string(language), noNA(language))
  assert_that(
    grepl("[a-z]{2}-[A-Z]{2}", language),
    msg = "`language` must be in xx-YY format. e.g. 'en-GB', 'nl-BE'"
  )
  return(language)
}
