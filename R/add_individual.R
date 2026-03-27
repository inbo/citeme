#' Add an individual to a file
#' @param path A path to a file or directory.
#' The file must be a quarto file (e.g. `_quarto.yml` or `*.qmd`).
#' @param role The role of the person to add.
#' One of `"aut"` (author), `"rev"` (reviewer), `"cph"` (copyright holder), or
#' `"fnd"` (funder).
#' @export
#' @family individual
add_individual <- function(path = ".", role = c("aut", "rev", "cph", "fnd")) {
  role <- match.arg(role)
  path <- determine_type(path)
  switch(
    names(path),
    quarto = add_individual_quarto(path, role = role),
    stop("`path` type is not supported")
  )
}

determine_type <- function(path) {
  stopifnot(
    "`path` must be a single string" = length(path) == 1,
    "`path` must be a single string" = inherits(path, "character"),
    "`path` must be a single string" = !is.na(path),
    "`path` does not exist" = file.exists(path)
  )
  # handle existing file
  if (file_test("-f", path)) {
    # check if it's a quarto file
    if (grepl("^(_quarto.yml|.+\\.qmd)$", basename(path))) {
      return(c(quarto = path))
    }
    stop("non quarto `path` is to do")
  }
  stop("`path` as directory is to do")
}

add_individual_quarto <- function(path, role = c("aut", "rev", "cph", "fnd")) {
  role <- match.arg(role)
  header <- get_yaml_header(path)
  select_individual(lang = header$lang) |>
    individual2list() -> extra
  if ("flandersqmd" %in% names(header)) {
    element <- switch(
      role,
      aut = "author",
      rev = "reviewer",
      cph = "rightsholder",
      fnd = "funder"
    )
    header[["flandersqmd"]][[element]] <- c(
      header[["flandersqmd"]][[element]],
      list(extra)
    )
  } else {
    stop("to do")
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
