test_that("is_repository returns FALSE for non-git directory", {
  temp_dir <- tempdir()
  non_git_dir <- file.path(temp_dir, "test_non_git")
  dir.create(non_git_dir, showWarnings = FALSE)
  on.exit(unlink(non_git_dir, recursive = TRUE))

  expect_false(is_repository(non_git_dir))

  gert::git_init(non_git_dir)
  expect_true(is_repository(non_git_dir))
})
