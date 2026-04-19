#' Validate a citation metadata object
#' @param meta A `citation_meta` object.
#' @return A character vector of validation errors,
#' or an empty character vector if the metadata is valid.
#' @export
#' @importFrom assertthat assert_that
#' @family validation
validate_citation <- function(meta) {
  assert_that(inherits(meta, "citation_meta"))
  org <- org_list$new()$read(meta$get_path)
  persons <- meta$get_person
  rightsholder <- select_person_role(persons, "cph")
  funder <- select_person_role(persons, "fnd")
  publisher <- select_person_role(persons, "pbl")
  contact <- any(has_person_role(persons, "cre"))
  c(rightsholder$email, funder$email, publisher$email) |>
    unlist() |>
    unique() |>
    org$get_zenodo_by_email() -> required_communities
  org$validate_person(persons, lang = meta$get_meta$language) |>
    attr("errors") |>
    c(
      org$validate_rules(
        rightsholder = rightsholder,
        funder = funder,
        publisher = publisher
      ),
      sprintf(
        "missing required Zenodo community `%s`",
        paste(required_communities, collapse = ", ")
      )[
        length(required_communities) > 0 &&
          !all(required_communities %in% meta$get_meta$community)
      ],
      "no individual with `corresponding: true` or role `cre`"[!contact]
    )
}
