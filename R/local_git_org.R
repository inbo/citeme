local_git_org <- function(x) {
  if (file.exists(file.path(x, "organisation.yml", fsep = "/"))) {
    return(org_list$new()$read(x))
  }
  org_list$new(org_item$new(email = "info@inbo.be"))
}
