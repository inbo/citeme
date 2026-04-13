test_that("validate_language validates correct language codes", {
  expect_equal(validate_language("en-GB"), "en-GB")
  expect_equal(validate_language("nl-BE"), "nl-BE")
  expect_equal(validate_language("fr-FR"), "fr-FR")
  expect_equal(validate_language("de-DE"), "de-DE")
})

test_that("validate_language rejects invalid language codes", {
  expect_error(
    validate_language("english"),
    "`language` must be in xx-YY format"
  )
  expect_error(
    validate_language("EN-gb"),
    "`language` must be in xx-YY format"
  )
  expect_error(
    validate_language("en_GB"),
    "`language` must be in xx-YY format"
  )
  expect_error(
    validate_language("e-GB"),
    "`language` must be in xx-YY format"
  )
  expect_error(
    validate_language("en-G"),
    "`language` must be in xx-YY format"
  )
})

test_that("validate_language throws error for non-string input", {
  expect_error(validate_language(123))
  expect_error(validate_language(NULL))
  expect_error(validate_language(NA_character_))
  expect_error(validate_language(c("en-GB", "nl-BE")))
})
