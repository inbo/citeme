git_org <- function(x = ".") {
  if (!is_repository(x)) {
    return(local_git_org(x))
  }
  remotes <- git_remote_list(repo = x)
  if (all(remotes$name != "origin")) {
    warning(paste(
      "No git remote `origin` found.",
      "Using the local `organisation.yml` file if available."
    ))
    return(local_git_org(x))
  }

  url <- ssh_http(remotes$url[remotes$name == "origin"])
  if (!grepl("^https://", url, perl = TRUE)) {
    return(local_git_org(x))
  }
  if (url == "https://github.com/inbo") {
    return(inbo_org_list())
  }
  gsub("https://", "", url) |>
    tolower() -> config_name
  R_user_dir("citeme", "config") |>
    file.path(config_name, fsep = "/") -> config_path
  if (file.exists(file.path(config_path, "organisation.yml", fsep = "/"))) {
    org <- org_list$new()$read(config_path)
    org$write(x)
    return(org)
  }

  message(
    "no local `org_list` information found. ",
    "See ?get_default_org_list. ",
    "\nYou can ignore this message when ",
    url,
    "/citeme doesn't exists."
  )
  local_git_org(x)
}
