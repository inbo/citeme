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
