#' Ask for an `ORCID iD`
#'
#' The [`ORCID iD`](https://orcid.org/) is a unique, persistent identifier
#' free of charge to researchers.
#' This function prompts the user to enter an `ORCID iD` and validates its
#' format.
#' The `ORCID iD` must be in the format `0000-0000-0000-0000` where the last
#' digit can be a number or `"X"`.
#' Empty strings are considered valid to allow optional `ORCID iD`.
#' @param prompt A character string to display as a prompt to the user.
#'   The default is `"orcid: "`.
#' @return A character string containing the `ORCID iD` entered by the user.
#' @export
#' @family question
ask_orcid <- function(prompt = "orcid: ") {
  orcid <- readline(prompt = prompt)
  if (orcid == "") {
    return(orcid)
  }
  while (!validate_orcid(orcid)) {
    warning(
      "\nPlease provide a valid ORCiD in the format `0000-0000-0000-0000`\n",
      immediate. = TRUE, call. = FALSE
    )
    orcid <- readline(prompt = prompt)
  }
  return(orcid)
}
