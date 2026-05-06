#' Store organisation details for later usage
#'
#' This function stores organisation information locally for later retrieval.
#' The organisations are stored in a tab-separated file in the user's data
#' directory.
#' @param x An `org_list` or `org_item` object to store.
#' @return `NULL` invisibly.
#' @export
#' @importFrom tools R_user_dir
#' @importFrom utils write.table
#' @family organisation
store_organisations <- function(x) {
  UseMethod("store_organisations", x)
}

#' @export
store_organisations.default <- function(x) {
  stop("`store_organisations()` is not implemented for ", class(x)[1])
}

#' @export
store_organisations.org_list <- function(x) {
  # Convert the org_list to a data.frame and store it
  new_orgs <- organisation2df(x)
  current <- stored_organisations()
  # Combine current and new organisations, keeping the most recent version
  # of each organisation based on email
  combined <- rbind(current, new_orgs)
  # Keep only the last occurrence of each email (i.e., the most recent)
  combined <- combined[!duplicated(combined$email, fromLast = TRUE), ]
  write_organisations(combined)
  return(invisible(NULL))
}

#' @export
store_organisations.org_item <- function(x) {
  # Convert the org_item to a data.frame and store it
  new_org <- organisation2df(x)
  current <- stored_organisations()
  # Combine current and new organisation, keeping the most recent version
  combined <- rbind(current, new_org)
  # Keep only the last occurrence of each email (i.e., the most recent)
  combined <- combined[!duplicated(combined$email, fromLast = TRUE), ]
  write_organisations(combined)
  return(invisible(NULL))
}

#' Convert organisation object to a data.frame
#'
#' Results in a data.frame with the email, default name, ROR, ORCID requirement,
#' Zenodo community, website, and logo of the organisation.
#' @param x An `org_list` or `org_item` object.
#' @return A data.frame with the organisation information.
#' @export
#' @family organisation
organisation2df <- function(x) {
  UseMethod("organisation2df", x)
}

#' @export
organisation2df.default <- function(x) {
  stop("`organisation2df()` is not implemented for ", class(x)[1])
}

#' @export
organisation2df.org_list <- function(x) {
  # Get the list representation of the org_list
  org_data <- x$as_list
  # Remove the git entry
  org_data <- org_data[names(org_data) != "git"]
  # Convert each item to a data.frame row
  do.call(rbind, lapply(org_data, org_item_to_row))
}

#' @export
organisation2df.org_item <- function(x) {
  org_item_to_row(x$as_list)
}

#' Convert a single organisation item list to a data.frame row
#'
#' Internal helper function to convert an organisation item to a data.frame row.
#' @param item A list representing an organisation item.
#' @return A data.frame with a single row.
#' @noRd
org_item_to_row <- function(item) {
  stopifnot(inherits(item, "org_item"))
  # Get all names as a JSON-like string for storage
  names_json <- paste(
    names(unlist(item$name)),
    unlist(item$name),
    sep = "=",
    collapse = "|"
  )
  data.frame(
    email = coalesce(item$email, ""),
    default_name = unname(item$name[[1]]),
    names = names_json,
    ror = coalesce(item$ror, ""),
    orcid = coalesce(item$orcid, FALSE),
    zenodo = coalesce(item$zenodo, ""),
    website = coalesce(item$website, ""),
    logo = coalesce(item$logo, ""),
    stringsAsFactors = FALSE
  )
}

#' Retrieve stored organisation information
#'
#' This function retrieves organisation information that was previously stored
#' using `store_organisations()`.
#' @return A data.frame with the stored organisation information.
#' The data.frame contains the columns: `email`, `default_name`, `names`,
#' `ror`, `orcid`, `zenodo`, `website`, and `logo`.
#' Returns an empty data.frame if no organisations are stored.
#' @export
#' @importFrom tools R_user_dir
#' @importFrom utils file_test read.table
#' @family organisation
stored_organisations <- function() {
  root <- R_user_dir("citeme", which = "data")
  org_file <- file.path(root, "organisation.txt")
  if (file_test("-f", org_file)) {
    org_file |>
      read.table(
        header = TRUE,
        sep = "\t",
        colClasses = c(
          "character",
          "character",
          "character",
          "character",
          "logical",
          "character",
          "character",
          "character"
        ),
        fileEncoding = "UTF8"
      ) -> current
    return(current)
  }
  # Return empty data.frame with the correct structure
  data.frame(
    email = character(0),
    default_name = character(0),
    names = character(0),
    ror = character(0),
    orcid = logical(0),
    zenodo = character(0),
    website = character(0),
    logo = character(0),
    stringsAsFactors = FALSE
  )
}

#' Write organisation data to file
#'
#' Internal helper function to write organisation data to the storage file.
#' @param org_df A data.frame with organisation information.
#' @return `NULL` invisibly.
#' @noRd
#' @importFrom tools R_user_dir
#' @importFrom utils write.table
write_organisations <- function(org_df) {
  root <- R_user_dir("citeme", which = "data")
  dir.create(root, recursive = TRUE, showWarnings = FALSE)
  org_file <- file.path(root, "organisation.txt")
  write.table(
    org_df,
    file = org_file,
    sep = "\t",
    row.names = FALSE,
    fileEncoding = "UTF8"
  )
  return(invisible(NULL))
}
