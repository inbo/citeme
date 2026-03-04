test_that("org_list creates empty object", {
  ol <- org_list$new()
  expect_s3_class(ol, "org_list")
})

test_that("org_list creates object with org_item", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)
  expect_s3_class(ol, "org_list")
  expect_equal(length(ol$get_email), 1)
  expect_equal(unname(ol$get_email), "test@example.org")
})

test_that("org_list creates object with multiple org_items", {
  item1 <- org_item$new(
    name = c("en-GB" = "Test Organization One"),
    email = "test1@example.org"
  )
  item2 <- org_item$new(
    name = c("en-GB" = "Test Organization Two"),
    email = "test2@example.org"
  )
  ol <- org_list$new(item1, item2)
  expect_s3_class(ol, "org_list")
  expect_equal(length(ol$get_email), 2)
  expect_true("test1@example.org" %in% ol$get_email)
  expect_true("test2@example.org" %in% ol$get_email)
})

test_that("org_list add_item adds an org_item", {
  item1 <- org_item$new(
    name = c("en-GB" = "Test Organization One"),
    email = "test1@example.org"
  )
  item2 <- org_item$new(
    name = c("en-GB" = "Test Organization Two"),
    email = "test2@example.org"
  )
  ol <- org_list$new(item1)
  ol$add_item(item2)
  expect_equal(length(ol$get_email), 2)
})

test_that("org_list fails with duplicate organisation names", {
  item1 <- org_item$new(
    name = c("en-GB" = "Same Name"),
    email = "test1@example.org"
  )
  item2 <- org_item$new(
    name = c("en-GB" = "Same Name"),
    email = "test2@example.org"
  )
  expect_error(org_list$new(item1, item2), "duplicated organisation name")
})

test_that("org_list fails with incompatible rightsholder rules", {
  item1 <- org_item$new(
    name = c("en-GB" = "Test Org One"),
    email = "test1@example.org",
    rightsholder = "single"
  )
  item2 <- org_item$new(
    name = c("en-GB" = "Test Org Two"),
    email = "test2@example.org",
    rightsholder = "shared"
  )
  expect_error(org_list$new(item1, item2), "not compatible")
})

test_that("org_list fails with multiple single rightsholder rules", {
  item1 <- org_item$new(
    name = c("en-GB" = "Test Org One"),
    email = "test1@example.org",
    rightsholder = "single"
  )
  item2 <- org_item$new(
    name = c("en-GB" = "Test Org Two"),
    email = "test2@example.org",
    rightsholder = "single"
  )
  expect_error(
    org_list$new(item1, item2),
    "more than one organisation with `single`"
  )
})

test_that("org_list get_default_name returns names", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)
  expect_equal(unname(ol$get_default_name), "Test Organization")
})

test_that("org_list get_match finds best match", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)
  match <- ol$get_match("Test Organization")
  expect_equal(match$match, Inf)
  expect_equal(match$email, "test@example.org")
})

test_that("org_list get_languages returns available languages", {
  item <- org_item$new(
    name = c(
      "en-GB" = "Test Organization",
      "nl-BE" = "Test Organisatie"
    ),
    email = "test@example.org"
  )
  ol <- org_list$new(item)
  langs <- ol$get_languages
  expect_true("en-GB" %in% langs)
})

test_that("org_list as_list returns correct structure", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item, git = "https://github.com/test")
  result <- ol$as_list
  expect_type(result, "list")
  expect_true("git" %in% names(result))
  expect_equal(result$git, "https://github.com/test")
})

test_that("org_list with valid git parameter works", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item, git = "https://github.com/testorg")
  expect_equal(ol$get_git, "https://github.com/testorg")
})

test_that("org_list fails with invalid git URL format", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  expect_error(
    org_list$new(item, git = "not-a-valid-url"),
    "`git` must be a valid URL"
  )
})

test_that("org_list get_person returns person for matching email", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)
  person_obj <- ol$get_person("test@example.org", role = "cph", lang = "en-GB")
  expect_s3_class(person_obj, "person")
})

test_that("org_list get_person returns basic person for non-matching email", {
  item <- org_item$new(
    name = c("en-GB" = "Test Organization"),
    email = "test@example.org"
  )
  ol <- org_list$new(item)
  person_obj <- ol$get_person(
    "unknown@example.com",
    role = "cph",
    lang = "en-GB"
  )
  expect_s3_class(person_obj, "person")
})

test_that("org_list which_rightsholder returns correct organisation emails", {
  item1 <- org_item$new(
    name = c("en-GB" = "Test Org One"),
    email = "test1@example.org",
    rightsholder = "shared"
  )
  item2 <- org_item$new(
    name = c("en-GB" = "Test Org Two"),
    email = "test2@example.org",
    rightsholder = "optional"
  )
  ol <- org_list$new(item1, item2)
  result <- ol$which_rightsholder
  expect_true("test1@example.org" %in% result$required)
  expect_false("test2@example.org" %in% result$required)
})

test_that("org_list which_funder returns correct organisation emails", {
  item1 <- org_item$new(
    name = c("en-GB" = "Test Org One"),
    email = "test1@example.org",
    funder = "single"
  )
  item2 <- org_item$new(
    name = c("en-GB" = "Test Org Two"),
    email = "test2@example.org",
    funder = "optional"
  )
  ol <- org_list$new(item1, item2)
  result <- ol$which_funder
  expect_true("test1@example.org" %in% result$required)
  expect_false("test2@example.org" %in% result$required)
})
