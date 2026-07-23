#' Improved version of `utils::menu()`
#'
#' This function is a wrapper around `utils::menu()` that returns the index of
#' the first choice instead of the index of the selected choice.
#' This is useful when you want to ask a question with only one choice and you
#' want to return a logical value.
#' @inheritParams utils::menu
#' @return An integer indicating the index of the selected choice.
#' Returns `1` in non-interactive sessions.
#' @export
#' @family question
#' @examples
#' # Returns 1 in non-interactive sessions
#' menu_first(choices = c("option A", "option B"))
menu_first <- function(choices, graphics = FALSE, title = NULL) {
  if (!interactive()) {
    return(1)
  }
  menu(choices = choices, graphics = graphics, title = title)
}
