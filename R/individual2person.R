#' Select the individual information to use as a `person` object
#'
#' This function retrieves the individual information using `select_individual()`
#' and converts it to a `person` object.
#' @param role The role to use for the `person` object.
#' Defaults to `"aut"`` (author).
#' @param lang The language to use for the affiliation.
#' @importFrom utils person
#' @export
#' @family individual
individual2person <- function(individual, role = "aut", lang) {
  if (missing(individual)) {
    individual <- select_individual(lang = lang)
  }
  if (is.na(individual$email) || individual$email == "") {
    email <- NULL
  } else {
    email <- individual$email
  }
  if (is.na(individual$orcid) || individual$orcid == "") {
    comment <- character(0)
  } else {
    comment <- c(ORCID = individual$orcid)
  }
  if (!is.na(individual$affiliation) && individual$affiliation != "") {
    comment <- c(comment, affiliation = individual$affiliation)
  }
  if (length(comment) == 0) {
    comment <- NULL
  }
  person(
    given = individual$given,
    family = individual$family,
    email = email,
    comment = comment,
    role = role
  )
}
