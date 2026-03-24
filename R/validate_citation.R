#' Validate a citation metadata object
#' @param meta A `citation_meta` object.
#' @return A character vector of validation errors,
#' or an empty character vector if the metadata is valid.
#' @export
#' @importFrom assertthat assert_that
validate_citation <- function(meta) {
  assert_that(inherits(meta, "citation_meta"))
  org <- org_list$new()$read(meta$get_path)
  persons <- meta$get_person
  rightsholder <- persons[vapply(
    persons$role,
    FUN = function(x) {
      "cph" %in% x
    },
    FUN.VALUE = logical(1)
  )]
  funder <- persons[vapply(
    persons$role,
    FUN = function(x) {
      "fnd" %in% x
    },
    FUN.VALUE = logical(1)
  )]
  contact <- any("cre" %in% unlist(persons$role))
  c(rightsholder$email, funder$email) |>
    unlist() |>
    unique() |>
    org$get_zenodo_by_email() -> required_communities
  org$validate_person(persons, lang = meta$get_meta$language) |>
    attr("errors") |>
    c(
      org$validate_rules(rightsholder = rightsholder, funder = funder),
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
