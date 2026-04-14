# Tests for citation_description and its helper functions

test_that("citation_description requires citation_meta object", {
  expect_error(
    citeme:::citation_description("not_a_citation_meta"),
    "does not inherit from class citation_meta"
  )
})

test_that("citation_description requires package type", {
  # Create a mock citation_meta object with wrong type
  meta_obj <- structure(
    list(get_type = "project"),
    class = "citation_meta"
  )

  expect_error(
    citeme:::citation_description(meta_obj),
    "not equal to \"package\""
  )
})

# Tests for description_url helper
test_that("description_url handles URLs without DOI", {
  urls <- c("https://example.com", "https://other.com")
  result <- citeme:::description_url(urls)

  expect_equal(result$meta$url, urls)
  expect_equal(result$errors, character(0))
})

test_that("description_url extracts single DOI", {
  urls <- c("https://doi.org/10.5281/zenodo.123", "https://example.com")
  result <- citeme:::description_url(urls)

  expect_equal(result$meta$doi, "10.5281/zenodo.123")
  expect_equal(result$meta$url, "https://example.com")
  expect_equal(result$errors, character(0))
})

test_that("description_url errors on multiple DOIs", {
  urls <- c(
    "https://doi.org/10.5281/zenodo.123",
    "https://doi.org/10.5281/zenodo.456"
  )
  result <- citeme:::description_url(urls)

  expect_true(any(grepl("Multiple DOI found", result$errors)))
})

test_that("description_url filters out GitHub URLs", {
  urls <- c(
    "https://github.com/user/repo",
    "https://example.com"
  )
  result <- citeme:::description_url(urls)

  expect_equal(result$meta$url, "https://example.com")
})

# Tests for description_keywords helper
test_that("description_keywords handles empty keywords", {
  result <- citeme:::description_keywords(character(0))

  expect_equal(result$meta, list())
  expect_true(any(grepl("no keywords found", result$errors)))
})

test_that("description_keywords parses semicolon-separated keywords", {
  result <- citeme:::description_keywords("word1; word2; word3")

  expect_equal(result$meta$keywords, c("word1", "word2", "word3"))
  expect_equal(result$errors, character(0))
})

test_that("description_keywords handles single keyword", {
  result <- citeme:::description_keywords("single")

  expect_equal(result$meta$keywords, "single")
  expect_equal(result$errors, character(0))
})

# Tests for description_communities helper
test_that("description_communities warns on missing communities", {
  skip_if_not_installed("desc")

  # Create a mock description object
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Create minimal DESCRIPTION file
  desc_content <- c(
    "Package: testpkg",
    "Title: Test Package",
    "Version: 0.1.0",
    paste0(
      "Authors@R: person('Test', 'Author', email = 'test@example.com', ",
      "role = c('aut', 'cre'))"
    ),
    "Description: A test package."
  )
  writeLines(desc_content, file.path(temp_dir, "DESCRIPTION"))

  descript <- desc::description$new(file.path(temp_dir, "DESCRIPTION"))
  org <- citeme::org_list$new()

  result <- citeme:::description_communities(descript, org)

  # Since org is empty, no required communities should be found
  expect_true(is.list(result))
})

test_that("description_communities requires description object", {
  org <- citeme::org_list$new()
  expect_error(
    citeme:::description_communities("not_a_description", org),
    "does not inherit from class description"
  )
})

test_that("description_communities requires org_list object", {
  skip_if_not_installed("desc")

  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  desc_content <- c(
    "Package: testpkg",
    "Title: Test Package",
    "Version: 0.1.0",
    paste0(
      "Authors@R: person('Test', 'Author', email = 'test@example.com', ",
      "role = c('aut', 'cre'))"
    ),
    "Description: A test package."
  )
  writeLines(desc_content, file.path(temp_dir, "DESCRIPTION"))

  descript <- desc::description$new(file.path(temp_dir, "DESCRIPTION"))

  expect_error(
    citeme:::description_communities(descript, "not_an_org_list"),
    "does not inherit from class org_list"
  )
})

# Tests for split_community helper
test_that("split_community handles empty input", {
  expect_null(citeme:::split_community(character(0)))
})

test_that("split_community splits semicolon-separated communities", {
  result <- citeme:::split_community("comm1; comm2; comm3")

  expect_equal(result, c("comm1", "comm2", "comm3"))
})

test_that("split_community handles single community", {
  result <- citeme:::split_community("single-community")

  expect_equal(result, "single-community")
})
