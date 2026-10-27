#' Ask a GitHub token
#'
#' Read the token from the credentials helper.
#' In case there is not token, ask this user if they want to provide the token.
#' When the user answers 'no', return `NULL`.
#' Otherwise, ask the token, store it and return it.
#' @inheritParams gitcreds::gitcreds_get
#' @export
#' @family git
get_token <- function(url = "https://github.com") {
  stopifnot(
    "The `gitcreds` package is required" = requireNamespace(
      "gitcreds", quietly = TRUE
    )
  )
  token <- try(
    gitcreds::gitcreds_get(url = url, use_cache = FALSE, set_cache = FALSE),
    silent = TRUE
  )
  if (!inherits(token, "try-error")) {
    return(token)
  }
  paste0(
    "The function needs your GitHub Personal Access Token (PAT) to work.\n",
    "Answer 'yes' to provide it now.\n",
    "Answer 'no' to continue without the token, ",
    "but some features may not work.\n",
    "Answer `cancel` to abort the function and set the token manually with ",
    "`gitcreds::gitcreds_set()`."
  ) |>
    ask_yes_no(default = FALSE) -> answer
  if (isFALSE(answer)) {
    return(NULL)
  }
  helpers <- gitcreds::gitcreds_list_helpers()
  stopifnot(
    "no credentials helpers found. see ?gitcreds::gitcreds_list_helpers()" =
      sum(helpers != "cache") > 0
  )
  gitcreds::gitcreds_set(url = url)
  gitcreds::gitcreds_get(url = url, use_cache = FALSE, set_cache = FALSE)
}
