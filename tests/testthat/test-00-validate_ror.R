test_that("validate_ror validates correct ROR format", {
  # Valid ROR examples
  expect_true(validate_ror("0abcdef12"))
  expect_true(validate_ror("01an7q238"))
  expect_true(validate_ror("0xyzabc99"))
})

test_that("validate_ror rejects invalid ROR format", {
  # Must start with 0
  expect_false(validate_ror("1abcdef12"))
  # Too short
  expect_false(validate_ror("0abcde12"))
  # Too long
  expect_false(validate_ror("0abcdefg123"))
  # Contains invalid characters (i, l, o)
  expect_false(validate_ror("0abcdei12"))
  expect_false(validate_ror("0abcdel12"))
  expect_false(validate_ror("0abcdeo12"))
  # Wrong ending (must be 2 digits)
  expect_false(validate_ror("0abcdef1a"))
})

test_that("validate_ror throws error for non-string input", {
  expect_error(validate_ror(123), "`ror` must be a string")
  expect_error(validate_ror(NULL), "`ror` must be a string")
  expect_error(validate_ror(NA_character_), "`ror` cannot be NA")
  expect_error(
    validate_ror(c("0abcdef12", "0xyzabc99")),
    "`ror` must be a string"
  )
})
