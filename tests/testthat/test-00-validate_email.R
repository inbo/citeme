test_that("validate_email validates correct email addresses", {
  expect_true(validate_email("test@example.com"))
  expect_true(validate_email("john.doe@example.org"))
  expect_true(validate_email("user.name+tag@domain.co.uk"))
  expect_true(validate_email("user@subdomain.domain.com"))
  expect_true(validate_email("info@inbo.be"))
})

test_that("validate_email rejects invalid email addresses", {
  expect_false(validate_email("not-an-email"))
  expect_false(validate_email("@domain.com"))
  expect_false(validate_email("user@"))
  expect_false(validate_email("user@.com"))
  expect_false(validate_email(""))
})

test_that("validate_email handles vectors of emails", {
  emails <- c("valid@example.com", "also.valid@test.org")
  expect_true(all(validate_email(emails)))

  mixed_emails <- c("valid@example.com", "invalid")
  results <- validate_email(mixed_emails)
  expect_true(results[1])
  expect_false(results[2])
})

test_that("validate_email throws error for non-character input", {
  expect_error(validate_email(123))
  expect_error(validate_email(NULL))
  expect_error(validate_email(TRUE))
})
