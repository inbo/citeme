# Test suite for use_individual.R functions
# Tests for validate_individual(), new_individual(), update_individual()
# These are internal functions that support select_individual()

# Helper function to create a mock org_list object
create_mock_org <- function(get_name_result = character(0)) {
  mock_org <- list(
    get_name_by_domain = function(...) get_name_result
  )
  class(mock_org) <- "org_list"
  mock_org
}

# Tests for validate_individual() ---------------------------------------------

test_that("validate_individual returns current when no affiliation match", {
  current <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@unknown.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Unknown Org",
    usage = 1L
  )
  mock_org <- create_mock_org(character(0))
  # Should return current unchanged when no affiliation match
  result <- suppressMessages(
    validate_individual(
      current = current,
      selected = 1,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result, current)
})

test_that("validate_individual requires org_list object", {
  current <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "",
    affiliation = "Test",
    usage = 1L
  )
  expect_error(
    validate_individual(
      current = current,
      selected = 1,
      org = "not_an_org_list",
      lang = "en"
    ),
    "org does not inherit from class org_list"
  )
})

test_that("validate_individual updates affiliation when single match", {
  current <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@inbo.be",
    orcid = "0000-0001-2345-6789",
    affiliation = "Old Affiliation",
    usage = 1L
  )
  mock_org <- create_mock_org(
    c("Research Institute for Nature and Forest (INBO)" = FALSE)
  )
  result <- suppressMessages(
    validate_individual(
      current = current,
      selected = 1,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(
    result$affiliation[1],
    "Research Institute for Nature and Forest (INBO)"
  )
})

test_that("validate_individual keeps affiliation when already matching", {
  current <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@inbo.be",
    orcid = "0000-0001-2345-6789",
    affiliation = "INBO",
    usage = 1L
  )
  # Affiliation already matches one of the options
  mock_org <- create_mock_org(c("INBO" = FALSE))
  result <- suppressMessages(
    validate_individual(
      current = current,
      selected = 1,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result$affiliation[1], "INBO")
})

# Tests for new_individual() --------------------------------------------------

test_that("new_individual requires org_list object", {
  current <- data.frame(
    given = character(0),
    family = character(0),
    email = character(0),
    orcid = character(0),
    affiliation = character(0),
    usage = integer(0)
  )
  expect_error(
    new_individual(
      current = current,
      root = tempdir(),
      org = "not_an_org_list",
      lang = "en"
    ),
    "org does not inherit from class org_list"
  )
})

test_that("new_individual creates individual with mocked input", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  current <- data.frame(
    given = character(0),
    family = character(0),
    email = character(0),
    orcid = character(0),
    affiliation = character(0),
    usage = integer(0)
  )
  mock_org <- create_mock_org(character(0))
  # Create a local version of new_individual with mocked functions
  local_new_individual <- new_individual
  # Mock readline to return test values
  readline_calls <- 0
  readline_values <- c("Test", "Person", "test@example.org", "Test Affiliation")
  mockery::stub(
    local_new_individual,
    "readline",
    function(prompt) {
      readline_calls <<- readline_calls + 1
      readline_values[readline_calls]
    }
  )
  # Mock ask_orcid to return valid orcid
  mockery::stub(local_new_individual, "ask_orcid", "0000-0001-2345-6789")
  result <- suppressMessages(
    local_new_individual(
      current = current,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(nrow(result), 1)
  expect_equal(result$given[1], "Test")
  expect_equal(result$family[1], "Person")
  expect_equal(result$email[1], "test@example.org")
  expect_equal(result$orcid[1], "0000-0001-2345-6789")
  expect_equal(result$affiliation[1], "Test Affiliation")
})

test_that("new_individual sets affiliation from org when single match", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  current <- data.frame(
    given = character(0),
    family = character(0),
    email = character(0),
    orcid = character(0),
    affiliation = character(0),
    usage = integer(0)
  )
  # Return single organisation, FALSE means no ORCID required
  mock_org <- create_mock_org(c("INBO" = FALSE))
  local_new_individual <- new_individual
  readline_calls <- 0
  readline_values <- c("Test", "Person", "test@inbo.be")
  mockery::stub(
    local_new_individual,
    "readline",
    function(prompt) {
      readline_calls <<- readline_calls + 1
      readline_values[readline_calls]
    }
  )
  mockery::stub(local_new_individual, "ask_orcid", "")
  result <- suppressMessages(
    local_new_individual(
      current = current,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result$affiliation[1], "INBO")
})

test_that("new_individual writes individual.txt file", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  current <- data.frame(
    given = character(0),
    family = character(0),
    email = character(0),
    orcid = character(0),
    affiliation = character(0),
    usage = integer(0)
  )
  mock_org <- create_mock_org(character(0))
  local_new_individual <- new_individual
  readline_calls <- 0
  readline_values <- c("Test", "Person", "test@example.org", "Test University")
  mockery::stub(
    local_new_individual,
    "readline",
    function(prompt) {
      readline_calls <<- readline_calls + 1
      readline_values[readline_calls]
    }
  )
  mockery::stub(local_new_individual, "ask_orcid", "0000-0001-2345-6789")
  suppressMessages(
    local_new_individual(
      current = current,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_true(file.exists(file.path(temp_root, "individual.txt", fsep = "/")))
  # Read the file and check content
  saved <- read.table(
    file.path(temp_root, "individual.txt", fsep = "/"),
    sep = "\t",
    header = TRUE,
    fileEncoding = "UTF8"
  )
  expect_equal(saved$given[1], "Test")
  expect_equal(saved$family[1], "Person")
})

# Tests for update_individual() -----------------------------------------------

test_that("update_individual returns original on undo", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  original <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Test University",
    usage = 1L
  )
  mock_org <- create_mock_org(character(0))
  local_update_individual <- update_individual
  # Mock menu to select "undo changes and exit" (option 7)
  mockery::stub(local_update_individual, "menu", 7)
  result <- suppressMessages(
    local_update_individual(
      current = original,
      selected = 1,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result, original)
})

test_that("update_individual saves changes on save and exit", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  original <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Test University",
    usage = 1L
  )
  mock_org <- create_mock_org(character(0))
  local_update_individual <- update_individual
  # Mock menu to select "save and exit" (option 6)
  mockery::stub(local_update_individual, "menu", 6)
  suppressMessages(
    local_update_individual(
      current = original,
      selected = 1,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  # File should be written
  expect_true(file.exists(file.path(temp_root, "individual.txt", fsep = "/")))
})

test_that("update_individual updates given name", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  original <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Test University",
    usage = 1L
  )
  mock_org <- create_mock_org(character(0))
  local_update_individual <- update_individual
  # Mock menu: first select "given" (1), then "save and exit" (6)
  menu_calls <- 0
  menu_values <- c(1, 6)
  mockery::stub(
    local_update_individual,
    "menu",
    function(...) {
      menu_calls <<- menu_calls + 1
      menu_values[menu_calls]
    }
  )
  # Mock readline to return new value
  mockery::stub(local_update_individual, "readline", "Jonathan")
  result <- suppressMessages(
    local_update_individual(
      current = original,
      selected = 1,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result$given[1], "Jonathan")
})

test_that("update_individual updates family name", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  original <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Test University",
    usage = 1L
  )
  mock_org <- create_mock_org(character(0))
  local_update_individual <- update_individual
  # Mock menu: first select "family" (2), then "save and exit" (6)
  menu_calls <- 0
  menu_values <- c(2, 6)
  mockery::stub(
    local_update_individual,
    "menu",
    function(...) {
      menu_calls <<- menu_calls + 1
      menu_values[menu_calls]
    }
  )
  mockery::stub(local_update_individual, "readline", "Smith")
  result <- suppressMessages(
    local_update_individual(
      current = original,
      selected = 1,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result$family[1], "Smith")
})

test_that("update_individual updates email", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  original <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Test University",
    usage = 1L
  )
  mock_org <- create_mock_org(character(0))
  local_update_individual <- update_individual
  # Mock menu: first select "email" (3), then "save and exit" (6)
  menu_calls <- 0
  menu_values <- c(3, 6)
  mockery::stub(
    local_update_individual,
    "menu",
    function(...) {
      menu_calls <<- menu_calls + 1
      menu_values[menu_calls]
    }
  )
  mockery::stub(local_update_individual, "readline", "john.doe@newmail.org")
  result <- suppressMessages(
    local_update_individual(
      current = original,
      selected = 1,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result$email[1], "john.doe@newmail.org")
})

test_that("update_individual updates orcid", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  original <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Test University",
    usage = 1L
  )
  mock_org <- create_mock_org(character(0))
  local_update_individual <- update_individual
  # Mock menu: first select "orcid" (4), then "save and exit" (6)
  menu_calls <- 0
  menu_values <- c(4, 6)
  mockery::stub(
    local_update_individual,
    "menu",
    function(...) {
      menu_calls <<- menu_calls + 1
      menu_values[menu_calls]
    }
  )
  mockery::stub(local_update_individual, "readline", "0000-0002-9999-8888")
  result <- suppressMessages(
    local_update_individual(
      current = original,
      selected = 1,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result$orcid[1], "0000-0002-9999-8888")
})

test_that("update_individual updates affiliation", {
  temp_root <- tempfile("citeme_test")
  dir.create(temp_root, recursive = TRUE)
  on.exit(unlink(temp_root, recursive = TRUE), add = TRUE)
  original <- data.frame(
    given = "John",
    family = "Doe",
    email = "john@example.org",
    orcid = "0000-0001-2345-6789",
    affiliation = "Test University",
    usage = 1L
  )
  mock_org <- create_mock_org(character(0))
  local_update_individual <- update_individual
  # Mock menu: first select "affiliation" (5), then "save and exit" (6)
  menu_calls <- 0
  menu_values <- c(5, 6)
  mockery::stub(
    local_update_individual,
    "menu",
    function(...) {
      menu_calls <<- menu_calls + 1
      menu_values[menu_calls]
    }
  )
  mockery::stub(local_update_individual, "readline", "New University")
  result <- suppressMessages(
    local_update_individual(
      current = original,
      selected = 1,
      root = temp_root,
      org = mock_org,
      lang = "en"
    )
  )
  expect_equal(result$affiliation[1], "New University")
})
