#' Check if a vector contains valid email
#'
#' It only checks the format of the text, not if the email address exists.
#' @param email A vector with email addresses.
#' @return A logical vector.
#' @export
#' @family validation
validate_email <- function(email) {
  stopifnot("`email` must be a character vector" = inherits(email, "character"))
  # expression taken from https://emailregex.com/
  grepl(
    paste0(
      "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"",
      "(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|",
      "\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*",
      "[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|",
      "2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9]",
      "[0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a",
      "\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\\])"
    ),
    tolower(email)
  )
}
