#' Ask an URL
#' @inheritParams base::readline
#' @return A character string containing a valid URL or an empty string.
#' @export
#' @family question
ask_url <- function(prompt) {
  repeat {
    url <- readline(prompt = prompt)
    if (url == "" || validate_url(url)) {
      break
    }
    warning("Please enter a valid URL.", immediate. = TRUE, call. = FALSE)
  }
  return(url)
}
