#' Ask for keywords
#' This function prompts the user to enter one or more keywords separated by
#' `;`.
#' It will continue to prompt the user until at least one keyword is provided.
#' The function returns a character vector of the entered keywords, with leading
#' and trailing whitespace removed.
#' @return A character vector of keywords entered by the user.
#' @examples
#' \dontrun{
#' keywords <- ask_keywords()
#' }
#' @export
#' @family question
ask_keywords <- function() {
  repeat {
    readline(prompt = "Enter one or more keywords separated by `;` ") |>
      strsplit(";") |>
      unlist() |>
      gsub(pattern = "^\\s+", replacement = "") |>
      gsub(pattern = "\\s+$", replacement = "") -> keywords
    keywords <- keywords[keywords != ""]
    if (length(keywords) > 0) {
      break
    }
    warning(
      "Please enter at least one keyword.",
      immediate. = TRUE,
      call. = FALSE
    )
  }
  return(keywords)
}
