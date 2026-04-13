#' @title coalesce
#' @description Return the first non-NULL argument.
#' @param ... Arguments to check for non-NULL values.
#' @return The first non-NULL argument, or NULL if all arguments are NULL.
#' @export
#' @family utils
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
