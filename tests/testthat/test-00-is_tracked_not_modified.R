test_that("is_tracked_not_modified returns TRUE outside git repo", {
  temp_dir <- tempfile()
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE))
  file.create(file.path(temp_dir, "test.txt"))

  expect_true(is_tracked_not_modified("test.txt", repo = temp_dir))
})

test_that("is_tracked_not_modified requires string input", {
  expect_error(is_tracked_not_modified(123))
  expect_error(is_tracked_not_modified(NULL))
  expect_error(is_tracked_not_modified(c("a.txt", "b.txt")))
})
