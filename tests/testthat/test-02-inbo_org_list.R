test_that("inbo_org_list returns valid org_list object", {
  ol <- inbo_org_list()
  expect_s3_class(ol, "org_list")
})

test_that("inbo_org_list contains INBO organisation", {

  ol <- inbo_org_list()
  expect_true("info@inbo.be" %in% ol$get_email)
})

test_that("inbo_org_list has correct git URL", {
  ol <- inbo_org_list()
  expect_equal(unname(ol$get_git), "https://github.com/inbo")
})

test_that("inbo_org_list contains multiple organisations", {
  ol <- inbo_org_list()
  expect_true(length(ol$get_email) > 1)
})

test_that("inbo_org_list INBO has correct default name", {
  ol <- inbo_org_list()
  inbo_name <- ol$get_default_name["info@inbo.be"]
  expect_true(grepl("INBO", inbo_name))
})
