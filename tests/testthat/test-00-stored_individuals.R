# Test suite for stored_individuals() function
# This function retrieves stored individual information from the user data
# directory.

test_that("stored_individuals creates directory if it does not exist", {
  temp_root <- tempfile("citeme_test")
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  result <- stored_individuals(temp_root)
  expect_true(dir.exists(temp_root))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("stored_individuals returns empty data frame for new directory", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  result <- stored_individuals(temp_root)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
  expect_named(
    result,
    c("given", "family", "email", "orcid", "affiliation", "usage")
  )
})

test_that("stored_individuals reads existing individual.txt file", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  # Create individual.txt file
  individuals <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Test University",
    usage = 5L
  )
  write.table(
    individuals,
    file = file.path(temp_root, "individual.txt"),
    sep = "\t",
    row.names = FALSE,
    fileEncoding = "UTF8"
  )
  result <- stored_individuals(temp_root)
  expect_equal(nrow(result), 1)
  expect_equal(result$given, "John")
  expect_equal(result$family, "Doe")
  expect_equal(result$usage, 5L)
})

test_that("stored_individuals fails with non-string root", {
  expect_error(stored_individuals(123))
})

test_that("stored_individuals fails with NA root", {
  expect_error(stored_individuals(NA_character_))
})
