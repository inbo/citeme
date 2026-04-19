library(mockery)

new_person <- data.frame(
  given = "Given",
  family = "Family",
  email = "given.family@citeme.org",
  orcid = "",
  affiliation = "",
  usage = 0
)
root <- mock_r_user_dir(config_dir)("citeme", which = "data")
dir.create(root, recursive = TRUE, showWarnings = FALSE)
file.path(root, "individual.txt") |>
  write.table(
    x = new_person,
    sep = "\t",
    row.names = FALSE,
    fileEncoding = "UTF8"
  )
on.exit(unlink(config_dir, recursive = TRUE), add = TRUE)

test_that("add_individual() works with a DESCRIPTION", {
  desc_path <- tempfile("add_description")
  dir.create(desc_path, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(desc_path, recursive = TRUE), add = TRUE)
  old_desc <- c(
    "Package: junk",
    "Title: Junk Package",
    "Version: 0.0.0",
    "Authors@R: c(",
    "    person(\"Me\", \"Myself\", role = c(\"aut\", \"cre\"))",
    "  )",
    "License: MIT",
    "Description: junk"
  )
  file.path(desc_path, "DESCRIPTION") |> writeLines(text = old_desc)
  stub(add_individual, "R_user_dir", mock_r_user_dir(config_dir), depth = 3)
  expect_message(
    suppressWarnings(add_individual(path = desc_path, role = "ctb"))
  )
  file.path(desc_path, "DESCRIPTION") |> readLines() -> new_desc
  expect_equal(head(old_desc, 4), head(new_desc, 4))
  expect_equal(tail(old_desc, 3), tail(new_desc, 3))
  expect_equal(paste0(old_desc[5], ","), new_desc[5])
  expect_equal(
    new_desc[6],
    paste(
      "    person(\"Given\", \"Family\", , \"given.family@citeme.org\",",
      "role = \"ctb\")"
    )
  )
})

test_that("add_individual() works with a README", {
  readme_path <- tempfile("add_readme")
  dir.create(readme_path, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(readme_path, recursive = TRUE), add = TRUE)

  # basic README without authors and title
  old_readme <- "Some text"
  file.path(readme_path, "README.md") |> writeLines(text = old_readme)
  stub(add_individual, "R_user_dir", mock_r_user_dir(config_dir), depth = 3)
  expect_message(suppressWarnings(add_individual(
    path = readme_path,
    role = "aut"
  )))
  file.path(readme_path, "README.md") |> readLines() -> new_readme
  expect_equal(
    head(new_readme, 1),
    "[Family, Given](mailto:given.family%40citeme.org)[^aut]"
  )
  expect_true(any(grepl("\\[\\^aut\\]: author", new_readme)))

  # README with title and without authors
  old_readme <- c("# Title", "Some text")
  file.path(readme_path, "README.md") |> writeLines(text = old_readme)
  stub(add_individual, "R_user_dir", mock_r_user_dir(config_dir), depth = 3)
  expect_message(suppressWarnings(add_individual(
    path = readme_path,
    role = "ctb"
  )))
  file.path(readme_path, "README.md") |> readLines() -> new_readme
  expect_equal(
    new_readme[3],
    "[Family, Given](mailto:given.family%40citeme.org)[^ctb]"
  )
  expect_true(any(grepl("\\[\\^ctb\\]: contributor", new_readme)))

  # README with authors
  old_readme <- c(
    "[Else, Someone](mailto:someone.else%40citeme.org)[^aut]",
    "[^aut]: author",
    "Some text"
  )
  file.path(readme_path, "README.md") |> writeLines(text = old_readme)
  stub(add_individual, "R_user_dir", mock_r_user_dir(config_dir), depth = 3)
  expect_message(
    suppressWarnings(add_individual(
      path = readme_path,
      role = "rev"
    ))
  )
  file.path(readme_path, "README.md") |> readLines() -> new_readme
  expect_equal(
    new_readme[3],
    "[Family, Given](mailto:given.family%40citeme.org)[^rev]"
  )
  expect_true(any(grepl("\\[\\^rev\\]: reviewer", new_readme)))
})

test_that("add_individual() works with a quarto document", {
  quarto_path <- tempfile("add_quarto")
  dir.create(quarto_path, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(quarto_path, recursive = TRUE), add = TRUE)

  # _with quarto.yml
  yml <- "title: Quarto Document"
  old_quarto <- c("---", yml, "---", "Some text")
  file.path(quarto_path, "_quarto.yml") |> writeLines(text = yml)
  file.path(quarto_path, "index.qmd") |> writeLines(text = old_quarto)
  file.path(quarto_path, "test.qmd") |> writeLines(text = old_quarto)
  stub(add_individual, "R_user_dir", mock_r_user_dir(config_dir), depth = 3)
  expect_message(
    suppressWarnings(add_individual(path = quarto_path, role = "aut"))
  )
  expect_equal(
    get_yaml_header(file.path(quarto_path, "_quarto.yml")),
    list(
      title = "Quarto Document",
      author = list(
        list(
          name = list(given = "Given", family = "Family"),
          email = "given.family@citeme.org"
        )
      )
    ) |>
      `attr<-`("path", file.path(quarto_path, "_quarto.yml"))
  )
  expect_equal(readLines(file.path(quarto_path, "index.qmd")), old_quarto)
  expect_equal(readLines(file.path(quarto_path, "test.qmd")), old_quarto)

  # index.qmd without _quarto.yml
  file.remove(file.path(quarto_path, "_quarto.yml"))
  stub(add_individual, "R_user_dir", mock_r_user_dir(config_dir), depth = 3)
  expect_message(
    suppressWarnings(add_individual(path = quarto_path))
  )

  expect_equal(
    get_yaml_header(file.path(quarto_path, "index.qmd")),
    list(
      title = "Quarto Document",
      author = list(
        list(
          name = list(given = "Given", family = "Family"),
          email = "given.family@citeme.org"
        )
      )
    ) |>
      `attr<-`("path", file.path(quarto_path, "index.qmd")) |>
      `attr<-`("post", "Some text") |>
      `attr<-`("pre", character(0))
  )
  expect_equal(readLines(file.path(quarto_path, "test.qmd")), old_quarto)

  # test.qmd without _quarto.yml and index.qmd
  file.remove(file.path(quarto_path, "index.qmd"))
  stub(add_individual, "R_user_dir", mock_r_user_dir(config_dir), depth = 3)
  expect_message(
    results <- suppressWarnings(add_individual(path = quarto_path))
  )

  expect_equal(
    get_yaml_header(file.path(quarto_path, "test.qmd")),
    list(
      title = "Quarto Document",
      author = list(
        list(
          name = list(given = "Given", family = "Family"),
          email = "given.family@citeme.org"
        )
      )
    ) |>
      `attr<-`("path", file.path(quarto_path, "test.qmd")) |>
      `attr<-`("post", "Some text") |>
      `attr<-`("pre", character(0))
  )
})
