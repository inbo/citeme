# Helper to create a temporary quarto project
create_temp_quarto <- function(
  title = "Test Quarto Project",
  subtitle = NULL,
  shorttitle = NULL,
  license = "CC-BY-4.0",
  lang = "en-GB",
  keywords = c("test", "quarto"),
  community = "some-community",
  publisher = "Test Publisher",
  publication_type = "publication-book",
  publication_date = NULL,
  embargo = NULL,
  doi = NULL,
  use_flandersqmd = FALSE,
  use_book = FALSE
) {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Build the YAML content
  yaml_content <- list(
    title = title,
    lang = lang
  )
  if (!is.null(subtitle)) {
    yaml_content$subtitle <- subtitle
  }
  if (!is.null(shorttitle)) {
    yaml_content$shorttitle <- shorttitle
  }
  yaml_content$license <- license
  yaml_content$keywords <- keywords
  yaml_content$community <- community
  yaml_content$publisher <- publisher
  yaml_content$publication_type <- publication_type
  if (!is.null(publication_date)) {
    yaml_content$publication_date <- publication_date
  }
  if (!is.null(embargo)) {
    yaml_content$embargo <- embargo
  }
  if (!is.null(doi)) {
    yaml_content$doi <- doi
  }
  yaml_content$author <- list(
    list(
      name = list(given = "John", family = "Doe"),
      email = "john@example.com"
    )
  )
  yaml_content$reviewer <- list(
    list(
      name = list(given = "Jane", family = "Smith"),
      email = "jane@example.com"
    )
  )
  yaml_content$funder <- list(
    list(
      name = list(given = "Funding", family = "Agency"),
      email = "funding@example.com"
    )
  )
  yaml_content$rightsholder <- list(
    list(
      name = list(given = "Rights", family = "Holder"),
      email = "rights@example.com"
    )
  )

  if (use_flandersqmd) {
    quarto_yml <- list(lang = lang, flandersqmd = yaml_content)
  } else if (use_book) {
    quarto_yml <- list(lang = lang, book = yaml_content)
  } else {
    quarto_yml <- yaml_content
  }

  handlers <- list(logical = function(x) {
    ifelse(x, "true", "false")
  })
  write_yaml(
    quarto_yml,
    file.path(temp_dir, "_quarto.yml", fsep = "/"),
    handlers = handlers
  )

  # Create index.qmd with description
  index_qmd <- "# Introduction

<!-- description: start -->
This is a test quarto project description for testing purposes.
<!-- description: end -->

Content here.
"
  writeLines(index_qmd, file.path(temp_dir, "index.qmd", fsep = "/"))

  temp_dir
}

test_that("citation_quarto requires citation_meta object", {
  expect_error(
    citeme:::citation_quarto("not_a_citation_meta"),
    "does not inherit from class citation_meta"
  )
})

test_that("citation_quarto requires quarto type", {
  # Create a mock citation_meta object with wrong type
  meta_obj <- structure(
    list(get_type = "package"),
    class = "citation_meta"
  )

  expect_error(
    citeme:::citation_quarto(meta_obj),
    "not equal to \"quarto\""
  )
})

test_that("citation_quarto returns error when _quarto.yml missing", {
  # Create temporary directory without _quarto.yml

  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Create mock citation_meta object
  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(temp_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true(length(result$errors) > 0)
  expect_match(result$errors[1], "_quarto.yml.*not found")
})

test_that("citation_quarto processes valid quarto project", {
  quarto_dir <- create_temp_quarto()

  # Create mock citation_meta object
  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)

  # Check structure of result
  expect_true(is.list(result))
  expect_true(has_name(result, "person"))
  expect_true(has_name(result, "meta"))
  expect_true(has_name(result, "errors"))
  expect_true(has_name(result, "notes"))
  expect_true(has_name(result, "warnings"))
})

test_that("citation_quarto extracts title with subtitle", {
  quarto_dir <- create_temp_quarto(
    title = "Main Title",
    subtitle = "A Subtitle"
  )

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$title, "Main Title. A Subtitle.")
})

test_that("citation_quarto extracts title without subtitle", {
  quarto_dir <- create_temp_quarto(title = "Simple Title")

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$title, "Simple Title.")
})

test_that("citation_quarto extracts shorttitle", {
  quarto_dir <- create_temp_quarto(
    title = "Very Long Title",
    shorttitle = "Short"
  )

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$shorttitle, "Short")
})

test_that("citation_quarto extracts license", {
  quarto_dir <- create_temp_quarto(license = "GPL-3.0")

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$license, "GPL-3.0")
})

test_that("citation_quarto returns error when license missing", {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Create _quarto.yml without license
  yaml_content <- list(
    title = "Test",
    lang = "en-GB",
    author = list(list(name = list(given = "John", family = "Doe")))
  )
  handlers <- list(logical = function(x) {
    ifelse(x, "true", "false")
  })
  write_yaml(
    yaml_content,
    file.path(temp_dir, "_quarto.yml", fsep = "/"),
    handlers = handlers
  )

  # Create index.qmd with description
  writeLines(
    "<!-- description: start -->\nTest\n<!-- description: end -->",
    file.path(temp_dir, "index.qmd", fsep = "/")
  )

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(temp_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true(any(grepl("No .license. element found", result$errors)))
})

test_that("citation_quarto extracts publication_date", {
  quarto_dir <- create_temp_quarto(publication_date = "2024-01-15")

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$publication_date, "2024-01-15")
})

test_that("citation_quarto handles embargo date", {
  quarto_dir <- create_temp_quarto(embargo = "2025-06-01")

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$embargo_date, "2025-06-01")
  expect_equal(result$meta$access_right, "embargoed")
  # When no publication_date is set, embargo_date is used
  expect_equal(result$meta$publication_date, "2025-06-01")
})

test_that("citation_quarto sets open access when no embargo", {
  quarto_dir <- create_temp_quarto()

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$access_right, "open")
})

test_that("citation_quarto extracts language", {
  quarto_dir <- create_temp_quarto(lang = "nl-BE")

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$language, "nl-BE")
})

test_that("citation_quarto extracts keywords", {
  quarto_dir <- create_temp_quarto(keywords = c("keyword1", "keyword2"))

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$keywords, c("keyword1", "keyword2"))
})

test_that("citation_quarto notes missing keywords", {
  quarto_dir <- create_temp_quarto(keywords = NULL)

  # Manually remove keywords from the yml
  yaml_file <- file.path(quarto_dir, "_quarto.yml", fsep = "/")
  yaml_content <- yaml::read_yaml(yaml_file)
  yaml_content$keywords <- NULL
  handlers <- list(logical = function(x) {
    ifelse(x, "true", "false")
  })
  write_yaml(yaml_content, yaml_file, handlers = handlers)

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true(any(grepl("No .keywords. element found", result$errors)))
})

test_that("citation_quarto notes missing publisher", {
  quarto_dir <- create_temp_quarto(publisher = NULL)

  # Manually remove publisher from the yml
  yaml_file <- file.path(quarto_dir, "_quarto.yml", fsep = "/")
  yaml_content <- yaml::read_yaml(yaml_file)
  yaml_content$publisher <- NULL
  handlers <- list(logical = function(x) {
    ifelse(x, "true", "false")
  })
  write_yaml(yaml_content, yaml_file, handlers = handlers)

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true(any(grepl("No .publisher. element found", result$errors)))
})

test_that("citation_quarto validates publication_type", {
  quarto_dir <- create_temp_quarto(publication_type = "invalid-type")

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true(any(grepl(".publication_type. must be one of", result$errors)))
})

test_that("citation_quarto notes missing publication_type", {
  quarto_dir <- create_temp_quarto(publication_type = NULL)

  # Manually remove publication_type from the yml
  yaml_file <- file.path(quarto_dir, "_quarto.yml", fsep = "/")
  yaml_content <- yaml::read_yaml(yaml_file)
  yaml_content$publication_type <- NULL
  handlers <- list(logical = function(x) {
    ifelse(x, "true", "false")
  })
  write_yaml(yaml_content, yaml_file, handlers = handlers)

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true(any(grepl("No .publication_type. element found", result$notes)))
})

test_that("citation_quarto processes flandersqmd structure", {
  quarto_dir <- create_temp_quarto(use_flandersqmd = TRUE)

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true(is.list(result))
  expect_true(has_name(result$meta, "title"))
})

test_that("citation_quarto processes book structure", {
  quarto_dir <- create_temp_quarto(use_book = TRUE)

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true(is.list(result))
  expect_true(has_name(result$meta, "title"))
})

test_that("citation_quarto extracts doi", {
  quarto_dir <- create_temp_quarto(doi = "10.5281/zenodo.1234567")

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$doi, "10.5281/zenodo.1234567")
})

test_that("citation_quarto sets upload_type to publication", {
  quarto_dir <- create_temp_quarto()

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_equal(result$meta$upload_type, "publication")
})

test_that("citation_quarto extracts community", {
  quarto_dir <- create_temp_quarto(community = "test-community")

  meta <- structure(
    list(
      get_type = "quarto",
      get_path = file.path(quarto_dir, "_quarto.yml", fsep = "/")
    ),
    class = "citation_meta"
  )

  result <- citeme:::citation_quarto(meta)
  expect_true("test-community" %in% result$meta$community)
})

# Test quarto_description helper
test_that("quarto_description extracts description from qmd files", {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Create a qmd file with description
  qmd_content <- "# Title

<!-- description: start -->
This is the description text.
<!-- description: end -->

Other content.
"
  writeLines(qmd_content, file.path(temp_dir, "index.qmd", fsep = "/"))

  result <- citeme:::quarto_description(temp_dir)
  expect_equal(result$description, "This is the description text.")
  expect_equal(result$errors, character(0))
})

test_that("quarto_description returns error when no description found", {
  temp_dir <- tempfile()
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)

  # Create a qmd file without description markers
  writeLines(
    "# Title\n\nSome content.",
    file.path(temp_dir, "index.qmd", fsep = "/")
  )

  result <- citeme:::quarto_description(temp_dir)
  expect_true(any(grepl("No description found", result$errors)))
})

test_that("quarto_description searches recursively", {
  temp_dir <- tempfile()
  dir.create(file.path(temp_dir, "chapters", fsep = "/"), recursive = TRUE)

  # Create a qmd file in subdirectory with description
  qmd_content <- "# Chapter

<!-- description: start -->
Chapter description.
<!-- description: end -->
"
  writeLines(
    qmd_content,
    file.path(temp_dir, "chapters", "chapter1.qmd", fsep = "/")
  )

  result <- citeme:::quarto_description(temp_dir)
  expect_equal(result$description, "Chapter description.")
})
