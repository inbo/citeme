#' Select a license for a project, package or dataset
#'
#' This function allows you to select a license for a project, package or
#' dataset from the list of allowed licenses for the organisation.
#' If there is only one license available, it will be selected automatically.
#' @param org An object of class `org_list` created with `new_org_list()` or
#' `org_list$new()`.
#' @param type The type of license to select. One of `"package"`, `"project"`,
#' or `"data"`.
#' Default is `"package"`.
#' @return The name of the selected license.
#' @export
#' @family organisation
select_license <- function(org, type = c("package", "project", "data")) {
  stopifnot("`org` must be of class `org_list`" = inherits(org, "org_list"))
  type <- match.arg(type)
  org$get_default_rightsholder |>
    org$get_allowed_licenses(type = type) -> allowed
  stopifnot("no licenses found for this organisation" = length(allowed) > 0)
  if (length(allowed) > 1) {
    allowed <- allowed[menu_first(
      choices = names(allowed),
      title = "Select the license you want to use:"
    )]
  }
  return(names(allowed))
}
