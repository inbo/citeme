#' @importFrom utils head
readme_badges <- function(text) {
  badges_start <- grep("<!-- badges: start -->", text)
  badges_end <- grep("<!-- badges: end -->", text)
  errors <- c(
    "Multiple `<!-- badges: start -->`README.md"[length(badges_start) > 1],
    "Multiple `<!-- badges: end -->`README.md"[length(badges_end) > 1],
    paste(
      "Mismatch between `<!-- badges: start -->` and",
      "`<!-- badges: end -->` README.md"
    )[
      length(badges_start) != length(badges_end)
    ],
    "`<!-- badges: end -->` before `<!-- badges: start -->` README.md"[
      any(
        head(badges_end, length(badges_start)) <=
          head(badges_start, length(badges_end))
      )
    ]
  )
  if (length(errors) > 0 || length(badges_start) == 0) {
    return(
      list(
        errors = errors,
        notes = character(0),
        text = text,
        warnings = character(0)
      )
    )
  }
  badges <- text[seq(badges_start + 1, badges_end - 1)]
  badge_regexp <- "^\\[?!\\[.*?\\]\\(.*?\\)(\\]\\(.*?\\))?"
  errors <- c(
    errors,
    "badges section in README.md should only contain images"[
      !all(grepl(badge_regexp, badges, perl = TRUE))
    ],
    "every line in the badges section README.md should hold only one image"[
      !all(grepl("^\\s*$", gsub(badge_regexp, "", badges, perl = TRUE)))
    ]
  )

  paste0(
    "\\[!\\[DOI\\]\\(https://zenodo.org/badge/DOI/(.*?)\\.svg\\)\\]",
    "\\(https://doi\\.org/(.*)\\)"
  ) -> doi_regexp
  doi_line <- grep(doi_regexp, badges)
  errors <- c(
    errors,
    "multiple DOI badges found in README.md"[length(doi_line) > 1]
  )
  notes <- "no DOI badge found in README.md"[length(doi_line) == 0]
  if (length(doi_line) != 1) {
    meta <- list()
  } else {
    doi <- gsub(doi_regexp, "\\1", badges[doi_line])
    errors <- c(
      errors,
      "DOI badge in README refers to different DOI"[
        doi != gsub(doi_regexp, "\\2", badges[doi_line])
      ]
    )
    meta <- list(doi = doi)
  }

  paste0(
    "!\\[version: (.+?)\\]\\(https:\\/\\/img\\.shields\\.io\\/badge\\/",
    "version-(.+?)-(.+?)\\)"
  ) -> version_regexp
  version_line <- grep(version_regexp, badges)
  errors <- c(
    errors,
    "multiple version badges found in README.md"[length(version_line) > 1]
  )
  notes <- "no version badge found in README.md"[length(version_line) == 0]
  if (length(version_line) == 1) {
    version <- gsub(version_regexp, "\\1", badges[version_line])
    errors <- c(
      errors,
      "version badge in README refers to different version"[
        version != gsub(version_regexp, "\\2", badges[version_line])
      ]
    )
    meta$version <- version
  }

  license_regexp <- paste0(
    "\\[\\!\\[(.*?)\\]\\(https:\\/\\/img\\.shields\\.io\\/badge\\/",
    "License-.*?-brightgreen\\)\\]\\(.*?\\)"
  )
  license_line <- grep(license_regexp, badges)
  errors <- c(
    errors,
    "multiple license badges found in README.md"[length(license_line) > 1]
  )
  notes <- c(
    notes,
    "no standard license badge found in README.md"[length(license_line) == 0]
  )
  if (length(license_line) == 1) {
    meta$license <- gsub(license_regexp, "\\1", badges[license_line])
  }

  paste0(
    "\\[!\\[website\\]\\(https://img.shields.io/badge/website-(.*?)-c04384\\)",
    "\\]\\((.*)\\)"
  ) -> website_regexp
  website_line <- grep(website_regexp, badges)
  errors <- c(
    errors,
    "multiple website badges found in README.md"[length(website_line) > 1]
  )
  notes <- c(
    notes,
    "no website badge found in README.md"[length(website_line) == 0]
  )
  if (length(website_line) == 1) {
    meta$url <- gsub(website_regexp, "\\2", badges[website_line])
  }
  meta$access_right <- "open"

  paste0(
    "!\\[Language: (.*)?\\]",
    "\\(https:\\/\\/img.shields.io\\/badge\\/language\\-(.*?)\\-\\w+\\)"
  ) -> language_regexp
  language_line <- grep(language_regexp, badges)
  errors <- c(
    errors,
    "multiple language badges found in README.md"[length(language_line) > 1]
  )
  notes <- c(
    notes,
    "no language badge found in README.md"[length(language_line) == 0]
  )
  if (length(language_line) == 1) {
    meta$language <- gsub(language_regexp, "\\1", badges[language_line])
    gsub(language_regexp, "\\2", badges[language_line]) |>
      gsub(pattern = "--", replacement = "-") -> second_language
    errors <- c(
      errors,
      "`language` must be in xx-YY format. e.g. 'en-GB', 'nl-BE'"[inherits(
        try(validate_language(meta$language)),
        "try-error"
      )],
      "mismatch between language in badge and in the URL in README.md"[
        meta$language != second_language
      ]
    )
  }

  list(
    errors = errors,
    notes = notes,
    meta = meta,
    text = text[-badges_start:-badges_end],
    warnings = character(0)
  )
}
