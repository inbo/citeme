test_that("menu_first returns 1 in non-interactive mode", {
  # In non-interactive mode, menu_first should return 1
  result <- menu_first(c("option1", "option2", "option3"))
  expect_equal(result, 1)
})

test_that("menu_first accepts graphics parameter", {
  result <- menu_first(
    c("option1", "option2"),
    graphics = FALSE
  )
  expect_equal(result, 1)
})

test_that("menu_first accepts title parameter", {
  result <- menu_first(
    c("option1", "option2"),
    title = "Select an option"
  )
  expect_equal(result, 1)
})
