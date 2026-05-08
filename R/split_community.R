split_community <- function(community) {
  if (is.null(community) || length(community) == 0) {
    return(NULL)
  }
  stopifnot(
    "community is not a character vector" = inherits(community, "character")
  )
  strsplit(community, split = "\\s*;\\s*") |>
    unlist() |>
    unique()
}
