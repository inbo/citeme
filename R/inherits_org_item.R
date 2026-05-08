inherits_org_item <- function(dots) {
  vapply(dots, inherits, logical(1), what = "org_item") |>
    as.list() -> ok
  names(ok) <- sprintf("element %i is not an `org_item`", seq_along(dots))
  do.call(stopifnot, ok)
  return(invisible(TRUE))
}
