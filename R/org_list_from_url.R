#' Get the default organisation list from a git URL
#' This function retrieves the default organisation list from a git URL.
#' It checks if the organisation list is already cached in the user's R
#' configuration.
#' If it is, it returns the cached version.
#' If not, it attempts to retrieve the organisation list from the specified git
#' URL and caches it for future use.
#' @param git The git URL to retrieve the organisation list from.
#' @return An `org_list` object containing the organisation list.
#' @importFrom tools R_user_dir
#' @importFrom utils file_test
#' @export
#' @family organisation
org_list_from_url <- function(git) {
  ssh_http(git) |>
    gsub(pattern = "https://", replacement = "") |>
    tolower() -> config_name
  config_folder <- R_user_dir("citeme", "config")
  path(config_folder, config_name) -> config_path
  if (file_test("-d", config_path)) {
    return(org_list$new()$read(config_path))
  }
  org <- cache_org(url = ssh_http(git), config_folder = config_folder)
  if (!is.null(org) || !interactive()) {
    return(org)
  }
  return(new_org_list(git = git))
}
