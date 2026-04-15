#' Add an individual to a file
#' @param path A path to a file or directory.
#' Supported file types:
#' - Quarto files (`_quarto.yml` or `*.qmd`)
#' - R package DESCRIPTION files
#' - README files (`README.md` or `README.Rmd`)
#' - Bookdown index files (`index.md` or `index.Rmd`)
#' @param role The role of the person to add.
#' One of `"aut"` (author), `"cre"` (creator/maintainer), `"ctb"`
#' (contributor), `"rev"` (reviewer), `"cph"` (copyright holder),
#' `"fnd"` (funder), or `"pbl"` (publisher).
#' @export
#' @family individual
add_individual <- function(
  path = ".",
  role = c("aut", "cre", "ctb", "rev", "cph", "fnd", "pbl")
) {
  role <- match.arg(role)
  path <- determine_type(path)
  switch(
    names(path),
    quarto = add_individual_quarto(path, role = role),
    description = add_individual_description(path, role = role),
    readme = add_individual_readme(path, role = role),
    stop("`path` type is not supported")
  )
}

#' @importFrom stats setNames
#' @importFrom utils file_test head
determine_type <- function(path) {
  stopifnot(
    "`path` must be a single string" = length(path) == 1,
    "`path` must be a single string" = inherits(path, "character"),
    "`path` must be a single string" = !is.na(path),
    "`path` does not exist" = file.exists(path)
  )
  # handle existing file
  if (file_test("-d", path)) {
    path <- list.files(path, full.names = TRUE)
  }
  c(
    "_quarto.yml"["_quarto.yml" %in% basename(path)],
    "index.qmd"["index.qmd" %in% basename(path)],
    "index.Rmd"["index.Rmd" %in% basename(path)],
    "index.md"["index.md" %in% basename(path)],
    "quarto.qmd"[length(path) == 1 && grepl(".qmd$", basename(path))],
    "DESCRIPTION"["DESCRIPTION" %in% basename(path)],
    "README.Rmd"["README.Rmd" %in% basename(path)],
    "README.md"["README.md" %in% basename(path)]
  ) |>
    head(1) -> type
  stopifnot("no supported file found in `path`" = length(type) == 1)
  if (type == "quarto.qmd") {
    return(c(quarto = path))
  }
  dirname(path[1]) |>
    file.path(type) |>
    setNames(
      c(
        `_quarto.yml` = "quarto",
        `index.qmd` = "quarto",
        `index.Rmd` = "quarto",
        `index.md` = "quarto",
        `DESCRIPTION` = "description",
        `README.Rmd` = "readme",
        `README.md` = "readme"
      )[type]
    )
}

#' @importFrom desc description
add_individual_description <- function(path, role) {
  meta <- citation_meta$new(dirname(path))
  descript <- description$new(file = path)
  individual <- select_individual(lang = meta$get_meta$language)
  new_person <- individual2person(
    individual,
    role = role,
    lang = meta$get_meta$language
  )
  descript$add_author(
    given = new_person$given,
    family = new_person$family,
    email = new_person$email,
    role = new_person$role,
    comment = new_person$comment
  )
  descript$write()
  message("Added ", new_person$given, " ", new_person$family, " to ", path)
  return(invisible(new_person))
}

#' @importFrom utils head tail
add_individual_readme <- function(path, role) {
  meta <- citation_meta$new(path)
  content <- readLines(path)
  individual <- select_individual(lang = meta$get_meta$language)
  individual_line <- individuals2badge(individual, role = role)
  # Find the position to insert the individual
  insert_position <- find_individual_insert_position(content)
  # Insert the individual line
  if (insert_position > 0) {
    content <- c(
      head(content, insert_position),
      individual_line,
      attr(individual_line, "footnote")[
        !attr(individual_line, "footnote") %in% content
      ],
      tail(content, -insert_position)
    )
  } else {
    # Append after the title line if no individuals found
    grep("^#\\s+", content) |>
      head(1) -> title_line
    if (length(title_line) == 1) {
      content <- c(
        head(content, title_line),
        "",
        individual_line,
        attr(individual_line, "footnote"),
        "",
        tail(content, -title_line)
      )
    } else {
      # No title found, append at the beginning
      content <- c(
        individual_line,
        attr(individual_line, "footnote"),
        "",
        content
      )
    }
  }
  writeLines(content, path)
  message(
    "Added ",
    individual$given,
    " ",
    individual$family,
    " to ",
    path
  )
  return(invisible(individual))
}

#' Find the position to insert a new individual in README
#' @param content Character vector of README content lines.
#' @return The line number where to insert, or 0 if not found.
#' @noRd
find_individual_insert_position <- function(content) {
  # Look for existing individual lines (lines with role footnotes)
  role_pattern <- "\\[\\^(aut|cre|ctb|rev|cph|fnd|pbl)\\]"
  individual_lines <- grep(role_pattern, content)
  if (length(individual_lines) == 0) {
    return(0L)
  }
  # Return the line after the last individual
  max(individual_lines)
}

add_individual_quarto <- function(
  path,
  role = c("aut", "rev", "cph", "fnd", "pbl")
) {
  meta <- citation_meta$new(dirname(path))
  role <- match.arg(role)
  header <- get_yaml_header(path)
  select_individual(lang = meta$get_meta$language) |>
    individual2list() -> extra
  element <- switch(
    role,
    aut = "author",
    rev = "reviewer",
    cph = "rightsholder",
    fnd = "funder",
    pbl = "publisher"
  )
  section <- c("flandersqmd", "book", "website")
  section[section %in% names(header)] |>
    head(1) -> section
  if (length(section) == 1) {
    header[[section]][[element]] <- c(header[[section]][[element]], list(extra))
  } else {
    header[[element]] <- c(header[[element]], list(extra))
  }
  write_yaml_header(header)
}

#' @importFrom yaml read_yaml
get_yaml_header <- function(path) {
  content <- readLines(path)
  if (basename(path) == "_quarto.yml") {
    header <- read_yaml(text = content)
    attr(header, "path") <- path
    return(header)
  }
  idx <- grep("^---\\s*$", content)
  stopifnot(
    "unable to find two YAML header delimiters (`---`)" = length(idx) == 2
  )
  header <- read_yaml(text = content[seq(idx[1] + 1, idx[2] - 1)])
  attr(header, "path") <- path
  attr(header, "pre") <- head(content, idx[1] - 1)
  attr(header, "post") <- tail(content, -idx[2])
  return(header)
}

#' @importFrom yaml as.yaml write_yaml
write_yaml_header <- function(header) {
  path <- attr(header, "path")
  if (!"pre" %in% names(attributes(header))) {
    write_yaml(header, file = path)
    return(invisible(NULL))
  }
  pre <- attr(header, "pre")
  post <- attr(header, "post")
  yaml_content <- as.yaml(header)
  c(pre, "---", yaml_content, "---", post) |>
    writeLines(con = path)
  return(invisible(NULL))
}

individual2list <- function(individual) {
  individual_list <- list(
    name = list(given = individual$given, family = individual$family)
  )
  if (!is.na(individual$email) && individual$email != "") {
    individual_list$email <- individual$email
  }
  if (!is.na(individual$orcid) && individual$orcid != "") {
    individual_list$orcid <- individual$orcid
  }
  if (!is.na(individual$affiliation) && individual$affiliation != "") {
    individual_list$affiliation <- list(individual$affiliation)
  }
  return(individual_list)
}
