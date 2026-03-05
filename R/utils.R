#' Check if a vector contains valid email
#'
#' It only checks the format of the text, not if the email address exists.
#' @param email A vector with email addresses.
#' @return A logical vector.
#' @export
#' @importFrom assertthat assert_that
#' @family utils
validate_email <- function(email) {
  assert_that(is.character(email))
  # expression taken from https://emailregex.com/
  grepl(
    paste0(
      "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"",
      "(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|",
      "\\[\x01-\x09\x0b\x0c\x0e-\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*",
      "[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|",
      "2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9]",
      "[0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a",
      "\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\\])"
    ),
    tolower(email)
  )
}

#' Validate the structure of an ORCID id
#'
#' Checks whether the ORCID has the proper format and the checksum.
#' @param orcid A vector of ORCID
#' @returns A logical vector with the same length as the input vector.
#' @export
#' @importFrom assertthat assert_that noNA
#' @family utils
validate_orcid <- function(orcid) {
  assert_that(is.character(orcid), noNA(orcid))
  format_ok <- grepl("^(\\d{4}-){3}\\d{3}[\\dX]$", orcid, perl = TRUE)
  if (!any(format_ok)) {
    return(orcid == "" | format_ok)
  }
  gsub("-", "", orcid[format_ok]) |>
    strsplit(split = "") |>
    do.call(what = cbind) -> digits
  checksum <- digits[16, ]
  seq_len(15) |>
    rev() |>
    matrix(ncol = 1) -> powers
  apply(digits[-16, , drop = FALSE], 1, as.integer, simplify = FALSE) |>
    do.call(what = rbind) |>
    crossprod(2^powers) |>
    as.vector() -> total
  remainder <- (12 - (total %% 11)) %% 11
  remainder <- as.character(remainder)
  remainder[remainder == "10"] <- "X"
  format_ok[format_ok] <- remainder == checksum
  return(orcid == "" | format_ok)
}

validate_url <- function(url) {
  stopifnot(
    "`url` must be a string" = assertthat::is.string(url),
    "`url` cannot be NA" = assertthat::noNA(url)
  )
  grepl(
    "^(http|https)://[a-z0-9-]+(\\.[a-z0-9-]+)+(:[0-9]+)?(/.*)?$",
    url,
    perl = TRUE
  )
}

#' Determine if a directory is in a git repository
#'
#' The path arguments specifies the directory at which to start the search for
#' a git repository.
#' If it is not a git repository itself, then its parent directory is consulted,
#' then the parent's parent, and so on.
#' @inheritParams gert::git_find
#' @importFrom gert git_find
#' @return TRUE if directory is in a git repository else FALSE
#' @export
#' @family git
is_repository <- function(path = ".") {
  out <- tryCatch(git_find(path = path), error = function(e) e)
  !any(class(out) == "error")
}

#' Improved version of menu()
#' @inheritParams utils::menu
#' @export
#' @family utils
menu_first <- function(choices, graphics = FALSE, title = NULL) {
  if (!interactive()) {
    return(1)
  }
  menu(choices = choices, graphics = graphics, title = title)
}

rules <- function(x = "#", nl = "\n") {
  assertthat::assert_that(assertthat::is.string(nl), assertthat::noNA(nl))
  paste(c(nl, rep(x, getOption("width", 80)), nl), collapse = "")
}

file_exists <- function(path) {
  file.exists(path)
}

set_non_empty <- function(x, fun, prompt) {
  if (x == "") {
    return(x)
  }
  fun(x) |>
    setNames(prompt) |>
    stopifnot()
  return(x)
}

ask_orcid <- function(prompt = "orcid: ") {
  orcid <- readline(prompt = prompt)
  if (orcid == "") {
    return(orcid)
  }
  while (!validate_orcid(orcid)) {
    message(
      "\nPlease provide a valid ORCiD in the format `0000-0000-0000-0000`\n"
    )
    orcid <- readline(prompt = prompt)
  }
  return(orcid)
}

coalesce <- function(...) {
  dots <- list(...)
  i <- 1
  while (i <= length(dots)) {
    if (!is.null(dots[[i]])) {
      return(dots[[i]])
    }
    i <- i + 1
  }
  return(NULL)
}

first_non_null <- function(...) {
  dots <- list(...)
  if (length(dots) == 0) {
    return(NULL)
  }
  if (!is.null(dots[[1]])) {
    return(dots[[1]])
  }
  do.call(first_non_null, utils::tail(dots, -1))
}

validate_license <- function(license) {
  stopifnot(
    "`license` must be a list" = inherits(license, "list"),
    "`license` must contain \`package\`, \`project\`, and \`data\`" = all(
      c("package", "project", "data") %in% names(license)
    ),
    "`license` must contain character vectors" = all(
      vapply(license, is.character, FUN.VALUE = logical(1))
    ),
    "`license` must contain named vectors" = all(
      vapply(
        license,
        function(x) {
          length(x) == 0 || (!is.null(names(x)) && all(names(x) != ""))
        },
        FUN.VALUE = logical(1)
      )
    ),
    "`license` must contain uniquely named vectors" = all(
      vapply(
        license,
        function(x) {
          length(x) == 0 || anyDuplicated(names(x)) == 0
        },
        FUN.VALUE = logical(1)
      )
    ),
    "`license` must contain vectors with unique licenses" = all(
      vapply(
        license,
        function(x) {
          length(x) == 0 || anyDuplicated(x) == 0
        },
        FUN.VALUE = logical(1)
      )
    )
  )
}
