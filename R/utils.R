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
