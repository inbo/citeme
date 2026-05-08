#' @importFrom assertthat assert_that
#' @importFrom utils file_test head person tail
citation_r <- function(meta) {
  assert_that(inherits(meta, "citation_meta"))
  if (meta$get_type != "package") {
    return(character(0))
  }
  assert_that(length(meta$get_errors) == 0)
  cit_meta <- meta$get_meta
  dirname(meta$get_path) |>
    file.path("inst", "CITATION", fsep = "/") -> citation_file
  if (file_test("-f", citation_file)) {
    cit <- readLines(citation_file)
  } else {
    dirname(citation_file) |>
      dir.create(recursive = TRUE, showWarnings = FALSE)
    cit <- c(
      sprintf(
        "citHeader(\"To cite `%s` in publications please use:\")",
        gsub("^(.*?):.*", "\\1", cit_meta$title)
      ),
      "# begin citeme entry",
      "# end citeme entry"
    )
  }
  start <- grep("^# begin (citeme|checklist) entry", cit)
  end <- grep("^# end (citeme|checklist) entry", cit)
  errors <- c(
    "No `# begin citeme entry` found in `inst/CITATION`"[length(start) == 0],
    "No `# end citeme entry` found in `inst/CITATION`"[length(end) == 0],
    "Multiple `# begin citeme entry` found in `inst/CITATION`"[
      length(start) > 1
    ],
    "Multiple `# end citeme entry` found in `inst/CITATION`"[
      length(end) > 1
    ],
    paste(
      "`# end citeme entry` before `# begin citeme entry` in",
      "`inst/CITATION`"
    )[
      head(start, length(end)) >= head(end, length(start))
    ]
  )
  if (length(errors) > 0) {
    return(errors = errors)
  }
  individuals <- meta$get_person[vapply(
    meta$get_person,
    FUN.VALUE = logical(1),
    FUN = function(x) {
      "aut" %in% x$role
    }
  )]
  format(
    individuals,
    include = c("given", "family"),
    braces = list(
      given = c("person(given = \"", "\","),
      family = c("family = \"", "\")")
    )
  ) |>
    paste(collapse = ", ") -> individuals_bibtex
  individuals_plain <- format(
    individuals,
    include = c("family", "given"),
    braces = list(family = c("", ","))
  )
  cit_meta$description <- gsub("\"", "\\\\\"", cit_meta$description)
  package_citation <- c(
    bibtype = "\"Manual\"",
    title = sprintf(
      "\"%s. Version %s\"",
      cit_meta$title,
      cit_meta$version
    ),
    author = sprintf("c(%s)", individuals_bibtex),
    year = format(Sys.Date(), "%Y"),
    url = c(cit_meta$url, cit_meta$source) |>
      head(1) |>
      sprintf(fmt = "\"%s\""),
    abstract = paste0("\"", cit_meta$description, "\""),
    textVersion = sprintf(
      "\"%s (%s) %s. Version %s. %s\"",
      paste(individuals_plain, collapse = "; "),
      format(Sys.Date(), "%Y"),
      cit_meta$title,
      cit_meta$version,
      ifelse(
        length(cit_meta$url),
        paste(cit_meta$url, collapse = "; "),
        cit_meta$source
      )
    ),
    keywords = paste0("\"", paste(cit_meta$keywords, collapse = "; "), "\"")
  )
  if (length(cit_meta$doi)) {
    package_citation <- c(
      package_citation,
      doi = paste0("\"", cit_meta$doi, "\"")
    )
  }
  package_citation <- gsub("\n", " ", package_citation)
  package_citation <- gsub("[ ]{2, }", " ", package_citation)
  package_citation <- sprintf(
    "  %s = %s,",
    names(package_citation),
    package_citation
  )
  c(head(cit, start), "bibentry(", package_citation, ")", tail(cit, 1 - end)) |>
    writeLines(citation_file)
  errors <- paste(
    citation_file,
    "is modified.",
    "Please commit changes."
  )[
    !is_tracked_not_modified(
      paste0("/", meta$get_path) |>
        gsub("", citation_file),
      meta$get_path
    )
  ]
  return(modified_citation_file(citation_file, dirname(meta$get_path)))
}
