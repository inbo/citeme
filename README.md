# orgauth

<!-- badges: start -->
<!-- badges: end -->

The goal of orgauth is to manage person and organisation information with validation and formatting capabilities. It provides R6 classes for managing organisations and their members, with support for multiple languages, ORCID identifiers, ROR identifiers, licensing requirements, and integration with citation management systems.

## Installation

You can install the development version of orgauth from [GitHub](https://github.com/inbo/orgauth) with:

``` r
# install.packages("remotes")
remotes::install_github("inbo/orgauth")
```

## Example

This is a basic example which shows you how to create an organisation item:

``` r
library(orgauth)

# Create an organisation item
org <- org_item$new(
  name = c(
    `en-GB` = "Research Institute for Nature and Forest (INBO)",
    `nl-BE` = "Instituut voor Natuur- en Bosonderzoek (INBO)"
  ),
  email = "info@inbo.be",
  orcid = TRUE,
  rightsholder = "shared",
  funder = "when no other"
)

# Print the organisation
org$print()
```

## Code of Conduct

Please note that the orgauth project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
