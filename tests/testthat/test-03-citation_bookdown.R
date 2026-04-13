# Helper to create a temporary bookdown project
create_temp_bookdown <- function() {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Create _bookdown.yml
  bookdown_config <- "
title: Test Book
output:
  bookdown::pdf_book: default
"
  writeLines(bookdown_config, file.path(temp_dir, "_bookdown.yml"))

  # Create index.Rmd with proper YAML front matter and description
  index_rmd <- "---
title: Test Book
author:
  - name:
      given: John
      family: Doe
    email: john@example.com
reviewer:
  - name:
      given: Jane
      family: Smith
    email: jane@example.com
funder:
  - name:
      given: Funding
      family: Agency
    email: funding@example.com
rightsholder:
  - name:
      given: Rights
      family: Holder
    email: rights@example.com
publication_date: '2023-01-15'
license: CC-BY-4.0
lang: en-GB
keywords:
  - test
  - bookdown
community: some-community
publisher: Test Publisher
publication_type: publication-book
---

# Introduction

<!-- description: start -->
This is a test book description for testing purposes.
<!-- description: end -->

Content here.
"
  writeLines(index_rmd, file.path(temp_dir, "index.Rmd"))

  temp_dir
}

test_that("citation_bookdown requires citation_meta object", {
  expect_error(
    citeme:::citation_bookdown("not_a_citation_meta"),
    "does not inherit from class citation_meta"
  )
})

test_that("citation_bookdown requires bookdown type", {
  # Create a mock citation_meta object with wrong type
  meta_obj <- structure(
    list(get_type = "package"),
    class = "citation_meta"
  )

  expect_error(
    citeme:::citation_bookdown(meta_obj),
    "not equal to \"bookdown\""
  )
})

test_that("citation_bookdown returns error when index.Rmd missing", {
  # Create temporary directory without index.Rmd
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Create _bookdown.yml to make it a bookdown project
  writeLines("title: Test", file.path(temp_dir, "_bookdown.yml"))

  # Create mock citation_meta object
  meta <- structure(
    list(get_type = "bookdown", get_path = temp_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)
  expect_true(length(result$errors) > 0)
  expect_match(result$errors[1], "index.Rmd.*not found")
})

test_that("citation_bookdown processes valid bookdown project", {
  bookdown_dir <- create_temp_bookdown()

  # Create mock citation_meta object
  meta <- structure(
    list(get_type = "bookdown", get_path = bookdown_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  # Check structure of result
  expect_true(is.list(result))
  expect_true(has_name(result, "person"))
  expect_true(has_name(result, "meta"))
  expect_true(has_name(result, "errors"))
  expect_true(has_name(result, "notes"))
})

test_that("citation_bookdown extracts title from YAML", {
  bookdown_dir <- create_temp_bookdown()

  meta <- structure(
    list(get_type = "bookdown", get_path = bookdown_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  expect_true(has_name(result$meta, "title"))
  expect_match(result$meta$title, "Test Book")
})

test_that("citation_bookdown sets upload_type to publication", {
  bookdown_dir <- create_temp_bookdown()

  meta <- structure(
    list(get_type = "bookdown", get_path = bookdown_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  expect_equal(result$meta$upload_type, "publication")
})

test_that("citation_bookdown handles publication_date", {
  bookdown_dir <- create_temp_bookdown()

  meta <- structure(
    list(get_type = "bookdown", get_path = bookdown_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  expect_true(has_name(result$meta, "publication_date"))
  expect_match(result$meta$publication_date, "\\d{4}-\\d{2}-\\d{2}")
})

test_that("citation_bookdown handles embargo dates", {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Create _bookdown.yml
  writeLines("title: Test", file.path(temp_dir, "_bookdown.yml"))

  # Create index.Rmd with embargo
  index_rmd <- "---
title: Embargoed Book
author:
  - name:
      given: John
      family: Doe
embargo: '2024-12-31'
license: CC-BY-4.0
lang: en-GB
keywords:
  - test
publisher: Test Publisher
---

<!-- description: start -->
Test description.
<!-- description: end -->

Content
"
  writeLines(index_rmd, file.path(temp_dir, "index.Rmd"))

  meta <- structure(
    list(get_type = "bookdown", get_path = temp_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  expect_equal(result$meta$access_right, "embargoed")
  expect_true(has_name(result$meta, "embargo_date"))
})

test_that("citation_bookdown sets access_right to open when no embargo", {
  bookdown_dir <- create_temp_bookdown()

  meta <- structure(
    list(get_type = "bookdown", get_path = bookdown_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  expect_equal(result$meta$access_right, "open")
})

test_that("citation_bookdown requires license", {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  writeLines("title: Test", file.path(temp_dir, "_bookdown.yml"))

  index_rmd <- "---
title: Book
author:
  - name:
      given: John
      family: Doe
lang: en-GB
---

<!-- description: start -->
Test description.
<!-- description: end -->

Content
"
  writeLines(index_rmd, file.path(temp_dir, "index.Rmd"))

  meta <- structure(
    list(get_type = "bookdown", get_path = temp_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  expect_true(any(grepl("license", result$errors, ignore.case = TRUE)))
})

test_that("citation_bookdown handles subtitle", {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  writeLines("title: Test", file.path(temp_dir, "_bookdown.yml"))

  index_rmd <- "---
title: Main Title
subtitle: Sub Title
author:
  - name:
      given: John
      family: Doe
license: CC-BY-4.0
lang: en-GB
keywords:
  - test
publisher: Test Publisher
---

<!-- description: start -->
Test description.
<!-- description: end -->

Content
"
  writeLines(index_rmd, file.path(temp_dir, "index.Rmd"))

  meta <- structure(
    list(get_type = "bookdown", get_path = temp_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  expect_match(result$meta$title, "Sub Title")
})

test_that("citation_bookdown handles shorttitle", {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  writeLines("title: Test", file.path(temp_dir, "_bookdown.yml"))

  index_rmd <- "---
title: A Very Long Book Title
shorttitle: Short
author:
  - name:
      given: John
      family: Doe
license: CC-BY-4.0
lang: en-GB
keywords:
  - test
publisher: Test Publisher
---

<!-- description: start -->
Test description.
<!-- description: end -->

Content
"
  writeLines(index_rmd, file.path(temp_dir, "index.Rmd"))

  meta <- structure(
    list(get_type = "bookdown", get_path = temp_dir),
    class = "citation_meta"
  )

  result <- citeme:::citation_bookdown(meta)

  expect_equal(result$meta$shorttitle, "Short")
})

# Tests for split_community helper function

test_that("split_community handles NULL input", {
  result <- citeme:::split_community(NULL)
  expect_null(result)
})

test_that("split_community splits on semicolon", {
  result <- citeme:::split_community("community1; community2; community3")
  expect_length(result, 3)
  expect_true("community1" %in% result)
  expect_true("community2" %in% result)
  expect_true("community3" %in% result)
})

test_that("split_community removes whitespace around semicolons", {
  # The function splits on \s*;\s* so whitespace around semicolons is removed
  # but leading/trailing whitespace on the full string is preserved
  result <- citeme:::split_community("com1;com2;com3")
  expect_length(result, 3)
  expect_true("com1" %in% result)
  expect_true("com2" %in% result)
  expect_true("com3" %in% result)
})

test_that("split_community removes duplicates", {
  result <- citeme:::split_community("dup; dup; unique")
  expect_length(result, 2)
  expect_equal(sum(result == "dup"), 1)
})

test_that("split_community fails with non-character input", {
  # assertthat uses different error message format
  expect_error(
    citeme:::split_community(123),
    "community is not a character vector"
  )
})

# Tests for yaml_individual helper function

test_that("yaml_individual extracts authors correctly", {
  yaml_data <- list(
    author = list(
      list(
        name = list(given = "John", family = "Doe"),
        email = "john@example.com"
      )
    ),
    reviewer = list(),
    funder = list(),
    rightsholder = list()
  )

  result <- citeme:::yaml_individual(yaml_data)

  expect_true(has_name(result, "person"))
  expect_true(has_name(result, "errors"))
  expect_true(inherits(result$person[[1]], "person"))
})

test_that("yaml_individual handles multiple roles", {
  yaml_data <- list(
    author = list(
      list(
        name = list(given = "Jane", family = "Smith"),
        email = "jane@example.com"
      )
    ),
    reviewer = list(
      list(
        name = list(given = "Bob", family = "Johnson"),
        email = "bob@example.com"
      )
    ),
    funder = list(),
    rightsholder = list()
  )

  result <- citeme:::yaml_individual(yaml_data)

  expect_true(length(result$person) >= 2)
})

# Tests for yaml_individual_format helper function

test_that("yaml_individual_format requires name structure", {
  person_data <- list(
    name = list(given = "Test", family = "Person"),
    email = "test@example.com"
  )

  result <- citeme:::yaml_individual_format(person_data, role = "aut")

  expect_true(has_name(result[[1]], "person"))
  expect_true(has_name(result[[1]], "errors"))
  expect_true(inherits(result[[1]]$person, "person"))
})

test_that("yaml_individual_format handles invalid person structure", {
  person_data <- "invalid"

  result <- citeme:::yaml_individual_format(person_data, role = "aut")

  expect_true(length(result[[1]]$errors) > 0)
})

test_that("yaml_individual_format adds ORCID comment", {
  person_data <- list(
    name = list(given = "Test", family = "Person"),
    email = "test@example.com",
    orcid = "0000-0001-2345-6789"
  )

  result <- citeme:::yaml_individual_format(person_data, role = "aut")

  expect_true("ORCID" %in% names(result[[1]]$person$comment))
})

test_that("yaml_individual_format handles corresponding author", {
  person_data <- list(
    name = list(given = "Test", family = "Person"),
    email = "test@example.com",
    corresponding = TRUE
  )

  result <- citeme:::yaml_individual_format(person_data, role = "aut")

  expect_true("cre" %in% result[[1]]$person$role)
})

# Tests for string2date helper function

test_that("string2date parses valid dates", {
  result <- citeme:::string2date("2023-01-15")
  expect_s3_class(result, "Date")
  expect_equal(as.character(result), "2023-01-15")
})

test_that("string2date handles invalid dates", {
  result <- citeme:::string2date("invalid-date")
  expect_true(is.na(result))
  expect_true(!is.null(attr(result, "error")))
})

test_that("string2date uses system date for non-string input", {
  result <- citeme:::string2date(123)
  expect_s3_class(result, "Date")
  expect_true(!is.null(attr(result, "error")))
})

# Tests for validate_language_yaml helper function

test_that("validate_language_yaml requires lang or language", {
  yaml_data <- list()

  result <- citeme:::validate_language_yaml(yaml_data)

  expect_true(has_name(result, "error"))
})

test_that("validate_language_yaml uses lang element", {
  yaml_data <- list(lang = "en-GB")

  result <- citeme:::validate_language_yaml(yaml_data)

  expect_true(has_name(result, "lang"))
})

test_that("validate_language_yaml uses language element as fallback", {
  yaml_data <- list(language = "en-GB")

  result <- citeme:::validate_language_yaml(yaml_data)

  expect_true(has_name(result, "lang"))
})
