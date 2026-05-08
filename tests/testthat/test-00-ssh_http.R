# Test suite for ssh_http() function
# This function converts git SSH URLs to HTTP URLs and removes OAuth2 tokens.

test_that("ssh_http converts SSH URL to HTTPS URL", {
  # SSH URL format: git@host:user/repo
  result <- ssh_http("git@github.com:inbo/citeme")
  expect_equal(result, "https://github.com/inbo")
})

test_that("ssh_http keeps HTTPS URL but extracts organisation root", {
  result <- ssh_http("https://github.com/inbo/citeme")
  expect_equal(result, "https://github.com/inbo")
})

test_that("ssh_http removes OAuth2 token from URL", {
  # OAuth2 tokens appear as oauth2:TOKEN@host
  result <- ssh_http("https://oauth2:sometoken123@github.com/inbo/citeme")
  expect_equal(result, "https://github.com/inbo")
})

test_that("ssh_http handles GitLab SSH URLs", {
  result <- ssh_http("git@gitlab.com:organisation/project")
  expect_equal(result, "https://gitlab.com/organisation")
})

test_that("ssh_http handles URLs with nested paths", {
  result <- ssh_http("https://github.com/inbo/citeme/tree/main/R")
  expect_equal(result, "https://github.com/inbo")
})

test_that("ssh_http handles SSH URL with .git suffix", {
  result <- ssh_http("git@github.com:inbo/citeme.git")
  expect_equal(result, "https://github.com/inbo")
})

test_that("ssh_http handles HTTPS URL with .git suffix", {
  result <- ssh_http("https://github.com/inbo/citeme.git")
  expect_equal(result, "https://github.com/inbo")
})
