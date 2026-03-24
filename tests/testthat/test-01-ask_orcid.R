test_that("ask_orcid returns valid orcid on first try", {
  mockery::stub(ask_orcid, "readline", "0000-0001-8804-4216")
  result <- ask_orcid()
  expect_equal(result, "0000-0001-8804-4216")
})

test_that("ask_orcid allows empty string", {
  mockery::stub(ask_orcid, "readline", "")
  result <- ask_orcid()
  expect_equal(result, "")
})

test_that("ask_orcid retries on invalid orcid", {
  readline_mock <- mockery::mock("invalid", "0000-0001-8804-4216")
  mockery::stub(ask_orcid, "readline", readline_mock)
  expect_warning(
    result <- ask_orcid(),
    "Please provide a valid ORCiD"
  )
  expect_equal(result, "0000-0001-8804-4216")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 2)
})

test_that("ask_orcid handles multiple retries", {
  readline_mock <- mockery::mock(
    "bad", "0000-0000-0000-0000", "0000-0002-1825-0097"
  )
  mockery::stub(ask_orcid, "readline", readline_mock)
  expect_warning(
    expect_warning(
      result <- ask_orcid("orcid: "),
      "Please provide a valid ORCiD"
    ),
    "Please provide a valid ORCiD"
  )
  expect_equal(result, "0000-0002-1825-0097")
  expect_equal(mockery::mock_calls(readline_mock) |> length(), 3)
})
