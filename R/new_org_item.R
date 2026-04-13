#' Interactively create a new `org_item`
#' @param languages A character vector of language codes.
#' @param licenses A list of license items.
#' @return An `org_item` object.
#' @family organisation
#' @export
new_org_item <- function(languages, licenses) {
  email <- ask_email("The organisations' email address: ")
  name <- readline(prompt = "The organisations' name: ")
  lang <- ask_language(
    org = list(get_languages = languages),
    prompt = "What is the language of this name?"
  )
  names(name) <- lang
  while (ask_yes_no("Add a name in another language?", default = FALSE)) {
    lang <- ask_language(
      org = list(get_languages = languages[!languages %in% names(name)]),
      prompt = "In what language?"
    )
    extra <- readline(
      prompt = sprintf("The organisations' name in %s: ", lang)
    )
    names(extra) <- lang
    name <- c(name, extra)
  }
  website <- ask_url("The optional organisations' website URL: ")
  logo <- ask_url("The optional organisations' logo URL: ")
  ror <- ask_ror("The optional organisations' ROR identifier: ")
  zenodo <- readline("The optional Zenodo community identifier:")
  orcid <- ask_yes_no(
    "Is an OrcID required for members of this organisation?",
    default = FALSE
  )
  rightsholder <- c("optional", "single", "shared", "when no other")
  rightsholder <- rightsholder[menu_first(
    choices = rightsholder,
    title = "What are the rightsholder requirements for this organisation"
  )]
  funder <- c("optional", "single", "shared", "when no other")
  funder <- funder[menu_first(
    choices = funder,
    title = "What are the funder requirements for this organisation"
  )]
  org_item$new(
    name = name,
    email = email,
    orcid = orcid,
    rightsholder = rightsholder,
    funder = funder,
    ror = ror,
    zenodo = zenodo,
    license = list(
      package = ask_new_license(licenses, type = "package"),
      project = ask_new_license(licenses, type = "project"),
      data = ask_new_license(licenses, type = "data")
    ),
    website = website,
    logo = logo
  )
}
