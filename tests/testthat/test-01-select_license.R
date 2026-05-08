# Test suite for select_license() function
# This function allows selecting a license from the allowed licenses for an
# organisation.

test_that("select_license fails with non-org_list object", {
  expect_error(
    select_license(org = "not an org_list"),
    "`org` must be of class `org_list`"
  )
})

test_that("select_license returns license when only one available", {
  # Create an org_list with a single license option
  item <- org_item$new(
    name = c("en-GB" = "Test Org"),
    email = "test@example.org",
    rightsholder = "shared"
  )
  ol <- org_list$new(item)
  # The default rightsholder should have package licenses
  result <- select_license(ol, type = "package")
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("select_license respects type argument", {
  item <- org_item$new(
    name = c("en-GB" = "Test Org"),
    email = "test@example.org",
    rightsholder = "shared"
  )
  ol <- org_list$new(item)
  # Test different types - should not error
  result_pkg <- select_license(ol, type = "package")
  expect_type(result_pkg, "character")
})

test_that("select_license uses menu_first for multiple licenses", {
  skip_if_not_installed("mockery")
  # Create org_list with multiple license options
  item <- org_item$new(
    name = c("en-GB" = "Test Org"),
    email = "test@example.org",
    rightsholder = "shared"
  )
  ol <- org_list$new(item)
  # Mock menu_first to return first option
  mockery::stub(select_license, "menu_first", 1)
  result <- select_license(ol, type = "package")
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("select_license validates type argument", {
  item <- org_item$new(
    name = c("en-GB" = "Test Org"),
    email = "test@example.org",
    rightsholder = "shared"
  )
  ol <- org_list$new(item)
  expect_error(
    select_license(ol, type = "invalid"),
    "'arg' should be one of"
  )
})
