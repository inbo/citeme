#' Get the default organization list
#'
#' This function retrieves the default organisation list from the
#' `organisation.yml` file in the organisations `citeme` repository.
#' The `origin` of the repository is used to determine the root URL of the
#' organisation.
#' @param x The path to the repository.
#' Defaults to the current working directory.
#' @return An `org_list` object containing the organisation list.
#' The function also stores the information in the user's R configuration.
#' @export
#' @family organisation
#' @importFrom gert git_remote_list
get_default_org_list <- function(x = ".") {
  stopifnot(is_repository(x))
  remotes <- git_remote_list(repo = x)
  stopifnot("no git remote `origin` found" = any(remotes$name == "origin"))
  url <- ssh_http(remotes$url[remotes$name == "origin"])
  org <- cache_org(url, config_folder = R_user_dir("citeme", "config"))
  if (!is.null(org)) {
    return(org)
  }
  if (file.exists(file.path(x, "organisation.yml"))) {
    return(org_list$new()$read(x))
  }
  return(org_list$new(org_item$new(email = "info@inbo.be"), git = url))
}
