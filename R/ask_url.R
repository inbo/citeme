#' Ask an URL
#' @inheritParams base::readline
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
