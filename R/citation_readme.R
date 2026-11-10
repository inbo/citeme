#' @importFrom assertthat assert_that
#' @importFrom utils file_test
citation_readme <- function(meta, org) {
  assert_that(inherits(meta, "citation_meta"))
  assert_that(meta$get_type == "project")
  if (!file_test("-f", meta$get_path)) {
    return(
      list(
        errors = paste(meta$get_path, "not found"),
        warnings = character(0),
        notes = character(0)
      )
    )
  }
  readme <- readLines(meta$get_path)
  readme_badges(readme) |>
    readme_title() |>
    readme_individual(org = org) |>
    readme_community() |>
    extract_description() |>
    readme_keywords() -> cit_meta
  if (is_repository(meta$get_path)) {
    remotes <- git_remote_list(meta$get_path)
    remotes$url[remotes$name == "origin"] |>
      gsub(pattern = "git@(.*?):(.*)", replacement = "https://\\1/\\2") |>
      gsub(pattern = "https://.*?@", replacement = "https://") |>
      gsub(pattern = "\\.git$", replacement = "") |>
      paste0("/") -> cit_meta$meta$source
  }
  cit_meta$meta$upload_type <- "software"
  return(cit_meta)
}

remove_empty_line <- function(text, top = TRUE) {
  empty_line <- grep("^\\s*$", text)
  if (top) {
    empty_line <- empty_line[empty_line == seq_along(empty_line)]
  }
  if (length(empty_line)) {
    return(text[-empty_line])
  }
  return(text)
}

#' @importFrom utils head tail
readme_title <- function(text) {
  text$text <- remove_empty_line(text$text, top = TRUE)
  title <- head(text$text, 1)
  text$errors <- c(
    text$errors,
    paste(
      "Title line must be just below the (optional) badges section in",
      "README.md.",
      "The title in README.md must start with `# `."
    )[!grepl("^ *# +", title)]
  )
  gsub(pattern = "^ *?# +", replacement = "", title) |>
    strip_markdown() -> text$meta$title
  text$text <- tail(text$text, -1)
  return(text)
}

strip_markdown <- function(text) {
  gsub("\\*\\*(.*?)\\*\\*", "\\1", text) |>
    gsub(pattern = "__(.*?)__", replacement = "\\1") |>
    gsub(pattern = "\\*(.*?)\\*", replacement = "\\1") |>
    gsub(pattern = "_(.*?)_", replacement = "\\1") |>
    gsub(pattern = "<.*?>", replacement = "") |>
    gsub(pattern = " +", replacement = " ") |>
    gsub(pattern = " $", replacement = "")
}

readme_community <- function(text) {
  community_regexp <- "<!-- community: (.*?) -->"
  community_line <- grep(community_regexp, text$text)
  text$warnings <- c(
    text$warnings,
    "No Zenodo community information found in README.md"[
      length(community_line) == 0
    ]
  )
  if (length(community_line) > 0) {
    text$meta$community <- gsub(
      community_regexp,
      "\\1",
      text$text[community_line]
    )
    text$text <- text$text[-community_line]
  }
  return(text)
}

readme_keywords <- function(text) {
  keyword_regexp <- "\\*\\*keywords\\*\\*: *(.*)"
  keyword_line <- grep(keyword_regexp, text$text)
  text$errors <- c(
    text$errors,
    paste(
      "No keywords found in README.md.",
      "Add them on a line starting with `**keywords**:`",
      "Separate keywords with `; `"
    )[length(keyword_line) == 0],
    "Multiple lines with keywords found in README.md"[length(keyword_line) > 1]
  )
  if (length(keyword_line) != 1) {
    return(text)
  }
  text$warnings <- c(
    text$warnings,
    paste(
      "keywords found in README.md separated by ','.",
      "Please use `; ` instead."
    )[grepl(",", text$text[keyword_line])],
    paste(
      "keywords found in README.md only separated by ';'.",
      "Please use `; ` instead."
    )[grepl(";\\w", text$text[keyword_line])]
  )
  gsub(keyword_regexp, "\\1", text$text[keyword_line]) |>
    gsub(pattern = " +", replacement = " ") |>
    strsplit("; ") |>
    unlist() -> text$meta$keywords
  text$text <- text$text[-keyword_line]
  return(text)
}
