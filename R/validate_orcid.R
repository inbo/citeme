#' Validate the structure of an `ORCID iD`
#'
#' The [`ORCID iD`](https://orcid.org/) is a unique, persistent identifier
#' free of charge to researchers.
#' Checks whether the `ORCID iD` has the proper format and a correct checksum.
#' The `ORCID iD` must be in the format `0000-0000-0000-0000` where the last
#' digit can be a number or `"X"`.
#' Empty strings are considered valid to allow optional `ORCID iD`.
#' @param orcid A vector of ORCID
#' @returns A logical vector with the same length as the input vector.
#' @export
#' @family validation
validate_orcid <- function(orcid) {
  stopifnot("`orcid` must be a character vector" = inherits(orcid, "character"))
  format_ok <- grepl("^(\\d{4}-){3}\\d{3}[\\dX]$", orcid, perl = TRUE)
  if (!any(format_ok)) {
    return(orcid == "" | format_ok)
  }
  gsub("-", "", orcid[format_ok]) |>
    strsplit(split = "") |>
    do.call(what = cbind) -> digits
  checksum <- digits[16, ]
  seq_len(15) |>
    rev() |>
    matrix(ncol = 1) -> powers
  apply(digits[-16, , drop = FALSE], 1, as.integer, simplify = FALSE) |>
    do.call(what = rbind) |>
    crossprod(2^powers) |>
    as.vector() -> total
  remainder <- (12 - (total %% 11)) %% 11
  remainder <- as.character(remainder)
  remainder[remainder == "10"] <- "X"
  format_ok[format_ok] <- remainder == checksum
  return(orcid == "" | format_ok)
}
