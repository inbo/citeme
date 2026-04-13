test_that("validate_license validates correct license list", {
  valid_license <- list(
    package = c("MIT" = "MIT"),
    project = c("CC-BY-4.0" = "CC BY 4.0"),
    data = c("CC0-1.0" = "CC0 1.0")
  )
  expect_silent(validate_license(valid_license))
})

test_that("validate_license accepts empty vectors", {
  valid_license <- list(
    package = character(0),
    project = character(0),
    data = character(0)
  )
  expect_silent(validate_license(valid_license))
})

test_that("validate_license rejects non-list input", {
  expect_error(
    validate_license("not a list"),
    "`license` must be a list"
  )
  expect_error(
    validate_license(c(package = "MIT")),
    "`license` must be a list"
  )
})

test_that("validate_license rejects missing required elements", {
  expect_error(
    validate_license(list(package = c("MIT" = "MIT"))),
    "`license` must contain `package`, `project`, and `data`"
  )
  expect_error(
    validate_license(list(package = c("MIT" = "MIT"), project = c("a" = "b"))),
    "`license` must contain `package`, `project`, and `data`"
  )
})

test_that("validate_license rejects non-character vectors", {
  expect_error(
    validate_license(list(package = 1, project = 2, data = 3)),
    "`license` must contain character vectors"
  )
})

test_that("validate_license rejects unnamed vectors", {
  expect_error(
    validate_license(list(package = "MIT", project = "CC-BY", data = "CC0")),
    "`license` must contain named vectors"
  )
})

test_that("validate_license rejects duplicate names", {
  expect_error(
    validate_license(list(
      package = c("MIT" = "MIT", "MIT" = "MIT2"),
      project = c("a" = "b"),
      data = c("c" = "d")
    )),
    "`license` must contain uniquely named vectors"
  )
})

test_that("validate_license rejects duplicate license values", {
  expect_error(
    validate_license(list(
      package = c("MIT1" = "MIT", "MIT2" = "MIT"),
      project = c("a" = "b"),
      data = c("c" = "d")
    )),
    "`license` must contain vectors with unique licenses"
  )
})
