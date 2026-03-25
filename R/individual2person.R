#' Select the individual information to use as a `person` object
#'
#' This function retrieves the individual information using `use_individual()`
#' and converts it to a `person` object.
#' @param role The role to use for the `person` object.
#' Defaults to `"aut"`` (author).
#' @param lang The language to use for the affiliation.
#' @importFrom utils person
#' @export
#' @family individual
individual2person <- function(role = "aut", lang) {
  df <- use_individual(lang = lang)
  if (is.na(df$email) || df$email == "") {
    email <- NULL
  } else {
    email <- df$email
  }
  if (is.na(df$orcid) || df$orcid == "") {
    comment <- character(0)
  } else {
    comment <- c(ORCID = df$orcid)
  }
  if (!is.na(df$affiliation) && df$affiliation != "") {
    comment <- c(comment, affiliation = df$affiliation)
  }
  if (length(comment) == 0) {
    comment <- NULL
  }
  person(
    given = df$given,
    family = df$family,
    email = email,
    comment = comment,
    role = role
  )
}
