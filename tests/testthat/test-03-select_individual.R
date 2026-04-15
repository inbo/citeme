library(mockery)

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
  file.path(root, "individual.txt") |>
    write.table(
      x = new_person,
      sep = "\t",
      row.names = FALSE,
      fileEncoding = "UTF8"
    )
  stub(select_individual, "R_user_dir", mock_r_user_dir(config_dir))
  expect_message(result <- select_individual(lang = "en-GB"))
  expect_equal(result[, -6], new_person[, -6])
})
