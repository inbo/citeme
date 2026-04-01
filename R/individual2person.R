#' Select the individual information to use as a `person` object
#'
#' This function retrieves the individual information using
#' `select_individual()` and converts it to a `person` object.
#' If the `individual` argument is not provided, it will prompt the user to
#' select an individual.
#' The `person` object will include the given name, family name, email, ORCID,
#' and affiliation (if available) of the selected individual.
#' @param individual An optional `individual` object to convert to a `person`
#' object.
#' If not provided, the function will prompt the user to select an individual.
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
