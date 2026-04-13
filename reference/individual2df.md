# Convert person object in a data.frame.

Results in a data.frame with the given name, family name, e-mail, ORCID,
affiliation and role. Missing elements result in an empty string (`""`).
Persons with multiple roles will have the roles as a comma separated
string.

## Usage

``` r
individual2df(person)
```

## Arguments

- person:

  The person object or a list of person objects, `NA` or `NULL`. Any
  `"character"` is converted to a person object using
  [`as.person()`](https://rdrr.io/r/utils/person.html) with a warning.

## See also

Other individual:
[`add_individual()`](https://inbo.github.io/citeme/reference/add_individual.md),
[`individual2badge()`](https://inbo.github.io/citeme/reference/individual2badge.md),
[`individual2person()`](https://inbo.github.io/citeme/reference/individual2person.md),
[`select_individual()`](https://inbo.github.io/citeme/reference/select_individual.md),
[`store_individuals()`](https://inbo.github.io/citeme/reference/store_individuals.md)
