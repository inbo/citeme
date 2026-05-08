# Ask for an `ORCID iD`

The [`ORCID iD`](https://orcid.org/) is a unique, persistent identifier
free of charge to researchers. This function prompts the user to enter
an `ORCID iD` and validates its format. The `ORCID iD` must be in the
format `0000-0000-0000-0000` where the last digit can be a number or
`"X"`. Empty strings are considered valid to allow optional `ORCID iD`.

## Usage

``` r
ask_orcid(prompt = "orcid: ")
```

## Arguments

- prompt:

  A character string to display as a prompt to the user. The default is
  `"orcid: "`.

## Value

A character string containing the `ORCID iD` entered by the user.

## See also

Other question:
[`ask_email()`](https://inbo.github.io/citeme/reference/ask_email.md),
[`ask_language()`](https://inbo.github.io/citeme/reference/ask_language.md),
[`ask_new_license()`](https://inbo.github.io/citeme/reference/ask_new_license.md),
[`ask_ror()`](https://inbo.github.io/citeme/reference/ask_ror.md),
[`ask_url()`](https://inbo.github.io/citeme/reference/ask_url.md),
[`ask_yes_no()`](https://inbo.github.io/citeme/reference/ask_yes_no.md),
[`menu_first()`](https://inbo.github.io/citeme/reference/menu_first.md)
