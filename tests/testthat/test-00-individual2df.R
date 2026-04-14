# Test suite for individual2df() function and its methods
# This function converts person objects to data frames with standardised columns

test_that("individual2df.NULL returns empty data frame", {
  result <- individual2df(NULL)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
  expect_named(
    result,
    c("given", "family", "email", "orcid", "ror", "affiliation", "role")
  )
})

test_that("individual2df.logical handles NA", {
  result <- individual2df(NA)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
  expect_named(
    result,
    c("given", "family", "email", "orcid", "ror", "affiliation", "role")
  )
})

test_that("individual2df.logical fails on TRUE", {
  expect_error(
    individual2df(TRUE),
    "`individual2df\\(\\)` is not implemented for `TRUE` or `FALSE`"
  )
})

test_that("individual2df.logical fails on FALSE", {
  expect_error(
    individual2df(FALSE),
    "`individual2df\\(\\)` is not implemented for `TRUE` or `FALSE`"
  )
})

test_that("individual2df.person converts simple person", {
  p <- person(given = "John", family = "Doe", email = "john@example.org")
  result <- individual2df(p)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1)
  expect_equal(result$given, "John")
  expect_equal(result$family, "Doe")
  expect_equal(result$email, "john@example.org")
})

test_that("individual2df.person handles ORCID in comment", {
  p <- person(
    given = "John",
    family = "Doe",
    comment = c(ORCID = "0000-0001-2345-6789")
  )
  result <- individual2df(p)
  expect_equal(result$orcid, "0000-0001-2345-6789")
})

test_that("individual2df.person handles ROR in comment", {
  p <- person(
    given = "Test Org",
    family = "",
    comment = c(ROR = "https://ror.org/00j54wy13")
  )
  result <- individual2df(p)
  expect_equal(result$ror, "https://ror.org/00j54wy13")
})

test_that("individual2df.person handles affiliation in comment", {
  p <- person(
    given = "John",
    family = "Doe",
    comment = c(affiliation = "Test University")
  )
  result <- individual2df(p)
  expect_equal(result$affiliation, "Test University")
})

test_that("individual2df.person handles multiple roles", {
  p <- person(given = "John", family = "Doe", role = c("aut", "cre"))
  result <- individual2df(p)
  expect_equal(result$role, "aut, cre")
})

test_that("individual2df.person handles multiple persons", {
  p <- c(
    person(given = "John", family = "Doe"),
    person(given = "Jane", family = "Smith")
  )
  result <- individual2df(p)
  expect_equal(nrow(result), 2)
  expect_equal(result$given, c("John", "Jane"))
  expect_equal(result$family, c("Doe", "Smith"))
})

test_that("individual2df.person fills missing fields with empty string", {
  p <- person(given = "John", family = "Doe")
  result <- individual2df(p)
  expect_equal(result$email, "")
  expect_equal(result$orcid, "")
  expect_equal(result$ror, "")
  expect_equal(result$affiliation, "")
})

test_that("individual2df.character warns and converts", {
  expect_warning(
    result <- individual2df("John Doe"),
    "converted a character to a person"
  )
  expect_s3_class(result, "data.frame")
})

test_that("individual2df.list handles list of persons", {
  persons <- list(
    person(given = "John", family = "Doe"),
    person(given = "Jane", family = "Smith")
  )
  result <- individual2df(persons)
  expect_equal(nrow(result), 2)
  expect_equal(result$given, c("John", "Jane"))
})

test_that("individual2df.default fails for unsupported types", {
  expect_error(
    individual2df(42),
    "`individual2df\\(\\)` is not implemented for"
  )
})
