test_that("ask_ror returns valid ROR on first try", {
  mockery::stub(ask_ror, "readline", "00j54wy13")
  result <- ask_ror("Enter ROR: ")
  expect_equal(result, "00j54wy13")
})

test_that("ask_ror allows empty string", {
  mockery::stub(ask_ror, "readline", "")
  result <- ask_ror("Enter ROR: ")
  expect_equal(result, "")
})

test_that("ask_ror retries on invalid ROR", {
  readline_mock <- mockery::mock("https://ror.org/00j54wy13", "00j54wy13")
  mockery::stub(ask_ror, "readline", readline_mock)
  expect_warning(
    result <- ask_ror("ROR: "),
    "must be in `id` format"
  )
  expect_equal(result, "00j54wy13")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 2)
})

test_that("ask_ror handles multiple retries", {
  readline_mock <- mockery::mock("invalid!", "12345", "00j54wy13")
  mockery::stub(ask_ror, "readline", readline_mock)
  expect_warning(
    expect_warning(
      result <- ask_ror("ROR: "),
      "must be in `id` format"
    ),
    "must be in `id` format"
  )
  expect_equal(result, "00j54wy13")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 3)
})
