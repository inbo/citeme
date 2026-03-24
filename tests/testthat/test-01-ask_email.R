test_that("ask_email returns valid email on first try", {
  mockery::stub(ask_email, "readline", "test@example.com")
  result <- ask_email("Enter email: ")
  expect_equal(result, "test@example.com")
})

test_that("ask_email retries on invalid email", {
  # First call returns invalid, second returns valid
  readline_mock <- mockery::mock("invalid", "valid@example.com")
  mockery::stub(ask_email, "readline", readline_mock)
  expect_warning(
    result <- ask_email("Enter email: "),
    "Please enter a valid email"
  )
  expect_equal(result, "valid@example.com")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 2)
})

test_that("ask_email handles multiple retries", {
  readline_mock <- mockery::mock("bad", "also-bad", "good@test.org")
  mockery::stub(ask_email, "readline", readline_mock)
  expect_warning(
    expect_warning(
      result <- ask_email("Email: "),
      "Please enter a valid email"
    ),
    "Please enter a valid email"
  )
  expect_equal(result, "good@test.org")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 3)
})
