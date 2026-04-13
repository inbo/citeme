test_that("validate_url validates correct URLs", {
  expect_true(validate_url("https://example.com"))
  expect_true(validate_url("http://example.com"))
  expect_true(validate_url("https://www.example.com"))
  expect_true(validate_url("https://subdomain.example.co.uk"))
  expect_true(validate_url("https://example.com/path/to/page"))
  expect_true(validate_url("https://example.com:8080/path"))
  expect_true(validate_url("https://example.com/path?query=value"))
})

test_that("validate_url rejects invalid URLs", {
  expect_false(validate_url("not-a-url"))
  expect_false(validate_url("ftp://example.com"))
  expect_false(validate_url("example.com"))
  expect_false(validate_url("https://"))
  expect_false(validate_url("https://.com"))
})

test_that("validate_url throws error for non-string input", {
  expect_error(validate_url(123), "`url` must be a string")
  expect_error(validate_url(NULL), "`url` must be a string")
  expect_error(validate_url(NA_character_), "`url` cannot be NA")
  expect_error(
    validate_url(c("https://a.com", "https://b.com")),
    "`url` must have length 1"
  )
})
