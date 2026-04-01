modified_citation_file <- function(citation_file, base_path) {
  paste0("/", base_path) |>
    gsub("", citation_file) |>
    is_tracked_not_modified(base_path) -> unchanged
  paste(
    citation_file,
    "is modified.",
    "Run `citeme::update_citation()` locally."[!interactive()],
    "Please commit changes."
  )[!unchanged]
}
