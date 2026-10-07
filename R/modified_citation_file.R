#' @importFrom gert git_find
#' @importFrom utils file_test
#' @noRd
modified_citation_file <- function(citation_file, base_path) {
  stopifnot(
    "`citation_file` is not an existing file" = file_test("-f", citation_file),
    "`base_path` is not an existing directory" = file_test("-d", base_path)
  )
  # Locate the root of the git repository containing `base_path`.
  # `git_find()` errors when `base_path` is outside a git repository.
  repo <- try(git_find(base_path), silent = TRUE)
  if (inherits(repo, "try-error")) {
    return(character(0))
  }
  # Some `gert` versions return the `.git` directory instead of the working
  # tree root, so strip a trailing `.git` component when present.
  repo <- sub("/?\\.git/?$", "", repo)
  # Build the absolute path of the citation file and make it relative to the
  # repository root.
  file <- sub(paste0("^", repo, "/"), "", citation_file)
  unchanged <- is_tracked_not_modified(file = file, repo = repo)
  paste(
    citation_file,
    "is modified. Please commit changes."
  )[!unchanged]
}
