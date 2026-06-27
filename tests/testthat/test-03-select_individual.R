library(mockery)

test_that("select_individual() works with non-existing config_folder", {
  temp_config_dir <- tempfile("citeme_config")
  expect_false(dir.exists(temp_config_dir))
  root <- mock_r_user_dir(temp_config_dir)("citeme", which = "data")
  stub(select_individual, "R_user_dir", root, depth = 2)
  expect_error(
    select_individual(lang = "en-GB"),
    "No available individuals in a non-interactive session."
  )
})

test_that("select_individual() returns correct individual", {
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
  file.path(root, "individual.txt", fsep = "/") |>
    write.table(
      x = new_person,
      sep = "\t",
      row.names = FALSE,
      fileEncoding = "UTF8"
    )
  stub(select_individual, "R_user_dir", mock_r_user_dir(config_dir), depth = 2)
  expect_message(result <- select_individual(lang = "en-GB"))
  expect_equal(result[, -6], new_person[, -6])
})
