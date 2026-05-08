compatible_rules <- function(rules) {
  if (length(rules) < 2) {
    return(TRUE)
  }
  # fmt: skip
  stopifnot(
    "more than one organisation with `single`" = sum(rules == "single") <= 1,
    "`single` is not compatible with `shared`" =
      !(any(rules == "single") && any(rules == "shared")),
    "`single` is not compatible with `when no other`" =
      !(any(rules == "single") && any(rules == "when no other")),
    "more than one organisation with `when no other`" =
      sum(rules == "when no other") <= 1
  )
}
