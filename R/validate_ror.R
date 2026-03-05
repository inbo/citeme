#' Validate ROR
#' The Research Organization Registry ([ROR](https://ror.org/)) is a global,
#' community-led registry of open persistent identifiers for research
#' organizations.
#' ROR makes it easy for anyone or any system to disambiguate institution names
#' and connect research organizations to researchers and research outputs.
#' Validate that a ROR is a string of 9 characters starting with 0, followed by
#' 6 characters which can be a letter (except i, l, o) or a digit, and ending
#' with 2 digits.
#' @param ror A ROR to validate.
#' @return A logical value indicating whether the ROR is valid.
#' @export
#' @family validation
validate_ror <- function(ror) {
  stopifnot(
    "`ror` must be a string" = is.character(ror),
    "`ror` must be a string" = length(ror) == 1,
    "`ror` cannot be NA" = !is.na(ror)
  )
  grepl(
    "^0[a-hj-km-np-tv-z|0-9]{6}[0-9]{2}$",
    ror,
    perl = TRUE
  )
}
