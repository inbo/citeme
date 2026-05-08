# Test suite for is_tracked_not_modified() function
# This function checks if a file is tracked by git and not modified.

test_that("is_tracked_not_modified fails with non-string file", {
  expect_error(is_tracked_not_modified(123))
})

test_that("is_tracked_not_modified returns TRUE for non-repository", {
  # Use a temporary directory that is not a git repository
  temp_dir <- tempfile("not_a_repo")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  # Create a file in the temp directory
  temp_file <- file.path(temp_dir, "test.txt", fsep = "/")
  writeLines("test", temp_file)
  # Should return TRUE since no repository found
  expect_true(is_tracked_not_modified("test.txt", repo = temp_dir))
})

test_that("is_tracked_not_modified returns FALSE for untracked file", {
  # Create a temporary git repository
  temp_repo <- tempfile("test_repo")
  dir.create(temp_repo)
  on.exit(unlink(temp_repo, recursive = TRUE), add = TRUE)
  # Initialise git repository
  gert::git_init(path = temp_repo)
  gert::git_config_set("user.name", "Test User", repo = temp_repo)
  gert::git_config_set("user.email", "test@example.org", repo = temp_repo)
  # Create and commit a file
  tracked_file <- file.path(temp_repo, "tracked.txt", fsep = "/")
  writeLines("tracked content", tracked_file)
  gert::git_add("tracked.txt", repo = temp_repo)
  gert::git_commit("Initial commit", repo = temp_repo)
  # Create an untracked file
  untracked_file <- file.path(temp_repo, "untracked.txt", fsep = "/")
  writeLines("untracked content", untracked_file)
  # Test untracked file
  expect_false(is_tracked_not_modified("untracked.txt", repo = temp_repo))
})

test_that("is_tracked_not_modified returns TRUE for tracked unmodified file", {
  # Create a temporary git repository
  temp_repo <- tempfile("test_repo")
  dir.create(temp_repo)
  on.exit(unlink(temp_repo, recursive = TRUE), add = TRUE)
  # Initialise git repository
  gert::git_init(path = temp_repo)
  gert::git_config_set("user.name", "Test User", repo = temp_repo)
  gert::git_config_set("user.email", "test@example.org", repo = temp_repo)
  # Create and commit a file
  tracked_file <- file.path(temp_repo, "tracked.txt", fsep = "/")
  writeLines("tracked content", tracked_file)
  gert::git_add("tracked.txt", repo = temp_repo)
  gert::git_commit("Initial commit", repo = temp_repo)
  # Test tracked unmodified file
  expect_true(is_tracked_not_modified("tracked.txt", repo = temp_repo))
})

test_that("is_tracked_not_modified returns FALSE for modified file", {
  # Create a temporary git repository
  temp_repo <- tempfile("test_repo")
  dir.create(temp_repo)
  on.exit(unlink(temp_repo, recursive = TRUE), add = TRUE)
  # Initialise git repository
  gert::git_init(path = temp_repo)
  gert::git_config_set("user.name", "Test User", repo = temp_repo)
  gert::git_config_set("user.email", "test@example.org", repo = temp_repo)
  # Create and commit a file
  tracked_file <- file.path(temp_repo, "tracked.txt", fsep = "/")
  writeLines("tracked content", tracked_file)
  gert::git_add("tracked.txt", repo = temp_repo)
  gert::git_commit("Initial commit", repo = temp_repo)
  # Modify the file
  writeLines("modified content", tracked_file)
  # Test modified file
  expect_false(is_tracked_not_modified("tracked.txt", repo = temp_repo))
})
