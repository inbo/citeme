# Test citation_meta initialisation and accessors
test_that("citation_meta initialises with valid project path", {
  tmp_description <- tempfile("DESCRIPTION")
  dir.create(tmp_description)
  on.exit(unlink(tmp_description, recursive = TRUE), add = TRUE)
  c(
    "Package: junk",
    "Title: Junk Package",
    "Version: 0.0.0",
    "Authors@R: person(\"Given\", \"Family\", role = c(\"aut\", \"cre\"))",
    "Description: This is a description.",
    "License: MIT"
  ) |>
    writeLines(file.path(tmp_description, "DESCRIPTION"))
  # Suppress expected warnings about missing citation metadata
  meta <- suppressWarnings(citation_meta$new(tmp_description))
  expect_s3_class(meta, "citation_meta")
  expect_type(meta$get_path, "character")
  expect_type(meta$get_type, "character")
  # person and meta may be NULL if there are errors parsing the package
  expect_true(is.list(meta$get_person))
  expect_true(is.list(meta$get_meta))
  expect_type(meta$get_errors, "character")
  expect_type(meta$get_notes, "character")
  # The print method produces output, so we use expect_output
  expect_output(meta$print())
  # citation_meta print method can be silenced
  expect_silent(meta$print(quiet = TRUE))
  # citation_meta get_path returns valid path
  expect_true(file.exists(meta$get_path))
  expect_equal(meta$get_type, "package")
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
