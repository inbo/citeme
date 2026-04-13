# Validate language code

A valid language code is a string in the format of `xx-YY`, where `xx`
is a two-letter lowercase language code and `YY` is a two-letter
uppercase country code. For example, `en-GB` for English (United
Kingdom) and `nl-BE` for Dutch (Belgium).

## Usage

``` r
validate_language(language)
```

## Arguments

- language:

  A string to validate

## Value

The input language code if it is valid, otherwise an error message.

## See also

Other validation:
[`validate_citation()`](https://inbo.github.io/citeme/reference/validate_citation.md),
[`validate_email()`](https://inbo.github.io/citeme/reference/validate_email.md),
[`validate_license()`](https://inbo.github.io/citeme/reference/validate_license.md),
[`validate_orcid()`](https://inbo.github.io/citeme/reference/validate_orcid.md),
[`validate_ror()`](https://inbo.github.io/citeme/reference/validate_ror.md),
[`validate_url()`](https://inbo.github.io/citeme/reference/validate_url.md)
