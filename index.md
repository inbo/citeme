# citeme: Manage Person and Organisation Information

[Onkelinx, Thierry![ORCID
logo](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-8804-4216)[^1][^2][^3]
[Research Institute for Nature and Forest
(INBO)](mailto:info%40inbo.be)[^4][^5][^6]

**keywords**: organisation, author, standardisation

Manage person and organisation information with validation and
formatting capabilities. Provides R6 classes for managing organisations
and their members, with support for multiple languages, ORCID
identifiers, ROR identifiers, licensing requirements, and integration
with citation management systems.

## Installation

You can install the development version of citeme from
[GitHub](https://github.com/inbo/citeme) with:

``` r

# install.packages("remotes")
remotes::install_github("inbo/citeme")
```

## Example

This is a basic example which shows you how to create an organisation
item:

``` r

library(citeme)

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

Please note that the citeme project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

[^1]: author

[^2]: contact person

[^3]: Research Institute for Nature and Forest (INBO)

[^4]: copyright holder

[^5]: funder

[^6]: publisher
