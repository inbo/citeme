citation_cff <- function(meta) {
  assert_that(inherits(meta, "citation_meta"))
  if (!meta$get_type %in% c("package", "project")) {
    return(character(0))
  }
  assert_that(length(meta$get_errors) == 0)
  person <- meta$get_person
  select_person_role(person, "aut") |>
    vapply(
      FUN = format_cff,
      FUN.VALUE = vector(mode = "list", 1)
    ) -> individuals
  select_person_role(person, "cre") |>
    vapply(
      FUN = format_cff,
      FUN.VALUE = vector(mode = "list", 1)
    ) -> contact
  input <- meta$get_meta
  if (has_name(input, "doi")) {
    identifiers <- list(list(type = "doi", value = input$doi))
  } else {
    identifiers <- list()
  }
  if (has_name(input, "url") && length(input$url) > 0) {
    identifiers <- c(identifiers, list(list(type = "url", value = input$url)))
  }
  cff <- list(
    `cff-version` = "1.2.0",
    message = "If you use this software, please cite it using these metadata.",
    title = input$title,
    authors = individuals,
    keywords = as.list(input$keywords),
    contact = contact,
    doi = input$doi,
    license = input$license,
    `repository-code` = input$source,
    type = input$upload_type,
    abstract = strip_markdown(input$description) |>
      paste(collapse = "\n")
  )
  attr(cff$title, "quoted") <- TRUE
  attr(cff$abstract, "quoted") <- TRUE
  if (length(identifiers) > 0) {
    cff$identifiers <- identifiers
  }
  if (has_name(input, "version")) {
    cff$version <- as.character(input$version)
  }
  dirname(meta$get_path) |>
    file.path("CITATION.cff", fsep = "/") -> citation_file
  write_yaml(x = cff, file = citation_file, fileEncoding = "UTF-8")
  return(modified_citation_file(citation_file, dirname(meta$get_path)))
}
