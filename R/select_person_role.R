#' Select the person object with a given role
#' @param individual A `person` object.
#' @param role A character vector of roles to check for.
#' @return A logical vector indicating whether the individual has any of the
#' specified roles.
#' @export
#' @family individual
#' @importFrom utils person
select_person_role <- function(individual, role) {
  has_person_role(individual = individual, role = role) |>
    which() -> matches
  if (length(matches) == 0) {
    return(person())
  }
  individual[matches]
}
