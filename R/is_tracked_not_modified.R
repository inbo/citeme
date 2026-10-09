#' Check if a file is tracked and not modified
#'
#' @param file path relative to the git root directory.
#' @param repo path to the repository
#'
#' @importFrom assertthat assert_that is.string
#' @importFrom gert git_ls git_status
#'
#' @return A logical value: `TRUE` when the file is tracked by git and has no
#' modifications, `FALSE` otherwise.
#' Returns `TRUE` when no git repository is found.
#' @export
#' @family git
#' @examples
#' \dontrun{
#' is_tracked_not_modified("R/my_function.R")
#' }
is_tracked_not_modified <- function(file, repo = ".") {
  assert_that(is.string(file))
  tracked <- try(git_ls(repo = repo), silent = TRUE)
  if (inherits(tracked, "try-error")) {
    if (grepl("could not find repository", tracked)) {
      return(TRUE)
    }
    stop(tracked)
  }
  is_tracked <- file %in% tracked$path
  status <- git_status(repo = repo)
  is_not_modified <- !file %in% status$file[status$status == "modified"]
  return(is_tracked && is_not_modified)
}
