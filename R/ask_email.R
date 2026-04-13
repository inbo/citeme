#' Ask for an e-mail address
#' @inheritParams base::readline
#' @export
#' @family question
ask_email <- function(prompt) {
  repeat {
    email <- readline(prompt = prompt)
    if (validate_email(email)) {
      break
    }
    warning("Please enter a valid email.", immediate. = TRUE, call. = FALSE)
  }
  return(email)
}
