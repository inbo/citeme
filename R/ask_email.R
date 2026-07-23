#' Ask for an e-mail address
#' @inheritParams base::readline
#' @return A character string containing a valid e-mail address.
#' @export
#' @family question
#' @examples
#' \dontrun{
#' ask_email("Enter your email: ")
#' }
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
