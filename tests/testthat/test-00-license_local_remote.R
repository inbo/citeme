# Test suite for license_local_remote() function
# This function creates a data frame mapping local license file names to remote
# license URLs.

test_that("license_local_remote creates correct data frame structure", {
  license <- c("GPL-3.0" = "https://example.com/licenses/gpl-3.0.md")
  result <- license_local_remote(license)
  expect_s3_class(result, "data.frame")
  expect_named(result, c("local_file", "remote_file"))
  expect_equal(nrow(result), 1)
})

test_that("license_local_remote converts license name to lowercase filename", {
  license <- c("GPL-3.0" = "https://example.com/licenses/gpl-3.0.md")
  result <- license_local_remote(license)
  expect_equal(result$local_file, "gpl_3.0.md")
})

test_that("license_local_remote replaces spaces with underscores", {
  license <- c("Creative Commons" = "https://example.com/licenses/cc.md")
  result <- license_local_remote(license)
  expect_equal(result$local_file, "creative_commons.md")
})

test_that("license_local_remote replaces hyphens with underscores", {
  license <- c("CC-BY-4.0" = "https://example.com/licenses/cc-by-4.0.md")
  result <- license_local_remote(license)
  expect_equal(result$local_file, "cc_by_4.0.md")
})

test_that("license_local_remote preserves remote URL unchanged", {
  remote_url <- "https://example.com/licenses/gpl-3.0.md"
  license <- c("GPL-3.0" = remote_url)
  result <- license_local_remote(license)
  expect_equal(result$remote_file, remote_url)
})

test_that("license_local_remote handles multiple licenses", {
  licenses <- c(
    "GPL-3.0" = "https://example.com/licenses/gpl-3.0.md",
    "MIT" = "https://example.com/licenses/mit.md",
    "CC-BY-4.0" = "https://example.com/licenses/cc-by-4.0.md"
  )
  result <- license_local_remote(licenses)
  expect_equal(nrow(result), 3)
  expect_equal(result$local_file, c("gpl_3.0.md", "mit.md", "cc_by_4.0.md"))
  expect_equal(result$remote_file, unname(licenses))
})
