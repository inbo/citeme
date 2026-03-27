#' Which individual to use
#'
#' Reuse existing individual information or add a new individual.
#' Allows to update existing individual information.
#' @return A data.frame with individual information.
#' @param email An optional email address.
#' When given and it matches with a single person, the function immediately
#' returns the information of that person.
#' @param lang The language to use for the affiliation.
#' Defaults to the first language in the `name` vector of the
#' `org_list` object.
#' When the affiliation is not available in that language,
#' it will use the first available language.
#' @importFrom assertthat assert_that is.string noNA
#' @importFrom fs path
#' @importFrom tools R_user_dir
#' @importFrom utils write.table
#' @family individual
#' @export
use_individual <- function(email, lang) {
  root <- R_user_dir("citeme", which = "data")
  org <- org_list$new()$read()
  current <- stored_individuals(root)
  assert_that(
    interactive() || nrow(current) > 0,
    msg = "No available individuals in a non-interactive session."
  )
  current <- current[
    order(-current$usage, current$family, current$given, current$orcid),
  ]
  run_loop <- TRUE
  if (!missing(email)) {
    assert_that(is.string(email), noNA(email))
    selected <- which(current$email == email)
    run_loop <- length(selected) != 1
  }
  while (run_loop) {
    sprintf("%s, %s", current$family, current$given) |>
      c("new person") |>
      menu_first("Which person information do you want to use?") -> selected
    if (selected < 1) {
      warning("You must select a person\n", immediate. = TRUE, call. = FALSE)
      next
    }
    if (selected > nrow(current)) {
      current <- new_individual(
        current = current,
        root = root,
        org = org,
        lang = lang
      )
    }
    current <- validate_individual(
      current = current,
      selected = selected,
      org = org,
      lang = lang
    )
    final <- menu_first(choices = c("use ", "update", "other"))
    if (final == 1) {
      break
    }
    if (final == 2) {
      current <- update_individual(
        current = current,
        selected = selected,
        root = root,
        org = org,
        lang = lang
      )
      next
    }
  }
  current$usage[selected] <- pmax(current$usage[selected], 0) + 1
  write.table(
    current,
    file = path(root, "individual.txt"),
    sep = "\t",
    row.names = FALSE,
    fileEncoding = "UTF8"
  )
  message("individual information stored at ", path(root, "individual.txt"))
  aff <- org$get_name_by_domain(current$email[selected], lang = lang)
  if (length(aff) == 1) {
    current$affiliation[selected] <- names(aff)
  } else if (length(aff) > 1) {
    default_aff <- org$get_name_by_domain(current$email[selected], lang = lang)
    current$affiliation[selected] <- names(aff[
      names(default_aff) == current$affiliation[selected]
    ])
  }
  return(current[selected, ])
}

#' @importFrom fs path
#' @importFrom utils menu write.table
update_individual <- function(current, selected, root, org, lang) {
  original <- current
  item <- c("given", "family", "email", "orcid", "affiliation")
  repeat {
    current <- validate_individual(
      current = current,
      selected = selected,
      org = org,
      lang = lang
    )
    command <- menu(
      choices = c(item, "save and exit", "undo changes and exit"),
      title = "\nWhich item to update?"
    )
    if (command > length(item)) {
      break
    }
    sprintf(
      "current %s: %s\n",
      item[command],
      current[selected, item[command]]
    ) |>
      cat()
    current[selected, item[command]] <- readline(
      prompt = sprintf("New value for %s: ", item[command])
    )
  }
  if (command > length(item) + 1) {
    return(original)
  }
  write.table(
    current,
    file = path(root, "individual.txt"),
    sep = "\t",
    row.names = FALSE,
    fileEncoding = "UTF8"
  )
  message("individual information stored at ", path(root, "individual.txt"))
  return(current)
}

#' @importFrom assertthat assert_that
new_individual <- function(current, root, org, lang) {
  assert_that(inherits(org, "org_list"))
  cat("Please provide person information.\n")
  data.frame(
    given = readline(prompt = "given name:  "),
    family = readline(prompt = "family name: "),
    email = readline(prompt = "e-mail:      "),
    orcid = ask_orcid(prompt = "orcid:       ")
  ) -> extra
  which_org <- org$get_name_by_domain(extra$email, lang = lang)
  if (length(which_org) == 1) {
    extra$affiliation <- names(which_org)
    while (which_org && extra$orcid == "") {
      warning(
        "An ORCID is required for",
        names(which_org),
        immediate. = TRUE,
        call. = FALSE
      )
      extra$orcid <- ask_orcid(prompt = "orcid: ")
    }
  } else if (length(which_org) == 0) {
    extra$affiliation <- readline(prompt = "affiliation: ")
  } else {
    menu_first(
      choices = c(names(which_org), "other"),
      title = "Which organisation for the affiliation?"
    ) -> selection
    if (selection == length(which_org) + 1) {
      extra$affiliation <- readline(prompt = "affiliation: ")
    } else {
      extra$affiliation <- names(which_org)[selection]
    }
  }
  extra$usage <- 0
  rbind(current, extra) -> current
  write.table(
    current,
    file = path(root, "individual.txt"),
    sep = "\t",
    row.names = FALSE,
    fileEncoding = "UTF8"
  )
  message("individual information stored at ", path(root, "individual.txt"))
  return(current)
}

validate_individual <- function(current, selected, org, lang) {
  assert_that(inherits(org, "org_list"))
  affiliation <- org$get_name_by_domain(current$email[selected], lang = lang)
  if (length(affiliation) == 0) {
    return(current)
  }
  if (!current$affiliation[selected] %in% names(affiliation)) {
    if (length(affiliation) == 1) {
      current$affiliation[selected] <- names(affiliation)
    } else {
      menu_first(
        choices = names(affiliation),
        title = paste(
          "Which organisation for the affiliation?",
          "Update `organisation.yml` if not listed."
        )
      ) -> selected_affiliation
      current$affiliation[selected] <- names(affiliation)[selected_affiliation]
    }
  }
  while (
    affiliation[current$affiliation[selected]] && current$orcid[selected] == ""
  ) {
    warning(
      "\nAn ORCID is required for",
      current$affiliation[selected],
      immediate. = TRUE,
      call. = FALSE
    )
    current$orcid[selected] <- ask_orcid(prompt = "orcid: ")
  }
  cat(
    "given name: ",
    current$given[selected],
    "\nfamily name:",
    current$family[selected],
    "\ne-mail:     ",
    current$email[selected],
    "\norcid:      ",
    current$orcid[selected],
    "\naffiliation:",
    current$affiliation[selected]
  )
  return(current)
}
