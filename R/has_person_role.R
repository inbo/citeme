#' Does a person object has a given role?
#' @param individual A `person` object.
#' @param role A character vector of roles to check for.
#' @return A logical vector indicating whether the individual has any of the
#' specified roles.
#' @export
#' @family individual
has_person_role <- function(individual, role) {
  stopifnot(
    "`individual` must be a `person` object" = inherits(individual, "person"),
    "`role` must be a character vector" = is.character(role),
    "`role` must have length greater than 0" = length(role) > 0L
  )
  if (length(individual) > 1L) {
    vapply(
      individual,
      FUN = has_person_role,
      FUN.VALUE = logical(1),
      role = role
    )
  }
  any(role %in% individual$role)
}
