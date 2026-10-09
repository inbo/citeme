#' Select the person object with a given role
#' @param individual A `person` object.
#' @param role A character vector of roles to check for.
#' @return A logical vector indicating whether the individual has any of the
#' specified roles.
#' @export
#' @family individual
#' @importFrom utils person
#' @examples
#' p <- c(
#'   person("Jane", "Doe", role = "aut"),
#'   person("John", "Smith", role = c("aut", "cre"))
#' )
#' select_person_role(p, "cre")
select_person_role <- function(individual, role) {
  has_person_role(individual = individual, role = role) |>
    which() -> matches
  if (length(matches) == 0) {
    return(person())
  }
  individual[matches]
}
