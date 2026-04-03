rules <- function(x = "#", nl = "\n") {
  assertthat::assert_that(assertthat::is.string(nl), assertthat::noNA(nl))
  paste(c(nl, rep(x, getOption("width", 80)), nl), collapse = "")
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
