test_that("ask_new_license returns empty when 'No license' selected first", {
  licenses <- c("GPL-3" = "https://example.com/gpl3.md")

  # Selection 3 = "No license" (licenses + "Other" + "No license")
  mockery::stub(ask_new_license, "menu_first", 3)
  result <- ask_new_license(licenses, type = "package")
  expect_length(result, 0)
})

test_that("ask_new_license returns selected license", {
  licenses <- c(
    "GPL-3" = "https://example.com/gpl3.md",
    "MIT" = "https://example.com/mit.md"
  )

  # First selection: GPL-3 (1), then ask_yes_no returns FALSE
  mockery::stub(ask_new_license, "menu_first", 1)
  mockery::stub(ask_new_license, "ask_yes_no", FALSE)
  result <- ask_new_license(licenses, type = "package")
  expect_equal(result, c("GPL-3" = "https://example.com/gpl3.md"))
})

test_that("ask_new_license handles multiple license selections", {
  licenses <- c(
    "GPL-3" = "https://example.com/gpl3.md",
    "MIT" = "https://example.com/mit.md"
  )

  # Select GPL-3 first, then MIT (now position 1 since GPL-3 removed)
  menu_mock <- mockery::mock(1, 1, 4)
  mockery::stub(ask_new_license, "menu_first", menu_mock)
  # First ask_yes_no: add another? TRUE, Second: FALSE

  yes_no_mock <- mockery::mock(TRUE, FALSE)
  mockery::stub(ask_new_license, "ask_yes_no", yes_no_mock)
  result <- ask_new_license(licenses, type = "project")
  expect_length(result, 2)
  expect_true("GPL-3" %in% names(result))
  expect_true("MIT" %in% names(result))
})

test_that("ask_new_license handles 'Other license' selection", {
  licenses <- c("GPL-3" = "https://example.com/gpl3.md")

  # Select "Other license" (position 2)
  mockery::stub(ask_new_license, "menu_first", 2)
  # readline: first for abbreviation, second for URL
  readline_mock <- mockery::mock("Custom", "https://example.com/custom.md")
  mockery::stub(ask_new_license, "readline", readline_mock)
  mockery::stub(ask_new_license, "ask_yes_no", FALSE)
  result <- ask_new_license(licenses, type = "data")
  expect_equal(result, c("Custom" = "https://example.com/custom.md"))
})

test_that("ask_new_license validates type argument", {
  licenses <- c("GPL-3" = "https://example.com/gpl3.md")
  mockery::stub(ask_new_license, "menu_first", 3)
  expect_error(ask_new_license(licenses, type = "invalid"), "should be one of")
})
