#' Convert SSH URL to HTTP URL
#'
#' This function converts a git SSH URL to an HTTP URL.
#' It also removes any OAuth2 tokens from the URL.
#' The resulting URL is used to determine the root URL of the organisation for
#' retrieving the organisation list.
#' @param url The git URL to convert.
#' @return The converted HTTP URL.
#' @export
#' @family git
ssh_http <- function(url) {
  if (!grepl("^https:\\/\\/", url)) {
    url <- gsub("^git@(.*):", "https://\\1/", url, perl = TRUE)
  }
  url <- gsub("oauth2:.*?@", "", url)
  gsub("(https:\\/\\/.+?\\/.+?)\\/.*", "\\1", url, perl = TRUE)
}
