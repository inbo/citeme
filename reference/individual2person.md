# Select the individual information to use as a `person` object

This function retrieves the individual information using
[`select_individual()`](https://inbo.github.io/citeme/reference/select_individual.md)
and converts it to a `person` object. If the `individual` argument is
not provided, it will prompt the user to select an individual. The
`person` object will include the given name, family name, email, ORCID,
and affiliation (if available) of the selected individual.

## Usage

``` r
individual2person(individual, role = "aut", lang)
```

## Arguments

- individual:

  An optional `individual` object to convert to a `person` object. If
  not provided, the function will prompt the user to select an
  individual.

- role:

  The role to use for the `person` object. Defaults to \`"aut"“
  (author).

- lang:

  The language to use for the affiliation.

## See also

Other individual:
[`add_individual()`](https://inbo.github.io/citeme/reference/add_individual.md),
[`individual2badge()`](https://inbo.github.io/citeme/reference/individual2badge.md),
[`individual2df()`](https://inbo.github.io/citeme/reference/individual2df.md),
[`select_individual()`](https://inbo.github.io/citeme/reference/select_individual.md),
[`store_individuals()`](https://inbo.github.io/citeme/reference/store_individuals.md)
