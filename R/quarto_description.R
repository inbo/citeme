quarto_description <- function(path) {
  for (i in list.files(
    path,
    pattern = "\\.q?md$",
    recursive = TRUE,
    full.names = TRUE
  )) {
    readLines(i) |>
      list() |>
      setNames("text") |>
      extract_description() -> description
    if (has_name(description, "meta") || length(description$errors) > 0) {
      break
    }
  }
  if (!has_name(description, "meta")) {
    description$errors <- c(
      description$errors,
      paste(
        "No description found.",
        "Use `<!-- description: start -->` and `<!-- description: end -->`.",
        "Place these tags around the abstract."
      )
    )
  }
  return(
    list(
      description = description$meta$description,
      errors = description$errors
    )
  )
}
