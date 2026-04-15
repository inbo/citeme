# Test suite for add_individual() and helper functions
# Tests for determining file types and adding individuals to various file
# formats (DESCRIPTION, README, Quarto, bookdown)

# Tests for determine_type() --------------------------------------------------

test_that("determine_type validates path argument", {
  expect_error(
    citeme:::determine_type(c("a", "b")),
    "`path` must be a single string"
  )
  expect_error(
    citeme:::determine_type(123),
    "`path` must be a single string"
  )
  expect_error(
    citeme:::determine_type(NA_character_),
    "`path` must be a single string"
  )
  expect_error(
    citeme:::determine_type("nonexistent_path"),
    "`path` does not exist"
  )
})

test_that("determine_type identifies DESCRIPTION files", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  desc_file <- file.path(temp_dir, "DESCRIPTION")
  writeLines("Package: test", desc_file)
  result <- citeme:::determine_type(desc_file)
  expect_equal(names(result), "description")
  expect_equal(unname(result), desc_file)
})

test_that("determine_type identifies _quarto.yml files", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  quarto_file <- file.path(temp_dir, "_quarto.yml")
  writeLines("project:\n  type: book", quarto_file)
  result <- citeme:::determine_type(quarto_file)
  expect_equal(names(result), "quarto")
  expect_equal(unname(result), quarto_file)
})

test_that("determine_type identifies .qmd files", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)

  qmd_file <- file.path(temp_dir, "chapter.qmd")
  writeLines("---\ntitle: Test\n---", qmd_file)
  result <- citeme:::determine_type(qmd_file)
  expect_equal(names(result), "quarto")
  expect_equal(unname(result), qmd_file)
})

test_that("determine_type identifies README.md files", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  readme_file <- file.path(temp_dir, "README.md")
  writeLines("# Test", readme_file)
  result <- citeme:::determine_type(readme_file)
  expect_equal(names(result), "readme")
  expect_equal(unname(result), readme_file)
})

test_that("determine_type identifies README.Rmd files", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  readme_file <- file.path(temp_dir, "README.Rmd")
  writeLines("# Test", readme_file)
  result <- citeme:::determine_type(readme_file)
  expect_equal(names(result), "readme")
  expect_equal(unname(result), readme_file)
})

test_that("determine_type identifies index.md as quarto", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  index_file <- file.path(temp_dir, "index.md")
  writeLines("# Book Title", index_file)
  result <- citeme:::determine_type(index_file)
  expect_equal(names(result), "quarto")
  expect_equal(unname(result), index_file)
})

test_that("determine_type identifies index.Rmd as quarto", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  index_file <- file.path(temp_dir, "index.Rmd")
  writeLines("# Book Title", index_file)
  result <- citeme:::determine_type(index_file)
  expect_equal(names(result), "quarto")
  expect_equal(unname(result), index_file)
})

test_that("determine_type errors on unsupported file type", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  unsupported <- file.path(temp_dir, "script.R")
  writeLines("x <- 1", unsupported)
  expect_error(
    citeme:::determine_type(unsupported),
    "no supported file found in `path`"
  )
})

test_that("determine_type finds DESCRIPTION in directory", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  desc_file <- file.path(temp_dir, "DESCRIPTION")
  writeLines("Package: test", desc_file)
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "description")
  expect_equal(unname(result), desc_file)
})

test_that("determine_type finds _quarto.yml in directory", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  quarto_file <- file.path(temp_dir, "_quarto.yml")
  writeLines("project:\n  type: book", quarto_file)
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "quarto")
  expect_equal(unname(result), quarto_file)
})

test_that("determine_type finds index.Rmd in directory", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  index_file <- file.path(temp_dir, "index.Rmd")
  writeLines("# Book", index_file)
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "quarto")
  expect_equal(unname(result), index_file)
})

test_that("determine_type finds index.md in directory", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  index_file <- file.path(temp_dir, "index.md")
  writeLines("# Book", index_file)
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "quarto")
  expect_equal(unname(result), index_file)
})

test_that("determine_type finds README.Rmd in directory", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  readme_file <- file.path(temp_dir, "README.Rmd")
  writeLines("# README", readme_file)
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "readme")
  expect_equal(unname(result), readme_file)
})

test_that("determine_type finds README.md in directory", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  readme_file <- file.path(temp_dir, "README.md")
  writeLines("# README", readme_file)
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "readme")
  expect_equal(unname(result), readme_file)
})

test_that("determine_type errors on empty directory", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  expect_error(
    citeme:::determine_type(temp_dir),
    "no supported file found"
  )
})

test_that("determine_type prioritises quarto over other files", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  # Create multiple file types
  writeLines("Package: test", file.path(temp_dir, "DESCRIPTION"))
  writeLines("# README", file.path(temp_dir, "README.md"))
  writeLines("project:", file.path(temp_dir, "_quarto.yml"))
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "quarto")
})

test_that("determine_type prioritises index over DESCRIPTION and README", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  writeLines("Package: test", file.path(temp_dir, "DESCRIPTION"))
  writeLines("# README", file.path(temp_dir, "README.md"))
  writeLines("# Index", file.path(temp_dir, "index.Rmd"))
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "quarto")
})

test_that("determine_type prioritises DESCRIPTION over README.md", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  writeLines("Package: test", file.path(temp_dir, "DESCRIPTION"))
  writeLines("# README", file.path(temp_dir, "README.md"))
  result <- citeme:::determine_type(temp_dir)
  expect_equal(names(result), "description")
})

# Tests for find_individual_insert_position() ---------------------------------

test_that("find_individual_insert_position finds role footnotes", {
  content <- c(
    "# Title",
    "",
    "Author Name[^aut]",
    "",
    "Some content"
  )
  result <- citeme:::find_individual_insert_position(content)
  # Should return the line after the author line (line 4)
  expect_equal(result, 3)
})

test_that("find_individual_insert_position finds last role footnote", {
  content <- c(
    "# Title",
    "",
    "Author One[^aut]",
    "Author Two[^ctb]",
    "Reviewer[^rev]",
    "",
    "Some content"
  )
  result <- citeme:::find_individual_insert_position(content)
  # Should return the line after the last author line (line 6)
  expect_equal(result, 5)
})

test_that("find_individual_insert_position returns 0 when no roles found", {
  content <- c(
    "# Title",
    "",
    "Some content without authors"
  )
  result <- citeme:::find_individual_insert_position(content)
  expect_equal(result, 0)
})

test_that("find_individual_insert_position recognises all role types", {
  roles <- c("aut", "cre", "ctb", "rev", "cph", "fnd", "pbl")
  for (role in roles) {
    content <- c("# Title", sprintf("Name[^%s]", role), "Content")
    result <- citeme:::find_individual_insert_position(content)
    expect_equal(result, 2, info = sprintf("Failed for role: %s", role))
  }
})

# Tests for get_yaml_header() -------------------------------------------------

test_that("get_yaml_header reads _quarto.yml file", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  quarto_file <- file.path(temp_dir, "_quarto.yml")
  writeLines(
    c(
      "project:",
      "  type: book",
      "title: Test Book"
    ),
    quarto_file
  )
  result <- citeme:::get_yaml_header(quarto_file)
  expect_equal(result$project$type, "book")
  expect_equal(result$title, "Test Book")
  expect_equal(attr(result, "path"), quarto_file)
  expect_null(attr(result, "pre"))
  expect_null(attr(result, "post"))
})

test_that("get_yaml_header reads .qmd file with YAML front matter", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  qmd_file <- file.path(temp_dir, "chapter.qmd")
  writeLines(
    c(
      "---",
      "title: Chapter Title",
      "author: Test Author",
      "---",
      "",
      "# Content here",
      "Some text"
    ),
    qmd_file
  )
  result <- citeme:::get_yaml_header(qmd_file)
  expect_equal(result$title, "Chapter Title")
  expect_equal(result$author, "Test Author")
  expect_equal(attr(result, "path"), qmd_file)
  expect_equal(attr(result, "pre"), character(0))
  expect_equal(attr(result, "post"), c("", "# Content here", "Some text"))
})

test_that("get_yaml_header preserves pre and post content", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  qmd_file <- file.path(temp_dir, "test.qmd")
  writeLines(
    c(
      "<!-- comment before -->",
      "---",
      "title: Test",
      "---",
      "Content after"
    ),
    qmd_file
  )
  result <- citeme:::get_yaml_header(qmd_file)
  expect_equal(attr(result, "pre"), "<!-- comment before -->")
  expect_equal(attr(result, "post"), "Content after")
})

test_that("get_yaml_header errors without YAML delimiters", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  bad_file <- file.path(temp_dir, "bad.qmd")
  writeLines(c("No YAML here", "Just content"), bad_file)
  expect_error(
    citeme:::get_yaml_header(bad_file),
    "unable to find two YAML header delimiters"
  )
})

# Tests for write_yaml_header() -----------------------------------------------

test_that("write_yaml_header writes _quarto.yml file", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  quarto_file <- file.path(temp_dir, "_quarto.yml")
  header <- list(project = list(type = "book"), title = "New Book")
  attr(header, "path") <- quarto_file
  citeme:::write_yaml_header(header)
  result <- yaml::read_yaml(quarto_file)
  expect_equal(result$project$type, "book")
  expect_equal(result$title, "New Book")
})

test_that("write_yaml_header writes .qmd file with pre/post content", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  qmd_file <- file.path(temp_dir, "test.qmd")
  header <- list(title = "Updated Title")
  attr(header, "path") <- qmd_file
  attr(header, "pre") <- "<!-- pre -->"
  attr(header, "post") <- c("", "Content here")
  citeme:::write_yaml_header(header)
  content <- readLines(qmd_file)
  expect_equal(content[1], "<!-- pre -->")
  expect_equal(content[2], "---")
  expect_true(any(grepl("title: Updated Title", content)))
})

# Tests for individual2list() -------------------------------------------------

test_that("individual2list creates basic structure", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    email = NA_character_,
    orcid = NA_character_,
    affiliation = NA_character_,
    stringsAsFactors = FALSE
  )
  result <- citeme:::individual2list(individual)
  expect_equal(result$name$given, "John")
  expect_equal(result$name$family, "Doe")
  expect_null(result$email)
  expect_null(result$orcid)
  expect_null(result$affiliation)
})

test_that("individual2list includes email when present", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = NA_character_,
    affiliation = NA_character_,
    stringsAsFactors = FALSE
  )
  result <- citeme:::individual2list(individual)
  expect_equal(result$email, "john@example.org")
})

test_that("individual2list includes orcid when present", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    email = NA_character_,
    orcid = "0000-0001-2345-6789",
    affiliation = NA_character_,
    stringsAsFactors = FALSE
  )
  result <- citeme:::individual2list(individual)
  expect_equal(result$orcid, "0000-0001-2345-6789")
})

test_that("individual2list includes affiliation when present", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    email = NA_character_,
    orcid = NA_character_,
    affiliation = "Test University",
    stringsAsFactors = FALSE
  )
  result <- citeme:::individual2list(individual)
  expect_equal(result$affiliation, list("Test University"))
})

test_that("individual2list includes all fields when present", {
  individual <- data.frame(
    given = "Jane",
    family = "Smith",
    email = "jane@example.org",
    orcid = "0000-0002-1234-5678",
    affiliation = "Research Institute",
    stringsAsFactors = FALSE
  )
  result <- citeme:::individual2list(individual)
  expect_equal(result$name$given, "Jane")
  expect_equal(result$name$family, "Smith")
  expect_equal(result$email, "jane@example.org")
  expect_equal(result$orcid, "0000-0002-1234-5678")
  expect_equal(result$affiliation, list("Research Institute"))
})

test_that("individual2list excludes empty strings", {
  individual <- data.frame(
    given = "John",
    family = "Doe",
    email = "",
    orcid = "",
    affiliation = "",
    stringsAsFactors = FALSE
  )
  result <- citeme:::individual2list(individual)
  expect_null(result$email)
  expect_null(result$orcid)
  expect_null(result$affiliation)
})

# Tests for add_individual() --------------------------------------------------

test_that("add_individual validates role argument", {
  temp_dir <- tempfile("citeme_test")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)
  writeLines("Package: test", file.path(temp_dir, "DESCRIPTION"))
  expect_error(
    citeme::add_individual(temp_dir, role = "invalid"),
    "'arg' should be one of"
  )
})

test_that("add_individual requires valid path", {
  expect_error(
    citeme::add_individual("nonexistent_path"),
    "`path` does not exist"
  )
})
