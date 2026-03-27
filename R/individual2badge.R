#' @title Create a markdown badge for an individual
#' @description
#' This function creates a markdown badge for an individual, including their
#' name, ORCID, email, and affiliation if available.
#' It also adds a footnote with the individual's role and affiliation.
#' @param individual A data frame with columns `given`, `family`, `orcid`,
#' `email`, and `affiliation`.
#' @param role A character string indicating the individual's role.
#' Must be one or more of `"aut"` (author), `"cre"` (contact person),
#' `"cph"` (copyright holder), `"ctb"` (contributor), `"fnd"` (funder),
#' `"rev"` (reviewer).
#' Default is `"aut"``.
#' @return A character string containing the markdown badge for the individual.
#' @export
#' @family individual
individual2badge <- function(
  individual,
  role = c("aut", "cre", "cph", "ctb", "fnd", "rev")
) {
  role <- match.arg(role, several.ok = TRUE)
  if (nrow(individual) > 1) {
    return(individuals2badge(individual, role = role))
  }
  sprintf("[^%s]", role) |>
    paste(collapse = "") -> role_link
  if (is.na(individual$orcid) || individual$orcid == "") {
    if (is.na(individual$email) || individual$email == "") {
      ifelse(individual$family == "", "", paste0(individual$family, ", ")) |>
        paste0(individual$given, role_link) -> badge
    } else {
      individual$email |>
        gsub(pattern = "@", replacement = "%40") |>
        sprintf(
          fmt = "[%2$s%3$s](mailto:%1$s)%4$s",
          ifelse(individual$family == "", "", paste0(individual$family, ", ")),
          individual$given,
          role_link
        ) -> badge
    }
  } else {
    badge <- paste0(
      "[%s, %s![ORCID logo](https://info.orcid.org/wp-content/uploads/2019/11/",
      "orcid_16x16.png)](https://orcid.org/%s)%s"
    ) |>
      sprintf(individual$family, individual$given, individual$orcid, role_link)
  }
  c(
    aut = "author",
    cre = "contact person",
    cph = "copyright holder",
    ctb = "contributor",
    fnd = "funder",
    rev = "reviewer"
  )[role] |>
    sprintf(fmt = "[^%2$s]: %1$s", role) -> attr(badge, "footnote")
  if (is.na(individual$affiliation) || individual$affiliation == "") {
    return(badge)
  }
  if (grepl("\\(.+\\)", individual$affiliation)) {
    aff <- gsub(".*\\((.+)\\).*", "\\1", individual$affiliation)
  } else {
    aff <- abbreviate(individual$affiliation)
  }

  sprintf("%s[^%s]", badge, aff) |>
    `attr<-`(
      which = "footnote",
      value = c(
        attr(badge, "footnote"),
        sprintf("[^%s]: %s", aff, individual$affiliation)
      )
    )
}

individuals2badge <- function(df, role = "aut") {
  badges <- character(nrow(df))
  footnotes <- vector(mode = "list", length = nrow(df))
  for (i in seq_len(nrow(df))) {
    if (has_name(df, "role")) {
      strsplit(df$role[i], ", ") |>
        unlist() -> this_role
    } else {
      this_role <- role
    }
    badge <- individual2badge(df[i, ], role = this_role)
    footnotes[[i]] <- attr(badge, "footnote")
    badges[i] <- badge
  }
  attr(badges, which = "footnote") <- unlist(footnotes) |>
    unique()
  return(badges)
}
