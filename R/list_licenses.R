list_licenses <- function(
  items,
  email = character(0),
  type = c("package", "project", "data", "all")
) {
  type <- match.arg(type)
  if (is.null(email) || length(email) == 0) {
    email <- names(items)
  }
  stopifnot(
    inherits(email, "character"),
    "`email` must not contain NA values" = all(!is.na(email))
  )
  vapply(
    items,
    FUN.VALUE = vector(mode = "list", 1),
    type = type,
    FUN = function(x, type) {
      list(x$get_license(type = type))
    }
  ) |>
    unname() -> licenses
  licenses <- licenses[lengths(licenses) > 0]
  stopifnot(
    "multiple rightholders with license requirements not yet handled" = length(
      licenses
    ) <=
      1
  )
  return(unlist(licenses))
}
