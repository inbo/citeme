test_that("ask_url returns valid URL on first try", {
  mockery::stub(ask_url, "readline", "https://example.com")
  result <- ask_url("Enter URL: ")
  expect_equal(result, "https://example.com")
})

test_that("ask_url allows empty string", {
  mockery::stub(ask_url, "readline", "")
  result <- ask_url("Enter URL: ")
  expect_equal(result, "")
})

test_that("ask_url retries on invalid URL", {
  readline_mock <- mockery::mock("not-a-url", "https://valid.org")
  mockery::stub(ask_url, "readline", readline_mock)
  expect_warning(
    result <- ask_url("URL: "),
    "Please enter a valid URL"
  )
  expect_equal(result, "https://valid.org")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 2)
})

test_that("ask_url handles multiple retries", {
  readline_mock <- mockery::mock("bad", "also bad", "http://good.com")
  mockery::stub(ask_url, "readline", readline_mock)
  expect_warning(
    expect_warning(
      result <- ask_url("URL: "),
      "Please enter a valid URL"
    ),
    "Please enter a valid URL"
  )
  expect_equal(result, "http://good.com")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 3)
})
