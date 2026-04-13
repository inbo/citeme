# Improved version of `utils::menu()`

This function is a wrapper around
[`utils::menu()`](https://rdrr.io/r/utils/menu.html) that returns the
index of the first choice instead of the index of the selected choice.
This is useful when you want to ask a question with only one choice and
you want to return a logical value.

## Usage

``` r
menu_first(choices, graphics = FALSE, title = NULL)
```

## Arguments

- choices:

  a character vector of choices

- graphics:

  a logical indicating whether a graphics menu should be used if
  available.

- title:

  a character string to be used as the title of the menu. `NULL` is also
  accepted.

## See also

Other question:
[`ask_email()`](https://inbo.github.io/citeme/reference/ask_email.md),
[`ask_language()`](https://inbo.github.io/citeme/reference/ask_language.md),
[`ask_new_license()`](https://inbo.github.io/citeme/reference/ask_new_license.md),
[`ask_orcid()`](https://inbo.github.io/citeme/reference/ask_orcid.md),
[`ask_ror()`](https://inbo.github.io/citeme/reference/ask_ror.md),
[`ask_url()`](https://inbo.github.io/citeme/reference/ask_url.md),
[`ask_yes_no()`](https://inbo.github.io/citeme/reference/ask_yes_no.md)
