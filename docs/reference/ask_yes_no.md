# Function to ask a simple yes no question

Provides a simple wrapper around
[`utils::askYesNo()`](https://rdrr.io/r/utils/askYesNo.html). This
function is used to ask yes no questions in an interactive way. It
repeats the question until a valid answer is given.

## Usage

``` r
ask_yes_no(msg, default = TRUE, prompts = c("Yes", "No", "Cancel"), ...)
```

## Arguments

- msg:

  The prompt message for the user.

- default:

  The default response.

- prompts:

  Any of: a character vector containing 3 prompts corresponding to
  return values of `TRUE`, `FALSE`, or `NA`, or a single character value
  containing the prompts separated by `/` characters, or a function to
  call.

- ...:

  Additional parameters, ignored by the default function.

## See also

Other question:
[`ask_email()`](https://inbo.github.io/citeme/reference/ask_email.md),
[`ask_language()`](https://inbo.github.io/citeme/reference/ask_language.md),
[`ask_new_license()`](https://inbo.github.io/citeme/reference/ask_new_license.md),
[`ask_orcid()`](https://inbo.github.io/citeme/reference/ask_orcid.md),
[`ask_ror()`](https://inbo.github.io/citeme/reference/ask_ror.md),
[`ask_url()`](https://inbo.github.io/citeme/reference/ask_url.md),
[`menu_first()`](https://inbo.github.io/citeme/reference/menu_first.md)
