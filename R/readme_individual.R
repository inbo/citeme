#' @importFrom stats setNames
#' @importFrom utils person
readme_individual <- function(text, org) {
  text$text <- remove_empty_line(text$text, top = TRUE)
  if (length(text$text) == 0) {
    text$errors <- c(text$errors, "No individual information in README.md")
    return(text)
  }
  grep("^\\s*$", text$text) |>
    head(1) -> empty_line
  if (length(empty_line) == 0) {
    individuals <- text$text
  } else {
    individuals <- text$text[seq_len(empty_line - 1)]
  }
  individuals <- gsub(pattern = ";\\s*$", replacement = "", individuals)
  # detect individuals with affiliation as markdown footnote
  orgs <- individuals
  orgs[!grepl("\\[\\^.*\\]", orgs)] <- ""
  gsub(".*?\\[\\^(.*?)\\]", "\\1;", orgs) |>
    gsub(pattern = "(aut|cph|cre|ctb|fnd|pbl|rev);", replacement = "") |>
    gsub(pattern = ";$", replacement = "") |>
    strsplit(split = ";") -> orgs
  unlist(orgs) |>
    unique() |>
    sprintf(fmt = "\\[\\^%s\\]") -> to_remove
  # detect roles per individual as markdown footnote
  roles <- individuals
  for (pattern in to_remove) {
    gsub(pattern = pattern, "", roles) -> roles
  }
  gsub(".*?\\[\\^(.*)\\]", "\\1", roles) |>
    strsplit("\\] *\\[\\^") -> roles
  # detect ORCID
  individuals <- gsub("\\[\\^.*\\]", "", individuals)
  paste0(
    "^\\[(.*?)!\\[ORCID logo\\]",
    "\\(https:\\/\\/info\\.orcid\\.org\\/wp-content\\/uploads\\/2019\\/11\\/",
    "orcid_16x16\\.png\\)",
    "\\]",
    "\\(https:\\/\\/orcid\\.org\\/(.+)\\)$"
  ) -> orcid_grep
  ifelse(grepl(orcid_grep, individuals), individuals, "") |>
    gsub(pattern = orcid_grep, replacement = "\\2") -> individuals_orcid
  individuals <- gsub(orcid_grep, "\\1", individuals)
  # extract email
  email_grep <- "\\[(.*?)\\]\\((mailto:)+(.+?(@|%40){1}.+?)\\)"
  ifelse(grepl(email_grep, individuals), individuals, "") |>
    gsub(pattern = email_grep, replacement = "\\3") |>
    gsub(pattern = "%40", replacement = "@") -> individuals_email
  individuals <- gsub(email_grep, "\\1", individuals)

  if (length(empty_line) && empty_line > 0) {
    tail(text$text, -empty_line) |>
      remove_empty_line(top = TRUE) -> text$text
  }
  affiliations <- text$text[grepl("\\[\\^.*?\\]:", text$text)]
  aff_code <- gsub(".*\\[\\^(.*?)\\]:.*", "\\1", affiliations)
  aff_code_check <- vapply(
    orgs,
    FUN.VALUE = logical(1),
    aff_code = aff_code,
    FUN = function(z, aff_code) {
      all(z %in% aff_code)
    }
  )
  gsub("\\[\\^(.*?)\\]:\\s*(.*)", "\\2", affiliations) |>
    setNames(aff_code) -> affiliations
  individuals_aff <- vapply(
    orgs,
    FUN.VALUE = character(1),
    z = affiliations,
    FUN = function(y, z) {
      paste(z[y], collapse = "; ")
    }
  )
  text$errors <- c(
    text$errors,
    "No individuals found or no empty line after individual in README.md"[
      length(individuals) == 0
    ],
    "Nobody marked as individual in README.md. Add `[^aut]` behind the name"[
      !"aut" %in% unlist(roles)
    ],
    "No contact person found in README.md. Add `[^cre]` behind the name"[
      !"cre" %in% unlist(roles)
    ],
    "Multiple contact persons found in README.md."[
      sum(unlist(roles) == "cre") > 1
    ],
    "No copyright holder found in README.md. Add `[^cph]` behind the name"[
      !"cph" %in% unlist(roles)
    ],
    "No `[^aut]:` found in README.md."[!has_name(affiliations, "aut")],
    "No `[^cph]:` found in README.md."[!has_name(affiliations, "cph")],
    "No `[^cre]:` found in README.md."[!has_name(affiliations, "cre")],
    "Duplicate affiliations found in README.md."[anyDuplicated(aff_code) > 0],
    "Affiliation of some individuals not defined with `[^*]:` in README.md"[
      !all(aff_code_check)
    ],
    "Persons or insitutions without defined role in README.md."[
      any(lengths(roles) == 0)
    ]
  )

  text$text <- text$text[!grepl("\\[\\^.*?\\]:", text$text)]
  if (is.null(text$meta$language)) {
    return(text)
  }
  vapply(
    seq_along(individuals),
    FUN.VALUE = vector("list", 1),
    individuals = individuals,
    FUN = function(i, individuals) {
      if (individuals_orcid[i] != "") {
        comment <- c(ORCID = individuals_orcid[i])
      } else {
        comment <- c()
      }
      if (individuals_aff[i] != "") {
        comment <- c(comment, affiliation = individuals_aff[i])
      }
      person(
        given = gsub(".*,\\s*(.*)", "\\1", individuals[i]),
        family = ifelse(
          grepl(",", individuals[i]),
          gsub("(.*),.*", "\\1", individuals[i]),
          ""
        ),
        email = individuals_email[i],
        comment = comment,
        role = roles[i]
      ) |>
        list()
    }
  ) |>
    do.call(what = c) |>
    org$validate_person(lang = text$meta$language) -> text$person
  return(text)
}
