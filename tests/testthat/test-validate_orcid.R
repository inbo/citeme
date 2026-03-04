test_that("validate_orcid validates correct ORCID format with checksum", {
  # Valid ORCIDs with correct checksum
  expect_true(validate_orcid("0000-0001-8804-4216"))  # Real ORCID from DESCRIPTION
  expect_true(validate_orcid("0000-0002-1825-0097"))
  expect_true(validate_orcid("0000-0002-9079-593X"))  # ORCID with X checksum
})

test_that("validate_orcid allows empty string", {
  expect_true(validate_orcid(""))
})

test_that("validate_orcid rejects invalid ORCID format", {
  # Wrong format
  expect_false(validate_orcid("0000-0000-0000-000"))   # Too short
  expect_false(validate_orcid("0000-0000-0000-00001")) # Too long
  expect_false(validate_orcid("0000-000-0000-0000"))   # Wrong grouping
  expect_false(validate_orcid("0000000000000000"))     # No dashes
  expect_false(validate_orcid("ABCD-0000-0000-0000"))  # Non-numeric prefix
})

test_that("validate_orcid rejects ORCID with wrong checksum", {
  # Valid format but wrong checksum
  expect_false(validate_orcid("0000-0001-8804-4210"))  # Changed last digit
  expect_false(validate_orcid("0000-0000-0000-0000"))  # All zeros (invalid checksum)
})

test_that("validate_orcid handles vectors of ORCIDs", {
  orcids <- c("0000-0001-8804-4216", "")
  expect_true(all(validate_orcid(orcids)))

  mixed_orcids <- c("0000-0001-8804-4216", "invalid-orcid")
  results <- validate_orcid(mixed_orcids)
  expect_true(results[1])
  expect_false(results[2])
})

test_that("validate_orcid throws error for non-character input", {
  expect_error(validate_orcid(123))
  expect_error(validate_orcid(NULL))
  expect_error(validate_orcid(NA))
})
