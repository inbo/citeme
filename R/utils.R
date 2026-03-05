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
