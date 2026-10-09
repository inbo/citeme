#' Ask for an ROR
#'
#' The Research Organization Registry (ROR) is a global, community-led registry
#' of open persistent identifiers for research organizations.
#' ROR makes it easy for anyone or any system to disambiguate institution names
#' and connect research organizations to researchers and research outputs.
#' @inheritParams base::readline
#' @return A character string containing a valid ROR identifier or an empty
#' string.
#' @export
#' @family question
#' @examples
#' \dontrun{
#' ask_ror("Enter ROR: ")
#' }
ask_ror <- function(prompt) {
  repeat {
    ror <- readline(prompt = prompt)
    if (ror == "" || validate_ror(ror)) {
      break
    }
    warning(
      "`ror` must be in `id` format, not `https://ror.org/id`",
      immediate. = TRUE,
      call. = FALSE
    )
  }
  return(ror)
}
