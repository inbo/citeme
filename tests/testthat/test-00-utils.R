# Test suite for utility functions in utils.R

test_that("rules creates horizontal rule of correct width", {
  # Set a known width for testing
  old_width <- getOption("width")
  options(width = 80)
  result <- rules()
  # Should contain newlines and 80 # characters
  expect_true(grepl("^\\n", result))
  expect_true(grepl("\\n$", result))
  # Count the # characters
  hash_count <- nchar(gsub("[^#]", "", result))
  expect_equal(hash_count, 80)
  options(width = old_width)
})

test_that("rules uses custom character", {
  old_width <- getOption("width")
  options(width = 40)
  result <- rules(x = "-")
  dash_count <- nchar(gsub("[^-]", "", result))
  expect_equal(dash_count, 40)
  options(width = old_width)
})

test_that("rules uses custom newline", {
  old_width <- getOption("width")
  options(width = 10)
  result <- rules(x = "#", nl = "\r\n")
  expect_true(grepl("^\r\n", result))
  expect_true(grepl("\r\n$", result))
  options(width = old_width)
})

test_that("rules fails with non-string nl", {
  expect_error(rules(nl = 123))
})

test_that("rules fails with NA nl", {
  expect_error(rules(nl = NA_character_))
})

test_that("first_non_null returns first non-NULL value", {
  result <- first_non_null(NULL, "second", "third")
  expect_equal(result, "second")
})

test_that("first_non_null returns first argument if not NULL", {
  result <- first_non_null("first", "second")
  expect_equal(result, "first")
})

test_that("first_non_null returns NULL if all arguments are NULL", {
  result <- first_non_null(NULL, NULL, NULL)
  expect_null(result)
})

test_that("first_non_null returns NULL for empty input", {
  result <- first_non_null()
  expect_null(result)
})

test_that("first_non_null handles single non-NULL argument", {
  result <- first_non_null("only")
  expect_equal(result, "only")
})

test_that("first_non_null handles single NULL argument", {
  result <- first_non_null(NULL)
  expect_null(result)
})
