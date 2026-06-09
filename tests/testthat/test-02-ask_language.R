test_that("ask_language returns first language in non-interactive mode", {
  # In non-interactive mode, menu_first returns 1
  result <- ask_language(c("en-GB", "nl-BE"))
  expect_equal(result, "en-GB")
})

test_that("ask_language returns selected language (interactive)", {
  # Mock menu_first to return second option
  mockery::stub(ask_language, "menu_first", 2)
  result <- ask_language(c("en-GB", "nl-BE"))
  expect_equal(result, "nl-BE")
})

test_that("ask_language handles 'other' selection with valid input", {
  # Menu returns 2 (which is "other" when only 1 language available)
  mockery::stub(ask_language, "menu_first", 2)
  mockery::stub(ask_language, "readline", "fr-FR")
  result <- ask_language("en-GB")
  expect_equal(result, "fr-FR")
})

test_that("ask_language retries on invalid language code", {
  # Menu returns "other", first readline invalid, second valid
  mockery::stub(ask_language, "menu_first", 2)
  readline_mock <- mockery::mock("invalid", "de-DE")
  mockery::stub(ask_language, "readline", readline_mock)
  result <- ask_language("en-GB")
  expect_equal(result, "de-DE")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 2)
})
