test_that("individual2df handles person object", {
  p <- person("John", "Doe", email = "john@example.com", role = "aut")
  result <- individual2df(p)
  expect_s3_class(result, "data.frame")
  expect_equal(result$given, "John")
  expect_equal(result$family, "Doe")
  expect_equal(result$email, "john@example.com")
  expect_equal(result$role, "aut")
})

test_that("individual2df handles person object with ORCID", {
  p <- person(
    "John",
    "Doe",
    email = "john@example.com",
    comment = c(ORCID = "0000-0001-8804-4216"),
    role = "aut"
  )
  result <- individual2df(p)
  expect_equal(result$orcid, "0000-0001-8804-4216")
})

test_that("individual2df handles person object with affiliation", {
  p <- person(
    "John",
    "Doe",
    email = "john@example.com",
    comment = c(affiliation = "Test University"),
    role = "aut"
  )
  result <- individual2df(p)
  expect_equal(result$affiliation, "Test University")
})

test_that("individual2df handles person object with ROR", {
  p <- person(
    "John",
    "Doe",
    email = "john@example.com",
    comment = c(ROR = "00j54wy13"),
    role = "aut"
  )
  result <- individual2df(p)
  expect_equal(result$ror, "00j54wy13")
})

test_that("individual2df handles person object with multiple roles", {
  p <- person("John", "Doe", role = c("aut", "cre"))
  result <- individual2df(p)
  expect_equal(result$role, "aut, cre")
})

test_that("individual2df handles multiple persons", {
  p <- c(
    person("John", "Doe", email = "john@example.com", role = "aut"),
    person("Jane", "Smith", email = "jane@example.com", role = "ctb")
  )
  result <- individual2df(p)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_equal(result$given, c("John", "Jane"))
  expect_equal(result$family, c("Doe", "Smith"))
})

test_that("individual2df handles NULL input", {
  result <- individual2df(NULL)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
  expect_true("given" %in% names(result))
  expect_true("family" %in% names(result))
})

test_that("individual2df handles NA input", {
  result <- individual2df(NA)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("individual2df handles list of persons", {
  p_list <- list(
    person("John", "Doe", role = "aut"),
    person("Jane", "Smith", role = "ctb")
  )
  result <- individual2df(p_list)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
})

test_that("individual2df returns empty strings for missing fields", {
  p <- person("John", "Doe") # No email, orcid, affiliation, role
  result <- individual2df(p)
  expect_equal(result$email, "")
  expect_equal(result$orcid, "")
  expect_equal(result$affiliation, "")
})

test_that("individual2df character conversion works with warning", {
  expect_warning(
    result <- individual2df("John Doe"),
    "converted a character to a person"
  )
  expect_s3_class(result, "data.frame")
})

test_that("individual2df errors on unsupported types", {
  expect_error(individual2df(123), "not implemented")
  expect_error(individual2df(TRUE), "not implemented")
})
