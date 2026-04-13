#' Interactively create a new organisation list
#'
#' An interactive alternative for `org_list$new()`.
#' Reuses available organisations where possible.
#' @param git An optional string with the absolute path to a git
#' organisation.
#' E.g. `"https://github.com/inbo"`
#' @seealso [`org_list`], [`org_item`]
#' @family organisation
#' @export
new_org_list <- function(git) {
  available <- get_available_organisations()
  rf_option <- c("optional", "single", "shared", "when no other")
  orgs <- list()
  repeat {
    names(available$names) |>
      c("Other") |>
      menu_first(title = "Select the organisation's email") -> selected
    if (selected <= length(available$names)) {
      extra <- org_item$new(
        email = names(available$names)[selected],
        name = available$names[[selected]],
        rightsholder = rf_option[menu_first(
          choices = rf_option,
          title = "What are the rightsholder requirements for this organisation"
        )],
        funder = rf_option[menu_first(
          choices = rf_option,
          title = "What are the funder requirements for this organisation"
        )],
        orcid = unname(available$orcid[names(available$names)[selected]]),
        zenodo = unname(available$zenodo[names(available$names)[selected]]),
        ror = unname(available$ror[names(available$names)[selected]]),
        website = unname(available$website[names(available$names)[selected]]),
        logo = unname(available$logo[names(available$names)[selected]])
      )
      available$names <- available$names[-selected]
    } else {
      extra <- new_org_item(
        languages = available$languages,
        licenses = available$licenses
      )
    }
    orgs[[length(orgs) + 1]] <- extra
    if (!ask_yes_no("Add another organisation?", default = FALSE)) {
      break
    }
  }
  if (!missing(git)) {
    orgs[["git"]] <- ssh_http(git)
  }
  do.call(org_list$new, orgs)
}
