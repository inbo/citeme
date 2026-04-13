modified_citation_file <- function(citation_file, base_path) {
  normalizePath(base_path, mustWork = TRUE, winslash = "/") |>
    paste0("/") |>
    gsub("", citation_file) |>
    is_tracked_not_modified(base_path) -> unchanged
  paste(
    citation_file,
    "is modified. Please commit changes."
  )[!unchanged]
}
