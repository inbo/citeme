test_that("org_item creates valid object with minimal parameters", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  expect_s3_class(item, "org_item")
  expect_equal(unname(item$get_email), "test@example.org")
  expect_equal(unname(item$get_default_name), "Test Organization")
})

test_that("org_item creates INBO object when @inbo.be email is used", {
  item <- org_item$new(
    email = "someone@inbo.be",
    name = c("en-GB" = "Ignored Name")
  )
  expect_s3_class(item, "org_item")
  expect_equal(unname(item$get_email), "info@inbo.be")
  expect_equal(
    item$get_name["en-GB"],
    c("en-GB" = "Research Institute for Nature and Forest (INBO)")
  )
  expect_true(item$get_orcid)
})

test_that("org_item correctly stores multiple language names", {
  item <- org_item$new(
    name = c(
      "en-GB" = "Test Organization",
      "nl-BE" = "Test Organisatie"
    ),
    email = "test@example.org"
  )
  expect_equal(length(item$get_name), 2)
  expect_equal(item$get_name["en-GB"], c("en-GB" = "Test Organization"))
  expect_equal(item$get_name["nl-BE"], c("nl-BE" = "Test Organisatie"))
})

test_that("org_item defaults orcid to FALSE", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  expect_false(item$get_orcid)
})

test_that("org_item respects orcid parameter", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org",
    orcid = TRUE
  )
  expect_true(item$get_orcid)
})

test_that("org_item stores rightsholder and funder settings", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org",
    rightsholder = "shared",
    funder = "when no other"
  )
  expect_equal(item$get_rightsholder, "shared")
  expect_equal(item$get_funder, "when no other")
})

test_that("org_item fails with invalid email", {
  expect_error(
    org_item$new(
      name = c("en-GB" = "Test"),
      email = "not-an-email"
    ),
    "invalid email"
  )
})

test_that("org_item fails with empty email", {
  expect_error(
    org_item$new(
      name = c("en-GB" = "Test"),
      email = ""
    ),
    "`email` cannot be empty"
  )
})

test_that("org_item compare_by_name returns Inf for exact match", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  result <- item$compare_by_name("Test Organization")
  expect_equal(attr(result, "match"), Inf)
})

test_that("org_item compare_by_name returns ratio for partial match", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization Name"),
    email = "test@example.org"
  )
  result <- item$compare_by_name("Test Name")
  expect_true(attr(result, "match") > 0)
  expect_true(attr(result, "match") < Inf)
})

test_that("org_item get_license returns correct licenses by type", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  package_license <- item$get_license("package")
  expect_true(length(package_license) > 0)
  expect_true("GPL-3.0" %in% names(package_license) ||
                "GPL-3" %in% names(package_license))
})

test_that("org_item as_list returns correct structure", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org",
    orcid = TRUE,
    rightsholder = "single",
    funder = "optional"
  )
  result <- item$as_list
  expect_type(result, "list")
  expect_true("name" %in% names(result))
  expect_true("email" %in% names(result))
  expect_true("orcid" %in% names(result))
  expect_true("rightsholder" %in% names(result))
  expect_true("funder" %in% names(result))
})

test_that("org_item as_person returns person object", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  person_obj <- item$as_person(role = "cph")
  expect_s3_class(person_obj, "person")
})
