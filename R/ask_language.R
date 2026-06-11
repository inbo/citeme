#' Ask for a language
#' @param languages A character vector containing the available languages.
#' @inheritParams base::readline
#' @export
#' @family question
ask_language <- function(languages, prompt = "Which language?") {
  stopifnot("`languages` is not a character vector" = is.character(languages))
  vapply(languages, validate_language, character(1)) |>
    unname() -> languages
  c(languages, "other") |>
    menu_first(title = prompt) -> selected
  if (selected <= length(languages)) {
    return(validate_language(languages[selected]))
  }
  language <- readline(prompt = "Please enter the language code: ")
  while (
    inherits(
      try(validate_language(language), silent = !interactive()),
      "try-error"
    )
  ) {
    language <- readline(prompt = "Please enter the language code: ")
  }
  return(language)
}
