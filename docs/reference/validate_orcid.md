# Validate the structure of an `ORCID iD`

The [`ORCID iD`](https://orcid.org/) is a unique, persistent identifier
free of charge to researchers. Checks whether the `ORCID iD` has the
proper format and a correct checksum. The `ORCID iD` must be in the
format `0000-0000-0000-0000` where the last digit can be a number or
`"X"`. Empty strings are considered valid to allow optional `ORCID iD`.

## Usage

``` r
validate_orcid(orcid)
```

## Arguments

- orcid:

  A vector of ORCID

## Value

A logical vector with the same length as the input vector.

## See also

Other validation:
[`validate_citation()`](https://inbo.github.io/citeme/reference/validate_citation.md),
[`validate_email()`](https://inbo.github.io/citeme/reference/validate_email.md),
[`validate_language()`](https://inbo.github.io/citeme/reference/validate_language.md),
[`validate_license()`](https://inbo.github.io/citeme/reference/validate_license.md),
[`validate_ror()`](https://inbo.github.io/citeme/reference/validate_ror.md),
[`validate_url()`](https://inbo.github.io/citeme/reference/validate_url.md)
