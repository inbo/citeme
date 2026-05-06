#' Get the list of available organisations
#'
#' This function retrieves the list of available organisations from the local
#' configuration files and locally stored organisations.
#' It returns a list containing the names, languages, licenses, ORCID, Zenodo,
#' ROR, website, and logo of the available organisations.
#' @return A list containing the names, languages, licenses, ORCID, Zenodo, ROR,
#' website, and logo of the available organisations.
#' @export
#' @importFrom tools R_user_dir
#' @family organisation
get_available_organisations <- function() {
  # Get organisations from configuration files
  config_folder <- R_user_dir("citeme", which = "config")
  list.files(
    config_folder,
    pattern = "organisation.yml",
    recursive = TRUE,
    full.names = TRUE
  ) |>
    dirname() |>
    vapply(
      FUN = function(x) {
        list(org_list$new()$read(x)$as_list)
      },
      FUN.VALUE = vector(mode = "list", length = 1)
    ) |>
    unname() |>
    unlist(recursive = FALSE) -> all_orgs
  all_orgs <- all_orgs[sort(unique(names(all_orgs)[names(all_orgs) != "git"]))]
  orgnames <- lapply(all_orgs, "[[", "name")
  orcid <- vapply(all_orgs, "[[", "orcid", FUN.VALUE = logical(1))
  zenodo <- vapply(
    all_orgs,
    function(x) {
      ifelse(is.null(x$zenodo), "", x$zenodo)
    },
    character(1)
  )
  ror <- vapply(
    all_orgs,
    function(x) {
      ifelse(is.null(x$ror), "", x$ror)
    },
    character(1)
  )
  website <- vapply(
    all_orgs,
    function(x) {
      ifelse(is.null(x$website), "", x$website)
    },
    character(1)
  )
  logo <- vapply(
    all_orgs,
    function(x) {
      ifelse(is.null(x$logo), "", x$logo)
    },
    character(1)
  )
  lapply(all_orgs, "[[", "license") |>
    unname() |>
    unlist(recursive = FALSE) |>
    unname() |>
    unlist() -> licenses
  unname(orgnames) |>
    unlist() |>
    names() |>
    unique() |>
    sort() -> languages

  # Add locally stored organisations
  stored <- stored_organisations()
  if (nrow(stored) == 0) {
    return(list(
      names = orgnames,
      languages = languages,
      licenses = licenses[sort(unique(names(licenses)))],
      orcid = orcid,
      zenodo = zenodo,
      ror = ror,
      website = website,
      logo = logo
    ))
  }
  # Parse names from stored format and add to orgnames
  stored_names <- lapply(seq_len(nrow(stored)), function(i) {
    parse_stored_names(stored$names[i])
  })
  names(stored_names) <- stored$email
  # Only add organisations not already in orgnames (based on email)
  new_emails <- setdiff(stored$email, names(orgnames))
  if (length(new_emails) == 0) {
    return(list(
      names = orgnames,
      languages = languages,
      licenses = licenses[sort(unique(names(licenses)))],
      orcid = orcid,
      zenodo = zenodo,
      ror = ror,
      website = website,
      logo = logo
    ))
  }
  stored_subset <- stored[stored$email %in% new_emails, ]
  stored_names_subset <- stored_names[new_emails]
  orgnames <- c(orgnames, stored_names_subset)
  orcid <- c(orcid, setNames(stored_subset$orcid, stored_subset$email))
  zenodo <- c(zenodo, setNames(stored_subset$zenodo, stored_subset$email))
  ror <- c(ror, setNames(stored_subset$ror, stored_subset$email))
  website <- c(
    website,
    setNames(stored_subset$website, stored_subset$email)
  )
  logo <- c(logo, setNames(stored_subset$logo, stored_subset$email))
  # Update languages with any new languages from stored organisations
  stored_langs <- unlist(lapply(stored_names_subset, names))
  languages <- sort(unique(c(languages, stored_langs)))

  return(list(
    names = orgnames,
    languages = languages,
    licenses = licenses[sort(unique(names(licenses)))],
    orcid = orcid,
    zenodo = zenodo,
    ror = ror,
    website = website,
    logo = logo
  ))
}

#' Parse stored organisation names from string format
#'
#' Internal helper function to parse organisation names stored in the format
#' `lang1=name1|lang2=name2|...`.
#' @param names_string A string with names in the stored format.
#' @return A named list with language codes as names and organisation names as
#' values.
#' @noRd
parse_stored_names <- function(names_string) {
  if (is.na(names_string) || names_string == "") {
    return(list())
  }
  parts <- strsplit(names_string, "\\|")[[1]]
  result <- lapply(parts, function(part) {
    key_value <- strsplit(part, "=", fixed = TRUE)[[1]]
    if (length(key_value) == 2) {
      setNames(key_value[2], key_value[1])
    } else {
      NULL
    }
  })
  result <- unlist(result)
  as.list(result)
}
