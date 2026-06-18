#' @importFrom assertthat assert_that is.string
#' @importFrom utils file_test
#' @importFrom yaml read_yaml
citation_quarto <- function(meta) {
  assert_that(inherits(meta, "citation_meta"))
  assert_that(meta$get_type == "quarto")
  if (!file_test("-f", meta$get_path)) {
    return(
      list(
        errors = paste(meta$get_path, "not found"),
        warnings = character(0),
        notes = character(0)
      )
    )
  }
  if (basename(meta$get_path) == "_quarto.yml") {
    yaml <- read_yaml(meta$get_path)
  } else {
    stopifnot(
      "please install the 'rmarkdown' package" = requireNamespace(
        "rmarkdown",
        quietly = TRUE
      )
    )
    yaml <- rmarkdown::yaml_front_matter(meta$get_path)
  }
  language <- yaml$lang
  if (has_name(yaml, "flandersqmd")) {
    yaml <- yaml$flandersqmd
  } else if (has_name(yaml, "book")) {
    yaml <- yaml$book
  }
  yaml$lang <- coalesce(yaml$lang, language)
  cit_meta <- yaml_individual(yaml = yaml)
  cit_meta$warnings <- cit_meta$notes <- character(0)
  dirname(meta$get_path) |>
    quarto_description() -> description
  cit_meta$meta$description <- description$description
  cit_meta$errors <- c(cit_meta$errors, description$errors)
  cit_meta$meta$title <- paste0(
    yaml$title,
    ifelse(has_name(yaml, "subtitle"), paste0(". ", yaml$subtitle, "."), ".")
  )
  if (has_name(yaml, "shorttitle")) {
    cit_meta$meta$shorttitle <- yaml$shorttitle
  }
  cit_meta$meta$upload_type <- "publication"
  if (has_name(yaml, "publication_date")) {
    cit_meta$meta$publication_date <- string2date(yaml$publication_date) |>
      format("%Y-%m-%d")
  }
  if (has_name(yaml, "embargo")) {
    cit_meta$meta$embargo_date <- string2date(yaml$embargo) |>
      format("%Y-%m-%d")
    cit_meta$meta$access_right <- "embargoed"
    if (!has_name(yaml, "publication_date")) {
      cit_meta$meta$publication_date <- cit_meta$meta$embargo_date
    }
  } else {
    cit_meta$meta$access_right <- "open"
  }
  if (!has_name(yaml, "license")) {
    cit_meta$errors <- c(
      cit_meta$errors,
      "No `license` element found in YAML"
    )
    return(cit_meta)
  }
  cit_meta$meta$license <- yaml$license
  if (has_name(yaml, "lang")) {
    cit_meta$meta$language <- yaml$lang
  }
  extra <- c(
    "community",
    "doi",
    "keywords",
    "publication_type",
    "publisher"
  )
  extra <- extra[extra %in% names(yaml)]
  cit_meta$meta <- c(cit_meta$meta, yaml[extra])
  publication_type <- c(
    "publication",
    "publication-annotationcollection",
    "publication-article",
    "publication-book",
    "publication-conferencepaper",
    "publication-conferenceproceeding",
    "publication-datamanagementplan",
    "publication-datapaper",
    "publication-deliverable",
    "publication-dissertation",
    "publication-journal",
    "publication-milestone",
    "publication-other",
    "publication-patent",
    "publication-peerreview",
    "publication-preprint",
    "publication-proposal",
    "publication-report",
    "publication-section",
    "publication-softwaredocumentation",
    "publication-standard",
    "publication-taxonomictreatment",
    "publication-technicalnote",
    "publication-thesis",
    "publication-workingpaper"
  )
  c(
    "No `keywords` element found"[!has_name(yaml, "keywords")],
    "No `publisher` element found"[!has_name(yaml, "publisher")],
    paste(
      "`publication_type` must be one of following:",
      paste(publication_type, collapse = ", "),
      sep = "\n"
    )[
      has_name(yaml, "publication_type") &&
        is.string(yaml$publication_type) &&
        !yaml$publication_type %in% publication_type
    ]
  ) |>
    c(cit_meta$errors) -> cit_meta$errors
  c(
    "No `publication_type` element found"[!has_name(yaml, "publication_type")]
  ) |>
    c(cit_meta$notes) -> cit_meta$notes
  cit_meta$meta$community <- split_community(cit_meta$meta$community)
  return(cit_meta)
}
