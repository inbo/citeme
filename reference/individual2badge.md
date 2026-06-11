# Create a markdown badge for an individual

This function creates a markdown badge for an individual, including
their name, ORCID, email, and affiliation if available. It also adds a
footnote with the individual's role and affiliation.

## Usage

``` r
individual2badge(
  individual,
  role = c("aut", "cre", "cph", "ctb", "fnd", "pbl", "rev")
)
```

## Arguments

- individual:

  A data frame with columns `given`, `family`, `orcid`, `email`, and
  `affiliation`.

- role:

  A character string indicating the individual's role. Must be one or
  more of `"aut"` (author), `"cre"` (contact person), `"cph"` (copyright
  holder), `"ctb"` (contributor), `"fnd"` (funder), `"rev"` (reviewer).
  Default is \`"aut"“.

## Value

A character string containing the markdown badge for the individual.

## See also

Other individual:
[`add_individual()`](https://inbo.github.io/citeme/reference/add_individual.md),
[`has_person_role()`](https://inbo.github.io/citeme/reference/has_person_role.md),
[`individual2df()`](https://inbo.github.io/citeme/reference/individual2df.md),
[`individual2person()`](https://inbo.github.io/citeme/reference/individual2person.md),
[`select_individual()`](https://inbo.github.io/citeme/reference/select_individual.md),
[`select_person_role()`](https://inbo.github.io/citeme/reference/select_person_role.md),
[`store_individuals()`](https://inbo.github.io/citeme/reference/store_individuals.md)
