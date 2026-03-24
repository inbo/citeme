test_that("ask_language errors when org is not org_list", {
  expect_error(ask_language("not an org_list"), "not an `org_list` object")
  expect_error(ask_language(list()), "not an `org_list` object")
})

test_that("ask_language returns first language in non-interactive mode", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization", "nl-BE" = "Test Organisatie"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)

  # In non-interactive mode, menu_first returns 1
  result <- ask_language(ol)
  expect_equal(result, "en-GB")
})

test_that("ask_language returns selected language (interactive)", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization", "nl-BE" = "Test Organisatie"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)

  # Mock menu_first to return second option
  mockery::stub(ask_language, "menu_first", 2)
  result <- ask_language(ol)
  expect_equal(result, "nl-BE")
})

test_that("ask_language handles 'other' selection with valid input", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)

  # Menu returns 2 (which is "other" when only 1 language available)
  mockery::stub(ask_language, "menu_first", 2)
  mockery::stub(ask_language, "readline", "fr-FR")
  result <- ask_language(ol)
  expect_equal(result, "fr-FR")
})

test_that("ask_language retries on invalid language code", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)

  # Menu returns "other", first readline invalid, second valid
  mockery::stub(ask_language, "menu_first", 2)
  readline_mock <- mockery::mock("invalid", "de-DE")
  mockery::stub(ask_language, "readline", readline_mock)
  result <- ask_language(ol)
  expect_equal(result, "de-DE")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 2)
})
