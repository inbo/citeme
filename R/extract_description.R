#' @importFrom utils head
extract_description <- function(text) {
  description_start <- grep("<!-- description: start -->", text$text)
  description_end <- grep("<!-- description: end -->", text$text)
  errors <- c(
    "No `<!-- description: start -->` found."[length(description_start) == 0],
    "No `<!-- description: end -->` found."[length(description_end) == 0],
    "Multiple `<!-- description: start -->`"[length(description_start) > 1],
    "Multiple `<!-- description: end -->`"[length(description_end) > 1],
    paste(
      "Mismatch between `<!-- description: start -->` and",
      "`<!-- description: end -->`"
    )[length(description_start) != length(description_end)],
    "`<!-- description: end -->` before `<!-- description: start -->`"[
      any(
        head(description_end, length(description_start)) <=
          head(description_start, length(description_end))
      )
    ]
  )
  text$errors <- c(text$errors, errors)
  if (length(errors) == 0) {
    text$meta$description <- text$text[
      seq(description_start + 1, description_end - 1)
    ]
    text$text <- text$text[-description_start:-description_end]
  }
  return(text)
}
