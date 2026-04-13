# Select an individual from the local database or add a new individual.

Reuse existing individual information or add a new individual. Allows to
update existing individual information.

## Usage

``` r
select_individual(email, lang)
```

## Arguments

- email:

  An optional email address. When given and it matches with a single
  person, the function immediately returns the information of that
  person.

- lang:

  The language to use for the affiliation. Defaults to the first
  language in the `name` vector of the `org_list` object. When the
  affiliation is not available in that language, it will use the first
  available language.

## Value

A data.frame with individual information.

## See also

Other individual:
[`add_individual()`](https://inbo.github.io/citeme/reference/add_individual.md),
[`individual2badge()`](https://inbo.github.io/citeme/reference/individual2badge.md),
[`individual2df()`](https://inbo.github.io/citeme/reference/individual2df.md),
[`individual2person()`](https://inbo.github.io/citeme/reference/individual2person.md),
[`store_individuals()`](https://inbo.github.io/citeme/reference/store_individuals.md)
