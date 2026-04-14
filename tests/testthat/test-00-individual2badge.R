# Test suite for individual2badge() function
# This function creates markdown badges for individuals with ORCID, email,
# and affiliation information.

test_that("individual2badge creates basic badge without ORCID or email", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    orcid = "",
    email = "",
    affiliation = ""
  )
  result <- individual2badge(individual, role = "aut")
  expect_true(grepl("Doe, John", result))
  expect_true(grepl("\\[\\^aut\\]", result))
})

test_that("individual2badge creates badge with email link", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    orcid = "",
    email = "john.doe@example.org",
    affiliation = ""
  )
  result <- individual2badge(individual, role = "aut")
  expect_true(grepl("mailto:", result))
  expect_true(grepl("john.doe%40example.org", result))
})

test_that("individual2badge creates badge with ORCID link", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    orcid = "0000-0001-2345-6789",
    email = "",
    affiliation = ""
  )
  result <- individual2badge(individual, role = "aut")
  expect_true(grepl("orcid.org/0000-0001-2345-6789", result))
  expect_true(grepl("ORCID logo", result))
})

test_that("individual2badge adds affiliation footnote", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    orcid = "",
    email = "",
    affiliation = "Test University"
  )
  result <- individual2badge(individual, role = "aut")
  footnotes <- attr(result, "footnote")
  expect_true(any(grepl("Test University", footnotes)))
})

test_that("individual2badge handles multiple roles", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    orcid = "",
    email = "",
    affiliation = ""
  )
  result <- individual2badge(individual, role = c("aut", "cre"))
  expect_true(grepl("\\[\\^aut\\]", result))
  expect_true(grepl("\\[\\^cre\\]", result))
})

test_that("individual2badge creates proper footnote for author role", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    orcid = "",
    email = "",
    affiliation = ""
  )
  result <- individual2badge(individual, role = "aut")
  footnotes <- attr(result, "footnote")
  expect_true(any(grepl("\\[\\^aut\\]: author", footnotes)))
})

test_that("individual2badge creates proper footnote for contact person role", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    orcid = "",
    email = "",
    affiliation = ""
  )
  result <- individual2badge(individual, role = "cre")
  footnotes <- attr(result, "footnote")
  expect_true(any(grepl("\\[\\^cre\\]: contact person", footnotes)))
})

test_that("individual2badge handles individual without family name", {
  # Organisation without family name
  individual <- data.frame(
    given = "Test Organisation",
    family = "",
    orcid = "",
    email = "info@test.org",
    affiliation = ""
  )
  result <- individual2badge(individual, role = "cph")
  expect_true(grepl("Test Organisation", result))
})

test_that("individual2badge extracts abbreviation from affiliation", {
  # Affiliation with abbreviation in parentheses
  individual <- data.frame(
    given = "John",
    family = "Doe",
    orcid = "",
    email = "",
    affiliation = "Research Institute for Nature and Forest (INBO)"
  )
  result <- individual2badge(individual, role = "aut")
  footnotes <- attr(result, "footnote")
  # The abbreviation INBO should be extracted from parentheses
  expect_true(any(grepl("INBO", footnotes)))
})

test_that("individuals2badge handles data frame with multiple rows", {
  individuals <- data.frame(
    given = c("John", "Jane"),
    family = c("Doe", "Smith"),
    orcid = c("", ""),
    email = c("", ""),
    affiliation = c("", "")
  )
  result <- individual2badge(individuals, role = "aut")
  expect_length(result, 2)
  expect_true(grepl("Doe, John", result[1]))
  expect_true(grepl("Smith, Jane", result[2]))
})

test_that("individuals2badge handles role column in data frame", {
  individuals <- data.frame(
    given = c("John", "Jane"),
    family = c("Doe", "Smith"),
    orcid = c("", ""),
    email = c("", ""),
    affiliation = c("", ""),
    role = c("aut, cre", "aut")
  )
  result <- individual2badge(individuals, role = "aut")
  # The role column should be used when present
  footnotes <- attr(result, "footnote")
  expect_true(any(grepl("\\[\\^cre\\]", footnotes)))
})
