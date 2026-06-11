# Interactive Input and Validation

## Introduction

The `citeme` package provides functions for interactive user input and
validation of common data types used in citation metadata. These
functions ensure data quality by validating user input against
established formats and standards.

## Interactive Input Functions

### Yes/No Questions

The
[`ask_yes_no()`](https://inbo.github.io/citeme/reference/ask_yes_no.md)
function provides a simple interface for yes/no questions with
validation.

``` r

library(citeme)
```

``` r

# Ask a yes/no question with default answer
answer <- ask_yes_no("Do you want to continue?", default = TRUE)

# Custom prompts
answer <- ask_yes_no(
  "Overwrite existing file?",
  default = FALSE,
  prompts = c("Yes", "No", "Cancel")
)
```

The function:

- Wraps [`utils::askYesNo()`](https://rdrr.io/r/utils/askYesNo.html)
  with additional validation
- Repeats the question until a valid answer is given
- Returns the default value in non-interactive sessions
- Handles invalid input gracefully with informative warnings

### ORCID Identifiers

The
[`ask_orcid()`](https://inbo.github.io/citeme/reference/ask_orcid.md)
function prompts for an [`ORCID iD`](https://orcid.org/), a unique
persistent identifier for researchers.

``` r

# Ask for an ORCID iD
orcid <- ask_orcid()

# Custom prompt
orcid <- ask_orcid(prompt = "Enter your ORCID: ")

# Empty strings are allowed (optional ORCID)
# Valid format: 0000-0000-0000-0000 (last digit can be X)
```

The function:

- Validates the ORCID format using
  [`validate_orcid()`](https://inbo.github.io/citeme/reference/validate_orcid.md)
- Allows empty strings for optional ORCID identifiers
- Repeats the prompt until valid input is provided
- Checks both format and checksum validity

### ROR Identifiers

The [`ask_ror()`](https://inbo.github.io/citeme/reference/ask_ror.md)
function prompts for a [ROR identifier](https://ror.org/), which
uniquely identifies research organisations.

``` r

# Ask for a ROR identifier
ror <- ask_ror()

# Valid format: https://ror.org/0abcd1234
```

The function:

- Validates the ROR format using
  [`validate_ror()`](https://inbo.github.io/citeme/reference/validate_ror.md)
- Ensures the identifier starts with `https://ror.org/`
- Checks the checksum component
- Repeats the prompt until valid input is provided

### Email Addresses

The
[`ask_email()`](https://inbo.github.io/citeme/reference/ask_email.md)
function prompts for an email address with format validation.

``` r

# Ask for an email address
email <- ask_email()

# Custom prompt
email <- ask_email(prompt = "Contact email: ")
```

The function:

- Validates email format using
  [`validate_email()`](https://inbo.github.io/citeme/reference/validate_email.md)
- Checks for proper structure (local@domain)
- Does not verify whether the address exists
- Repeats the prompt until valid format is provided

### URLs

The [`ask_url()`](https://inbo.github.io/citeme/reference/ask_url.md)
function prompts for a URL with validation.

``` r

# Ask for a URL
url <- ask_url("Please enter the website URL: ")

# The URL must start with http:// or https://
```

The function:

- Validates URL format using
  [`validate_url()`](https://inbo.github.io/citeme/reference/validate_url.md)
- Requires `http://` or `https://` prefix
- Repeats the prompt until valid input is provided

### Language Codes

The
[`ask_language()`](https://inbo.github.io/citeme/reference/ask_language.md)
function prompts for a language code following the [BCP
47](https://en.wikipedia.org/wiki/IETF_language_tag) standard.

``` r

# Ask for a language code
# The list of options is based on the languages used in the `org_list` object
# The user can add another language code if needed
lang <- ask_language(org = inbo_org_list())
```

The function:

- Validates against BCP 47 standard using
  [`validate_language()`](https://inbo.github.io/citeme/reference/validate_language.md)
- Accepts codes like `"en-GB"`, `"nl-BE"`, `"fr-FR"`
- Repeats the prompt until valid input is provided

### Licenses

The
[`ask_new_license()`](https://inbo.github.io/citeme/reference/ask_new_license.md)
function helps select or add a license for a project.

``` r

# Interactive license selection
org <- inbo_org_list()
license <- ask_new_license(org$get_listed_licenses)

# The function:
# 1. Lists available licenses
# 2. Allows selection or addition of new license
# 3. Validates the selection
```

### Menu Selection

The
[`menu_first()`](https://inbo.github.io/citeme/reference/menu_first.md)
function provides an interactive menu with the first option as default.
When used in a non-interactive session, it returns the index of the
first option.

``` r

# Create a menu
choices <- c("Option A", "Option B", "Option C")
selection <- menu_first(choices, title = "Select an option:")

# Returns the index of the selected option
# The first option is highlighted as default
```

## Validation Functions

All validation functions return logical vectors indicating whether each
element passes validation. They are designed to work with vectors,
making them suitable for batch validation.

### ORCID Validation

The
[`validate_orcid()`](https://inbo.github.io/citeme/reference/validate_orcid.md)
function checks both format and checksum of ORCID identifiers.

``` r

# Validate ORCID identifiers
orcids <- c(
  "0000-0001-2345-6789",
  "0000-0002-3456-789X",
  "invalid-orcid",
  ""
)
validate_orcid(orcids)
```

    [1]  TRUE FALSE FALSE  TRUE

The function:

- Checks format: `0000-0000-0000-0000` (last digit can be X)
- Validates checksum using modulo 11 algorithm
- Accepts empty strings
- Works with character vectors

### ROR Validation

The
[`validate_ror()`](https://inbo.github.io/citeme/reference/validate_ror.md)
function checks ROR identifier format and checksum.

``` r

# Validate ROR identifiers
validate_ror("02catss52")
```

    [1] TRUE

``` r

validate_ror("https://ror.org/02catss52")
```

    [1] FALSE

``` r

validate_ror("not-a-ror")
```

    [1] FALSE

The function:

- Validates the identifier structure
- Checks the checksum component
- Works with character vectors

### Email Validation

The
[`validate_email()`](https://inbo.github.io/citeme/reference/validate_email.md)
function checks email address format.

``` r

# Validate email addresses
emails <- c(
  "user@example.com",
  "firstname.lastname@domain.co.uk",
  "invalid.email",
  "@example.com"
)
validate_email(emails)
```

    [1]  TRUE  TRUE FALSE FALSE

``` r

# Returns logical vector indicating validity
```

The function:

- Uses comprehensive regex pattern from https://emailregex.com
- Checks local and domain parts
- Handles complex email formats
- Does not verify whether addresses exist
- Works with character vectors

### URL Validation

The
[`validate_url()`](https://inbo.github.io/citeme/reference/validate_url.md)
function checks URL format.

``` r

# Validate URLs
validate_url("https://example.com")
```

    [1] TRUE

``` r

validate_url("http://subdomain.example.org/path")
```

    [1] TRUE

``` r

validate_url("ftp://example.com") # Invalid (ftp not allowed)
```

    [1] FALSE

``` r

validate_url("not-a-url")
```

    [1] FALSE

The function:

- Requires `http://` or `https://` prefix
- Works on a string
- Does not verify whether URLs are accessible

### Language Code Validation

The
[`validate_language()`](https://inbo.github.io/citeme/reference/validate_language.md)
function checks language codes against BCP 47 standard.

``` r

# Validate language codes
validate_language("en-GB")
```

    [1] "en-GB"

``` r

validate_language("nl-BE")
```

    [1] "nl-BE"

``` r

validate_language("en")
```

    Error:
    ! `language` must be in xx-YY format. e.g. 'en-GB', 'nl-BE'

``` r

validate_language("invalid")
```

    Error:
    ! `language` must be in xx-YY format. e.g. 'en-GB', 'nl-BE'

``` r

# Returns logical vector indicating validity
```

The function:

- Validates against BCP 47 standard
- Accepts language-region combinations
- Works with character vectors

## Integration with Interactive Functions

The validation functions are automatically used by the interactive input
functions to ensure data quality. You can also use them independently
for batch validation or custom workflows.

``` r

# Batch validate ORCIDs from a data frame
contributors$valid_orcid <- validate_orcid(contributors$orcid)

# Filter to valid entries
valid_contributors <- contributors[contributors$valid_orcid, ]

# Batch validate emails
valid_emails <- contributors$email[validate_email(contributors$email)]
```

## Non-Interactive Behaviour

All interactive input functions (`ask_*`) have sensible behaviour in
non-interactive sessions:

- [`ask_yes_no()`](https://inbo.github.io/citeme/reference/ask_yes_no.md)
  returns the default value
- Other `ask_*` functions require pre-validated input or will fail

This allows you to use these functions in scripts and automated
workflows:

``` r

# In a non-interactive script
if (interactive()) {
  email <- ask_email()
} else {
  email <- Sys.getenv("USER_EMAIL")
  stopifnot(validate_email(email))
}
```

## Error Handling

The validation functions provide clear feedback when validation fails:

``` r

# Invalid ORCID will trigger warning and re-prompt
orcid <- ask_orcid()
# User enters: "1234-5678"
# Warning: Please provide a valid ORCiD in the format `0000-0000-0000-0000`

# Invalid email will trigger warning and re-prompt
email <- ask_email()
# User enters: "not-an-email"
# Warning: Please provide a valid email address
```

## Best Practices

1.  **Use validation functions early**: Validate input as soon as
    possible to provide immediate feedback.

2.  **Batch validation**: Use validation functions on vectors for
    efficient data cleaning.

3.  **Clear prompts**: Provide informative prompts that explain the
    expected format.

4.  **Handle optional fields**: Use empty string checks for optional
    identifiers like ORCID.

5.  **Non-interactive fallbacks**: Always provide fallbacks for
    non-interactive sessions.

6.  **Combine validators**: Use multiple validation functions for
    complex data requirements.

## Common Patterns

### Validating User Input

``` r

# Pattern: Validate before storing
if (interactive()) {
  email <- ask_email()
} else {
  email <- config$email
}
stopifnot("Invalid email" = validate_email(email))
```

### Cleaning Existing Data

``` r

# Pattern: Clean and filter data frame
data$valid_orcid <- validate_orcid(data$orcid)
data$valid_email <- validate_email(data$email)

clean_data <- data[data$valid_orcid & data$valid_email, ]
```

### Optional Fields

``` r

# Pattern: Handle optional ORCID
orcid <- ask_orcid() # Empty string is valid
if (orcid != "") {
  # Use ORCID
  person_comment <- c(ORCID = orcid)
}
```

### Batch Processing

``` r

# Pattern: Validate and report issues
contributors <- read.csv("contributors.csv")
invalid_emails <- contributors$email[!validate_email(contributors$email)]

if (length(invalid_emails) > 0) {
  warning(
    "Invalid emails found:\n",
    paste(invalid_emails, collapse = "\n")
  )
}
```

## Related Functions

For information about managing individual contributor information, see
[`vignette("individuals")`](https://inbo.github.io/citeme/articles/individuals.md).
For organisation-level configuration, see `vignette("organisations")`.
