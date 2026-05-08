#' Store individual details for later usage
#' @param x Path to a project
#' @export
#' @importFrom desc description
#' @importFrom stats aggregate
#' @importFrom tools R_user_dir
#' @importFrom utils write.table
#' @family individual
store_individuals <- function(x = ".") {
  current <- stored_individuals()
  current$ror <- ""
  if (file.exists(file.path(x, "DESCRIPTION", fsep = "/"))) {
    this_desc <- description$new(file = file.path(x, "DESCRIPTION", fsep = "/"))
    this_desc$get_individuals() |>
      individual2df() |>
      cbind(usage = 1) |>
      rbind(cbind(current, role = "")) -> new_individual_df
  } else {
    citation_meta$new(x)$get_person |>
      individual2df() |>
      cbind(usage = 1, email = "") -> cit_meta
    cit_meta <- cit_meta[
      cit_meta$family != "",
      c("given", "family", "email", "orcid", "ror", "affiliation", "usage")
    ]
    new_individual_df <- rbind(current, cit_meta)
  }
  aggregate(
    usage ~ given + family + email + orcid + affiliation,
    FUN = sum,
    data = new_individual_df
  ) |>
    write.table(
      file = R_user_dir("citeme", which = "data") |>
        file.path("individual.txt", fsep = "/"),
      sep = "\t",
      row.names = FALSE,
      fileEncoding = "UTF8"
    )
  return(invisible(NULL))
}

#' Convert person object in a data.frame.
#'
#' Results in a data.frame with the given name, family name, e-mail, ORCID,
#' affiliation and role.
#' Missing elements result in an empty string (`""`).
#' Persons with multiple roles will have the roles as a comma separated string.
#' @param person The person object or a list of person objects, `NA` or `NULL`.
#' Any `"character"` is converted to a person object using `as.person()` with a
#' warning.
#' @family individual
#' @export
individual2df <- function(person) {
  UseMethod("individual2df", person)
}

#' @export
individual2df.default <- function(person) {
  stop("`individual2df()` is not implemented for ", class(person))
}

#' @export
individual2df.logical <- function(person) {
  stopifnot(
    "`individual2df()` is not implemented for `TRUE` or `FALSE`" = is.na(person)
  )
  data.frame(
    given = character(0),
    family = character(0),
    email = character(0),
    orcid = character(0),
    ror = character(0),
    affiliation = character(0),
    role = character(0)
  )
}

#' @export
individual2df.NULL <- function(person) {
  data.frame(
    given = character(0),
    family = character(0),
    email = character(0),
    orcid = character(0),
    ror = character(0),
    affiliation = character(0),
    role = character(0)
  )
}

#' @export
#' @importFrom utils as.person
individual2df.character <- function(person) {
  warning(
    "`individual2df()` converted a character to a person using `as.person()`",
    immediate. = TRUE,
    call. = FALSE
  )
  individual2df(as.person(person))
}

#' @export
individual2df.list <- function(person) {
  vapply(
    person,
    function(x) {
      list(individual2df(x))
    },
    vector(mode = "list", 1)
  ) |>
    do.call(what = rbind)
}

#' @export
#' @importFrom assertthat assert_that has_name
individual2df.person <- function(person) {
  assert_that(inherits(person, "person"))
  if (length(person) > 1) {
    return(
      vapply(
        person,
        function(x) {
          list(individual2df(x))
        },
        vector(mode = "list", 1)
      ) |>
        do.call(what = rbind)
    )
  }

  data.frame(
    given = coalesce(person$given, ""),
    family = coalesce(person$family, ""),
    email = coalesce(person$email, ""),
    orcid = ifelse(
      has_name(person$comment, "ORCID"),
      unname(person$comment["ORCID"]),
      ""
    ),
    ror = ifelse(
      has_name(person$comment, "ROR"),
      unname(person$comment["ROR"]),
      ""
    ),
    affiliation = ifelse(
      has_name(person$comment, "affiliation"),
      unname(person$comment["affiliation"]),
      ""
    ),
    role = paste(person$role, collapse = ", ")
  )
}

#' @importFrom assertthat assert_that is.string noNA
#' @importFrom utils file_test read.table
stored_individuals <- function() {
  root <- R_user_dir("citeme", which = "data")
  if (file_test("-f", file.path(root, "individual.txt", fsep = "/"))) {
    file.path(root, "individual.txt", fsep = "/") |>
      read.table(
        header = TRUE,
        sep = "\t",
        colClasses = c(rep("character", 5), "integer")
      ) -> current
    return(current)
  }
  root <- R_user_dir("checklist", which = "data")
  if (file_test("-f", file.path(root, "author.txt", fsep = "/"))) {
    file.path(root, "author.txt", fsep = "/") |>
      read.table(
        header = TRUE,
        sep = "\t",
        colClasses = c(rep("character", 5), "integer")
      ) -> current
    return(current)
  }
  root <- R_user_dir("citeme", which = "data")
  dir.create(root, recursive = TRUE, showWarnings = FALSE)
  return(
    data.frame(
      given = character(0),
      family = character(0),
      email = character(0),
      orcid = character(0),
      affiliation = character(0),
      usage = integer(0)
    )
  )
}
