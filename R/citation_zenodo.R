#' @importFrom assertthat assert_that has_name
#' @importFrom jsonlite toJSON
#' @importFrom knitr pandoc
#' @importFrom gert git_find
citation_zenodo <- function(meta) {
  # Validate input
  assert_that(inherits(meta, "citation_meta"))
  assert_that(length(meta$get_errors) == 0)

  # Extract base metadata
  zenodo <- meta$get_meta

  # Read and validate person entries from DESCRIPTION
  person <- org_list$new()$read(dirname(meta$get_path))$validate_person(
    meta$get_person,
    lang = "en-GB"
  )

  # Extract package version
  if (has_name(zenodo, "version")) {
    zenodo$version <- as.character(zenodo$version)
  }

  # Extract package contributors
  select_person_role(person, c("ctb", "cph", "cre", "rev")) |>
    vapply(
      FUN = format_zenodo,
      FUN.VALUE = vector("list", 1)
    ) -> zenodo$contributors

  # Extract package creators (individuals)
  select_person_role(person, "aut") |>
    vapply(
      FUN = format_zenodo,
      type = FALSE,
      FUN.VALUE = vector("list", 1)
    ) -> zenodo$creators

  # Extract package keywords
  zenodo$keywords <- as.list(zenodo$keywords)

  # Extract Zenodo communities
  if (has_name(zenodo, "community")) {
    zenodo$communities <- vapply(
      zenodo$community,
      FUN.VALUE = vector("list", 1),
      USE.NAMES = FALSE,
      FUN = function(x) {
        list(list(identifier = x))
      }
    )
    zenodo$community <- NULL
  }

  # Extract language (ISO 639-3)
  if (has_name(zenodo, "language")) {
    zenodo$language <- iso639_3$alpha_3[
      iso639_3$alpha_2 ==
        gsub("^(.{2}).*", "\\1", validate_language(zenodo$language))
    ]
  }

  # Extract publisher
  publishers <- Filter(function(x) "pbl" %in% x$role, person)

  if (length(publishers) > 0) {
    stopifnot("Only single publisher possible" = length(publishers) == 1)
    zenodo$publisher <- publishers$given
  }

  # Remove Zenodo DOI (self-reference)
  if (has_name(zenodo, "doi") && grepl("zenodo", zenodo$doi)) {
    zenodo$doi <- NULL
  }

  # Remove unsupported fields
  zenodo$url <- NULL
  zenodo$source <- NULL

  # Extract grant ID from funder (role = "fnd")
  funders <- Filter(function(x) "fnd" %in% x$role, person)

  grant_ids <- vapply(
    funders,
    function(x) {
      if (!is.null(x$comment) && "grant_id" %in% names(x$comment)) {
        x$comment[["grant_id"]]
      } else {
        NA_character_
      }
    },
    character(1)
  )
  grant_ids <- grant_ids[!is.na(grant_ids)]

  if (length(grant_ids) > 0) {
    zenodo$grants <- vapply(
      grant_ids,
      FUN.VALUE = vector("list", 1),
      USE.NAMES = FALSE,
      FUN = function(x) {
        list(list(id = x))
      }
    )
  }

  # Extract description (convert Markdown to HTML)
  desc <- tempfile(fileext = ".md")
  writeLines(zenodo$description, desc)
  suppressMessages(pandoc(desc, format = "html"))
  gsub("\\.md", ".html", desc) |>
    readLines() |>
    paste(collapse = " ") |>
    gsub(pattern = " +", replacement = " ") -> zenodo$description

  # Write .zenodo.json file
  dirname(meta$get_path) |>
    file.path(".zenodo.json") -> citation_file
  toJSON(zenodo, pretty = TRUE, auto_unbox = TRUE) |>
    writeLines(citation_file)
  errors <- modified_citation_file(citation_file, dirname(meta$get_path))
  return(errors)
}

format_zenodo <- function(x, type = TRUE) {
  list(
    name = format(
      x,
      include = c("family", "given"),
      braces = list(family = c("", ","))
    ),
    affiliation = unname(x$comment["affiliation"]),
    orcid = unname(x$comment["ORCID"]),
    type = zenodo_role(x$role)
  )[c(
    TRUE,
    "affiliation" %in% names(x$comment),
    "ORCID" %in% names(x$comment),
    type
  )] |>
    list()
}

zenodo_role <- function(z) {
  if ("cre" %in% z) {
    return("contactperson")
  } else if ("cph" %in% z) {
    return("rightsholder")
  } else if ("rev" %in% z) {
    return("other")
  } else {
    return("projectmember")
  }
}

format_cff <- function(x) {
  list(
    `given-names` = unname(x$given),
    `family-names` = unname(x$family),
    affiliation = unname(x$comment["affiliation"]),
    orcid = unname(x$comment["ORCID"])
  )[c(
    !is.na(x$given),
    !is.na(x$family),
    !is.na(x$comment["affiliation"]),
    !is.na(x$comment["ORCID"])
  )] |>
    list()
}
