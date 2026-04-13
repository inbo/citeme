# Validate a license list

Validate a license list

## Usage

``` r
validate_license(license)
```

## Arguments

- license:

  A list with three named character vectors: `package`, `project`, and
  `data`. Each vector should contain unique license names as values and
  unique package, project, or data names as names.

## Value

Invisibly returns `NULL` if the license list is valid, otherwise throws
an error.

## See also

Other validation:
[`validate_citation()`](https://inbo.github.io/citeme/reference/validate_citation.md),
[`validate_email()`](https://inbo.github.io/citeme/reference/validate_email.md),
[`validate_language()`](https://inbo.github.io/citeme/reference/validate_language.md),
[`validate_orcid()`](https://inbo.github.io/citeme/reference/validate_orcid.md),
[`validate_ror()`](https://inbo.github.io/citeme/reference/validate_ror.md),
[`validate_url()`](https://inbo.github.io/citeme/reference/validate_url.md)
