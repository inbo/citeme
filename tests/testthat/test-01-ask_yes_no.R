test_that("ask_yes_no returns default in non-interactive mode", {
  # Non-interactive mode should return default
  result <- ask_yes_no("Question?", default = TRUE)
  expect_true(result)

  result <- ask_yes_no("Question?", default = FALSE)
  expect_false(result)
})

test_that("ask_yes_no validates msg parameter (interactive)", {
  mockery::stub(ask_yes_no, "interactive", TRUE)
  expect_error(ask_yes_no(123), "is not a string")
  expect_error(ask_yes_no(NA_character_), "missing")
})

test_that("ask_yes_no returns TRUE when user answers yes (interactive)", {
  mockery::stub(ask_yes_no, "interactive", TRUE)
  mockery::stub(ask_yes_no, "askYesNo", TRUE)
  result <- ask_yes_no("Continue?")
  expect_true(result)
})

test_that("ask_yes_no returns FALSE when user answers no (interactive)", {
  mockery::stub(ask_yes_no, "interactive", TRUE)
  mockery::stub(ask_yes_no, "askYesNo", FALSE)
  result <- ask_yes_no("Continue?")
  expect_false(result)
})

test_that("ask_yes_no retries on NULL answer (interactive)", {
  mockery::stub(ask_yes_no, "interactive", TRUE)
  ask_mock <- mockery::mock(NULL, TRUE)
  mockery::stub(ask_yes_no, "askYesNo", ask_mock)
  expect_warning(
    result <- ask_yes_no("Continue?"),
    "Please answer with"
  )
  expect_true(result)
  expect_equal(mockery::mock_calls(ask_mock) |> length(), 2)
})

test_that("ask_yes_no retries on error (interactive)", {
  mockery::stub(ask_yes_no, "interactive", TRUE)
  ask_mock <- mockery::mock(
    structure("error", class = c("try-error", "character")),
    FALSE
  )
  mockery::stub(ask_yes_no, "askYesNo", ask_mock)
  expect_warning(
    result <- ask_yes_no("Continue?"),
    "Please answer with"
  )
  expect_false(result)
})
