#' Cache organisation list from URL
#'
#' This function retrieves the organisation list from a given URL and caches it
#' locally.
#' If the URL is `"https://github.com/inbo"`, it uses the default INBO
#' organisation list.
#' For other URLs, it checks if a public `citeme` repository exists and clones
#' it to retrieve the organisation list.
#' The cached organisation list is stored in a specified configuration folder.
#' @param url The URL of the organisation list to retrieve.
#' @param config_folder The folder where the cached organisation list should be
#' stored.
#' Defaults to the user's R configuration directory for `citeme`.
#' @return The retrieved organisation list, or `NULL` if the URL is invalid or
#' the repository.
#' @importFrom httr HEAD
#' @importFrom tools R_user_dir
#' @importFrom utils installed.packages
#' @export
#' @family organisation
cache_org <- function(url, config_folder = R_user_dir("citeme", "config")) {
  gsub("https://", "", url) |>
    tolower() -> config_name
  config_path <- file.path(config_folder, config_name)
  if (url == "https://github.com/inbo") {
    file.path(config_path, "pkgdown") |>
      dir.create(showWarnings = FALSE, recursive = TRUE)
    org <- inbo_org_list()
    org$write(config_path, license = TRUE)
    if ("checklist" %in% rownames(installed.packages())) {
      system.file("package_template/pkgdown.css", package = "checklist") |>
        file.copy(to = file.path(config_path, "pkgdown.css"), overwrite = TRUE)
      img_files <- c(
        "flanders.woff",
        "flanders.woff2",
        "logo-en.png",
        "background-pattern.png"
      )
      file.path("package_template", img_files) |>
        system.file(package = "checklist") |>
        file.copy(to = file.path(config_path, "pkgdown"), overwrite = TRUE)
    }
    return(org)
  }
  paste0(url, "/citeme") |>
    HEAD() -> url_head
  if (url_head$status_code != 200) {
    paste0(url, "/checklist") |>
      HEAD() -> url_head
    if (url_head$status_code != 200) {
      warning(
        sprintf("no public `citeme` repo found at %s", url),
        immediate. = TRUE,
        call. = FALSE
      )
      return(invisible(NULL))
    }
    warning(
      sprintf("using old style public `checklist` repo from %s", url),
      immediate. = TRUE,
      call. = FALSE
    )
  }
  target <- tempfile("citeme-organisation")
  c(
    "clone",
    "--single-branch",
    "--branch=main",
    "--depth=1",
    paste0(url, "/citeme"),
    target
  ) |>
    system2(command = "git", stderr = FALSE, stdout = FALSE)
  to_do <- list.files(target, recursive = TRUE)
  dirname(to_do) |>
    unique() -> dirs
  file.path(config_path, dirs[dirs != "."]) |>
    dir.create(showWarnings = FALSE, recursive = TRUE)
  file.path(target, to_do) |>
    file.copy(to = file.path(config_path, to_do))
  org <- org_list$new()$read(target)
  org$write(config_path, license = TRUE)
  return(org)
}
