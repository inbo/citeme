# Add an individual to a file

Add an individual to a file

## Usage

``` r
add_individual(
  path = ".",
  role = c("aut", "cre", "ctb", "rev", "cph", "fnd", "pbl"),
  org = org_list$new()$read()
)
```

## Arguments

- path:

  A path to a file or directory. Supported file types:

  - Quarto files (`_quarto.yml` or `*.qmd`)

  - R package DESCRIPTION files

  - README files (`README.md` or `README.Rmd`)

  - Bookdown index files (`index.md` or `index.Rmd`)

- role:

  The role of the person to add. One or multiple of `"aut"` (author),
  `"cre"` (creator/maintainer), `"ctb"` (contributor), `"rev"`
  (reviewer), `"cph"` (copyright holder), `"fnd"` (funder), or `"pbl"`
  (publisher). Unless you want to an individual to a Quarto or bookdown
  document. Then you can only specify one role, and `"aut"` will be
  added to the `author` field, \#' `"rev"` to the `reviewer` field,
  `"cph"` to the `rightsholder` field, `"fnd"` to the `funder` field,
  and `"pbl"` to the `publisher` field.

- org:

  An `org_list` object containing the organisation information. Defaults
  to the `org_list` object read from the current working directory.

## See also

Other individual:
[`has_person_role()`](https://inbo.github.io/citeme/reference/has_person_role.md),
[`individual2badge()`](https://inbo.github.io/citeme/reference/individual2badge.md),
[`individual2df()`](https://inbo.github.io/citeme/reference/individual2df.md),
[`individual2person()`](https://inbo.github.io/citeme/reference/individual2person.md),
[`select_individual()`](https://inbo.github.io/citeme/reference/select_individual.md),
[`select_person_role()`](https://inbo.github.io/citeme/reference/select_person_role.md),
[`store_individuals()`](https://inbo.github.io/citeme/reference/store_individuals.md)
