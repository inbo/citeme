# Tests for citation_readme and its helper functions

test_that("citation_readme requires citation_meta object", {
  org <- citeme::org_list$new()
  expect_error(
    citation_readme("not_a_citation_meta", org),
    "does not inherit from class citation_meta"
  )
})

test_that("citation_readme requires project type", {
  org <- citeme::org_list$new()
  # Create a mock citation_meta object with wrong type
  meta_obj <- structure(
    list(get_type = "package"),
    class = "citation_meta"
  )

  expect_error(
    citation_readme(meta_obj, org),
    "not equal to \"project\""
  )
})

test_that("citation_readme returns error when README.md missing", {
  org <- citeme::org_list$new()
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  meta <- structure(
    list(get_type = "project", get_path = temp_dir),
    class = "citation_meta"
  )

  result <- citation_readme(meta, org)
  expect_true(length(result$errors) > 0)
  expect_match(result$errors[1], "not found")
})

# Tests for readme_badges
test_that("readme_badges handles missing badges section", {
  text <- c("# Title", "", "Some content")
  result <- readme_badges(text)

  expect_equal(result$errors, character(0))
  expect_equal(result$text, text)
})

test_that("readme_badges detects multiple badges start markers", {
  text <- c(
    "<!-- badges: start -->",
    "![badge](url)",
    "<!-- badges: end -->",
    "<!-- badges: start -->",
    "![badge2](url2)",
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("Multiple.*badges: start", result$errors)))
})

test_that("readme_badges detects multiple badges end markers", {
  text <- c(
    "<!-- badges: start -->",
    "![badge](url)",
    "<!-- badges: end -->",
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("Multiple.*badges: end", result$errors)))
})

test_that("readme_badges detects mismatched badges markers", {
  text <- c(
    "<!-- badges: start -->",
    "![badge](url)"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("Mismatch between", result$errors)))
})

test_that("readme_badges detects end before start", {
  text <- c(
    "<!-- badges: end -->",
    "![badge](url)",
    "<!-- badges: start -->"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("end.*before.*start", result$errors)))
})

test_that("readme_badges extracts DOI badge", {
  text <- c(
    "<!-- badges: start -->",
    paste0(
      "[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.123.svg)]",
      "(https://doi.org/10.5281/zenodo.123)"
    ),
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_equal(result$meta$doi, "10.5281/zenodo.123")
})

test_that("readme_badges detects multiple DOI badges", {
  text <- c(
    "<!-- badges: start -->",
    paste0(
      "[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.123.svg)]",
      "(https://doi.org/10.5281/zenodo.123)"
    ),
    paste0(
      "[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.456.svg)]",
      "(https://doi.org/10.5281/zenodo.456)"
    ),
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("multiple DOI badges", result$errors)))
})

test_that("readme_badges extracts version badge", {
  text <- c(
    "<!-- badges: start -->",
    "![version: 1.2.3](https://img.shields.io/badge/version-1.2.3-blue)",
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_equal(result$meta$version, "1.2.3")
})

test_that("readme_badges detects multiple version badges", {
  text <- c(
    "<!-- badges: start -->",
    "![version: 1.0](https://img.shields.io/badge/version-1.0-blue)",
    "![version: 2.0](https://img.shields.io/badge/version-2.0-blue)",
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("multiple version badges", result$errors)))
})

test_that("readme_badges extracts license badge", {
  text <- c(
    "<!-- badges: start -->",
    paste0(
      "[![GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-brightgreen)]",
      "(https://opensource.org/licenses/GPL-3.0)"
    ),
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_equal(result$meta$license, "GPL-3.0")
})

test_that("readme_badges detects multiple license badges", {
  text <- c(
    "<!-- badges: start -->",
    paste0(
      "[![GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-brightgreen)]",
      "(https://opensource.org/licenses/GPL-3.0)"
    ),
    paste0(
      "[![MIT](https://img.shields.io/badge/License-MIT-brightgreen)]",
      "(https://opensource.org/licenses/MIT)"
    ),
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("multiple license badges", result$errors)))
})

test_that("readme_badges extracts website badge", {
  text <- c(
    "<!-- badges: start -->",
    paste0(
      "[![website](https://img.shields.io/badge/website-example.com-c04384)]",
      "(https://example.com)"
    ),
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_equal(result$meta$url, "https://example.com")
})

test_that("readme_badges detects multiple website badges", {
  text <- c(
    "<!-- badges: start -->",
    paste0(
      "[![website](https://img.shields.io/badge/website-example.com-c04384)]",
      "(https://example.com)"
    ),
    paste0(
      "[![website](https://img.shields.io/badge/website-other.com-c04384)]",
      "(https://other.com)"
    ),
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("multiple website badges", result$errors)))
})

test_that("readme_badges extracts language badge", {
  text <- c(
    "<!-- badges: start -->",
    "![Language: en-GB](https://img.shields.io/badge/language-en--GB-blue)",
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_equal(result$meta$language, "en-GB")
})

test_that("readme_badges detects multiple language badges", {
  text <- c(
    "<!-- badges: start -->",
    "![Language: en-GB](https://img.shields.io/badge/language-en--GB-blue)",
    "![Language: nl-BE](https://img.shields.io/badge/language-nl--BE-blue)",
    "<!-- badges: end -->"
  )

  result <- readme_badges(text)

  expect_true(any(grepl("multiple language badges", result$errors)))
})

test_that("readme_badges sets access_right to open", {
  text <- c(
    "<!-- badges: start -->",
    "![version: 1.0](https://img.shields.io/badge/version-1.0-blue)",
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_equal(result$meta$access_right, "open")
})

test_that("readme_badges removes badges section from text", {
  text <- c(
    "<!-- badges: start -->",
    "![badge](url)",
    "<!-- badges: end -->",
    "# Title",
    "Content"
  )
  result <- readme_badges(text)

  expect_false("<!-- badges: start -->" %in% result$text)
  expect_false("<!-- badges: end -->" %in% result$text)
  expect_true("# Title" %in% result$text)
})

test_that("readme_badges validates non-image content in badges section", {
  text <- c(
    "<!-- badges: start -->",
    "This is not an image",
    "<!-- badges: end -->"
  )
  result <- readme_badges(text)

  expect_true(any(grepl("should only contain images", result$errors)))
})

# Tests for remove_empty_line
test_that("remove_empty_line removes leading empty lines", {
  text <- c("", "  ", "Content", "More")
  result <- remove_empty_line(text, top = TRUE)

  expect_equal(result, c("Content", "More"))
})

test_that("remove_empty_line keeps non-leading empty lines when top=TRUE", {
  text <- c("Content", "", "More")
  result <- remove_empty_line(text, top = TRUE)

  expect_equal(result, c("Content", "", "More"))
})

test_that("remove_empty_line removes all empty lines when top=FALSE", {
  text <- c("Content", "", "  ", "More")
  result <- remove_empty_line(text, top = FALSE)

  expect_equal(result, c("Content", "More"))
})

# Tests for readme_title
test_that("readme_title extracts title from first line", {
  text <- list(
    text = c("# My Project Title", "", "Content"),
    errors = character(0),
    meta = list()
  )
  result <- readme_title(text)

  expect_equal(result$meta$title, "My Project Title")
})

test_that("readme_title handles markdown formatting in title", {
  text <- list(
    text = c("# **Bold** and _italic_ title", "", "Content"),
    errors = character(0),
    meta = list()
  )
  result <- readme_title(text)

  expect_equal(result$meta$title, "Bold and italic title")
})

test_that("readme_title errors when title line missing #", {
  text <- list(
    text = c("Not a title", "", "Content"),
    errors = character(0),
    meta = list()
  )
  result <- readme_title(text)

  expect_true(any(grepl("must start with", result$errors)))
})

test_that("readme_title removes title line from text", {
  text <- list(
    text = c("# Title", "", "Content"),
    errors = character(0),
    meta = list()
  )
  result <- readme_title(text)

  expect_false("# Title" %in% result$text)
  expect_true("Content" %in% result$text)
})

# Tests for strip_markdown
test_that("strip_markdown removes bold formatting", {
  expect_equal(strip_markdown("**bold**"), "bold")
  expect_equal(strip_markdown("__bold__"), "bold")
})

test_that("strip_markdown removes italic formatting", {
  expect_equal(strip_markdown("*italic*"), "italic")
  expect_equal(strip_markdown("_italic_"), "italic")
})

test_that("strip_markdown removes HTML tags", {
  expect_equal(strip_markdown("text <br> more"), "text more")
})

test_that("strip_markdown collapses multiple spaces", {
  expect_equal(strip_markdown("text    more"), "text more")
})

test_that("strip_markdown removes trailing spaces", {
  expect_equal(strip_markdown("text "), "text")
})

# Tests for readme_community
test_that("readme_community extracts community from comment", {
  text <- list(
    text = c("<!-- community: my-community -->", "Other content"),
    meta = list(),
    warnings = character(0)
  )
  result <- readme_community(text)

  expect_equal(result$meta$community, "my-community")
})

test_that("readme_community warns when no community found", {
  text <- list(
    text = c("Content without community"),
    meta = list(),
    warnings = character(0)
  )
  result <- readme_community(text)

  expect_true(any(grepl("No Zenodo community", result$warnings)))
})

test_that("readme_community removes community line from text", {
  text <- list(
    text = c("<!-- community: test -->", "Other content"),
    meta = list(),
    warnings = character(0)
  )
  result <- readme_community(text)

  expect_false("<!-- community: test -->" %in% result$text)
  expect_true("Other content" %in% result$text)
})

# Tests for extract_description
test_that("extract_description extracts description between markers", {
  text <- list(
    text = c(
      "Some text",
      "<!-- description: start -->",
      "This is the description.",
      "<!-- description: end -->",
      "More text"
    ),
    errors = character(0),
    meta = list()
  )
  result <- extract_description(text)

  expect_equal(result$meta$description, "This is the description.")
})

test_that("extract_description detects multiple start markers", {
  text <- list(
    text = c(
      "<!-- description: start -->",
      "Desc",
      "<!-- description: end -->",
      "<!-- description: start -->",
      "Desc2",
      "<!-- description: end -->"
    ),
    errors = character(0),
    meta = list()
  )
  result <- extract_description(text)

  expect_true(any(grepl("Multiple.*description: start", result$errors)))
})

test_that("extract_description detects multiple end markers", {
  text <- list(
    text = c(
      "<!-- description: start -->",
      "Desc",
      "<!-- description: end -->",
      "<!-- description: end -->"
    ),
    errors = character(0),
    meta = list()
  )
  result <- extract_description(text)

  expect_true(any(grepl("Multiple.*description: end", result$errors)))
})

test_that("extract_description detects end before start", {
  text <- list(
    text = c(
      "<!-- description: end -->",
      "Desc",
      "<!-- description: start -->"
    ),
    errors = character(0),
    meta = list()
  )
  result <- extract_description(text)

  expect_true(any(grepl("end.*before.*start", result$errors)))
})

test_that("extract_description removes description markers from text", {
  text <- list(
    text = c(
      "Before",
      "<!-- description: start -->",
      "Desc",
      "<!-- description: end -->",
      "After"
    ),
    errors = character(0),
    meta = list()
  )
  result <- extract_description(text)

  expect_false("<!-- description: start -->" %in% result$text)
  expect_false("<!-- description: end -->" %in% result$text)
  expect_true("Before" %in% result$text)
  expect_true("After" %in% result$text)
})

# Tests for readme_keywords
test_that("readme_keywords extracts keywords", {
  text <- list(
    text = c("**keywords**: word1; word2; word3"),
    errors = character(0),
    warnings = character(0),
    meta = list()
  )
  result <- readme_keywords(text)

  expect_equal(result$meta$keywords, c("word1", "word2", "word3"))
})

test_that("readme_keywords errors when no keywords found", {
  text <- list(
    text = c("No keywords here"),
    errors = character(0),
    warnings = character(0),
    meta = list()
  )
  result <- readme_keywords(text)

  expect_true(any(grepl("No keywords found", result$errors)))
})

test_that("readme_keywords errors on multiple keyword lines", {
  text <- list(
    text = c("**keywords**: word1", "**keywords**: word2"),
    errors = character(0),
    warnings = character(0),
    meta = list()
  )
  result <- readme_keywords(text)

  expect_true(any(grepl("Multiple lines with keywords", result$errors)))
})

test_that("readme_keywords warns about comma separation", {
  text <- list(
    text = c("**keywords**: word1, word2"),
    errors = character(0),
    warnings = character(0),
    meta = list()
  )
  result <- readme_keywords(text)

  expect_true(any(grepl("separated by ','", result$warnings)))
})

test_that("readme_keywords warns about semicolon without space", {
  text <- list(
    text = c("**keywords**: word1;word2"),
    errors = character(0),
    warnings = character(0),
    meta = list()
  )
  result <- readme_keywords(text)

  expect_true(any(grepl("only separated by ';'", result$warnings)))
})

test_that("readme_keywords removes keyword line from text", {
  text <- list(
    text = c("Before", "**keywords**: word1; word2", "After"),
    errors = character(0),
    warnings = character(0),
    meta = list()
  )
  result <- readme_keywords(text)

  expect_false("**keywords**: word1; word2" %in% result$text)
  expect_true("Before" %in% result$text)
  expect_true("After" %in% result$text)
})
