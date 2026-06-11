# Ask for keywords This function prompts the user to enter one or more keywords separated by `;`. It will continue to prompt the user until at least one keyword is provided. The function returns a character vector of the entered keywords, with leading and trailing whitespace removed.

Ask for keywords This function prompts the user to enter one or more
keywords separated by `;`. It will continue to prompt the user until at
least one keyword is provided. The function returns a character vector
of the entered keywords, with leading and trailing whitespace removed.

## Usage

``` r
ask_keywords()
```

## Value

A character vector of keywords entered by the user.

## See also

Other question:
[`ask_email()`](https://inbo.github.io/citeme/reference/ask_email.md),
[`ask_language()`](https://inbo.github.io/citeme/reference/ask_language.md),
[`ask_new_license()`](https://inbo.github.io/citeme/reference/ask_new_license.md),
[`ask_orcid()`](https://inbo.github.io/citeme/reference/ask_orcid.md),
[`ask_ror()`](https://inbo.github.io/citeme/reference/ask_ror.md),
[`ask_url()`](https://inbo.github.io/citeme/reference/ask_url.md),
[`ask_yes_no()`](https://inbo.github.io/citeme/reference/ask_yes_no.md),
[`menu_first()`](https://inbo.github.io/citeme/reference/menu_first.md)

## Examples

``` r
if (FALSE) { # \dontrun{
keywords <- ask_keywords()
} # }
```
