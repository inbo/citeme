# Test citation_meta initialisation and accessors
test_that("citation_meta initialises with valid project path", {
  skip_if_not_installed("fs")
  # Test with current directory (the package root)
  # Suppress expected warnings about missing citation metadata
  meta <- suppressWarnings(citation_meta$new("."))
  expect_s3_class(meta, "citation_meta")
  expect_type(meta$get_path, "character")
  expect_type(meta$get_type, "character")
  # person and meta may be NULL if there are errors parsing the package
  expect_true(is.list(meta$get_person) || is.null(meta$get_person))
  expect_true(is.list(meta$get_meta) || is.null(meta$get_meta))
  expect_type(meta$get_errors, "character")
  expect_type(meta$get_notes, "character")
})

test_that("citation_meta fails with non-existent path", {
  expect_error(
    citation_meta$new("non_existent_path_that_does_not_exist"),
    "(No such file or directory|The system cannot find the file specified)"
  )
})

test_that("citation_meta fails with non-string path", {
  # assertthat uses a different error message format
  expect_error(
    citation_meta$new(123),
    "path is not a string"
  )
})

test_that("citation_meta print method produces output", {
  meta <- suppressWarnings(citation_meta$new("."))
  # The print method produces output, so we use expect_output
  expect_output(meta$print())
})

test_that("citation_meta print method can be silenced", {
  meta <- suppressWarnings(citation_meta$new("."))
  expect_silent(meta$print(quiet = TRUE))
})

test_that("citation_meta get_path returns valid path", {
  meta <- suppressWarnings(citation_meta$new("."))
  path <- meta$get_path
  expect_true(dir.exists(path))
})

test_that("citation_meta get_type returns expected values", {
  meta <- suppressWarnings(citation_meta$new("."))
  type <- meta$get_type
  expect_true(type %in% c("bookdown", "quarto", "package", "project"))
})
