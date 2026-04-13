# Validate ROR

The Research Organization Registry ([ROR](https://ror.org/)) is a
global, community-led registry of open persistent identifiers for
research organizations. ROR makes it easy for anyone or any system to
disambiguate institution names and connect research organizations to
researchers and research outputs. Validate that a ROR is a string of 9
characters starting with 0, followed by 6 characters which can be a
letter (except i, l, o) or a digit, and ending with 2 digits.

## Usage

``` r
validate_ror(ror)
```

## Arguments

- ror:

  A ROR to validate.

## Value

A logical value indicating whether the ROR is valid.

## See also

Other validation:
[`validate_citation()`](https://inbo.github.io/citeme/reference/validate_citation.md),
[`validate_email()`](https://inbo.github.io/citeme/reference/validate_email.md),
[`validate_language()`](https://inbo.github.io/citeme/reference/validate_language.md),
[`validate_license()`](https://inbo.github.io/citeme/reference/validate_license.md),
[`validate_orcid()`](https://inbo.github.io/citeme/reference/validate_orcid.md),
[`validate_url()`](https://inbo.github.io/citeme/reference/validate_url.md)
