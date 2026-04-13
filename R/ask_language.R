#' Ask for a language
#' @param org An `org_list` object containing the available languages.
#' @inheritParams base::readline
#' @export
#' @family question
ask_language <- function(org, prompt = "Which language?") {
  stopifnot("`org` is not an `org_list` object" = inherits(org, "org_list"))
  available <- org$get_languages
  c(available, "other") |>
    menu_first(title = prompt) -> selected
  if (selected <= length(available)) {
    return(validate_language(available[selected]))
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
