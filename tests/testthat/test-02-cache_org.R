library(mockery)

test_that("cache_org works for INBO", {
  temp_root <- mock_r_user_dir(config_dir)("citeme", which = "data")
  stub(stored_individuals, "R_user_dir", mock_r_user_dir(config_dir))
  expect_identical(
    cache_org(url = "https://github.com/inbo", config_folder = temp_root),
    inbo_org_list()
  )
})

test_that("cache_org works for gitlab", {
  temp_root <- mock_r_user_dir(config_dir)("citeme", which = "data")
  stub(stored_individuals, "R_user_dir", mock_r_user_dir(config_dir))
  expect_s3_class(
    org <- cache_org(
      url = "https://github.com/ThierryO",
      config_folder = temp_root
    ),
    c("org_list", "R6")
  )
})
