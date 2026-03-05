#' Function to ask a simple yes no question
#' Provides a simple wrapper around `utils::askYesNo()`.
#' This function is used to ask yes no questions in an interactive way.
#' It repeats the question until a valid answer is given.
#' @inheritParams utils::askYesNo
#' @importFrom utils askYesNo
#' @export
#' @family question
ask_yes_no <- function(
  msg,
  default = TRUE,
  prompts = c("Yes", "No", "Cancel"),
  ...
) {
  if (!interactive()) {
    return(default)
  }
  assert_that(is.string(msg), noNA(msg))
  answer <- try(askYesNo(msg = msg, default = default, prompts = prompts))
  while (inherits(answer, "try-error") || is.null(answer)) {
    sprintf("`%s`", prompts) |>
      paste(collapse = ", ") |>
      sprintf(fmt = "Please answer with %s.") |>
      warning(immediate. = TRUE, call. = FALSE)
    answer <- try(askYesNo(msg = msg, default = default, prompts = prompts))
  }
  return(answer)
}
