# Test suite for modified_citation_file()
# This function returns a message when the citation file is modified,
# `character(0)` when it is unmodified, and `character(0)` when `base_path`
# is outside a git repository.

test_that("modified_citation_file returns character(0) outside a repository", {
  # Use a temporary directory that is not a git repository
  temp_dir <- tempfile("not_a_repo")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  writeLines("test", file.path(temp_dir, "CITATION.cff", fsep = "/"))
  expect_identical(
    modified_citation_file("CITATION.cff", base_path = temp_dir),
    character(0)
  )
})

test_that("modified_citation_file returns character(0) for unmodified file", {
  # Create a temporary git repository
  temp_repo <- tempfile("test_repo")
  dir.create(temp_repo)
  on.exit(unlink(temp_repo, recursive = TRUE), add = TRUE)
  gert::git_init(path = temp_repo)
  gert::git_config_set("user.name", "Test User", repo = temp_repo)
  gert::git_config_set("user.email", "test@example.org", repo = temp_repo)
  # Create and commit the citation file
  writeLines("cite", file.path(temp_repo, "CITATION.cff", fsep = "/"))
  gert::git_add("CITATION.cff", repo = temp_repo)
  gert::git_commit("Initial commit", repo = temp_repo)
  expect_identical(
    modified_citation_file("CITATION.cff", base_path = temp_repo),
    character(0)
  )
})

test_that("modified_citation_file returns a message for a modified file", {
  # Create a temporary git repository
  temp_repo <- tempfile("test_repo")
  dir.create(temp_repo)
  on.exit(unlink(temp_repo, recursive = TRUE), add = TRUE)
  gert::git_init(path = temp_repo)
  gert::git_config_set("user.name", "Test User", repo = temp_repo)
  gert::git_config_set("user.email", "test@example.org", repo = temp_repo)
  # Create and commit the citation file, then modify it
  citation_path <- file.path(temp_repo, "CITATION.cff", fsep = "/")
  writeLines("cite", citation_path)
  gert::git_add("CITATION.cff", repo = temp_repo)
  gert::git_commit("Initial commit", repo = temp_repo)
  writeLines("modified", citation_path)
  expect_identical(
    modified_citation_file("CITATION.cff", base_path = temp_repo),
    "CITATION.cff is modified. Please commit changes."
  )
})

test_that("modified_citation_file works when base_path is a subdirectory", {
  # Create a temporary git repository with the citation file in a subdirectory
  temp_repo <- tempfile("test_repo")
  dir.create(temp_repo)
  on.exit(unlink(temp_repo, recursive = TRUE), add = TRUE)
  gert::git_init(path = temp_repo)
  gert::git_config_set("user.name", "Test User", repo = temp_repo)
  gert::git_config_set("user.email", "test@example.org", repo = temp_repo)
  sub_dir <- file.path(temp_repo, "inst", fsep = "/")
  dir.create(sub_dir)
  writeLines("cite", file.path(sub_dir, "CITATION.cff", fsep = "/"))
  gert::git_add("inst/CITATION.cff", repo = temp_repo)
  gert::git_commit("Initial commit", repo = temp_repo)
  # `base_path` is the subdirectory, so the path must be resolved relative to
  # the repository root before checking git status.
  expect_identical(
    modified_citation_file("CITATION.cff", base_path = sub_dir),
    character(0)
  )
})
