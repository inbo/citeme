<!-- badges: start -->
[![Project Status: Concept - Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![GPL-3](https://img.shields.io/badge/License-GPL-3-brightgreen)](https://raw.githubusercontent.com/inbo/checklist/refs/heads/main/inst/generic_template/gplv3.md)
[![Release](https://img.shields.io/github/release/inbo/citeme.svg)](https://github.com/inbo/citeme/releases)
![GitHub Workflow Status](https://github.com/inbo/citeme/actions/workflows/check_on_main.yml/badge.svg)
![GitHub repo size](https://img.shields.io/github/repo-size/inbo/citeme)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/inbo/citeme.svg)
![r-universe name](https://inbo.r-universe.dev/badges/:name?color=c04384)
![r-universe package](https://inbo.r-universe.dev/badges/citeme)
[![Codecov test coverage](https://codecov.io/gh/inbo/citeme/branch/main/graph/badge.svg)](https://app.codecov.io/gh/inbo/citeme?branch=main)
<!-- badges: end -->

# citeme: Manage Person and Organisation Information

[Onkelinx, Thierry![ORCID logo](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-8804-4216)[^aut][^cre][^INBO]
[Research Institute for Nature and Forest (INBO)](mailto:info%40inbo.be)[^cph][^fnd][^pbl]

[^aut]: author
[^cre]: contact person
[^INBO]: Research Institute for Nature and Forest (INBO)
[^cph]: copyright holder
[^fnd]: funder
[^pbl]: publisher

**keywords**:  organisation, author, standardisation


<!-- description: start -->
Manage person and organisation information with validation and formatting capabilities. Provides R6 classes for managing organisations and their members, with support for multiple languages, ORCID identifiers, ROR identifiers, licensing requirements, and integration with citation management systems.
<!-- description: end -->

## Installation

You can install the development version of citeme from [GitHub](https://github.com/inbo/citeme) with:

``` r
# install.packages("remotes")
remotes::install_github("inbo/citeme")
```

## Example

This is a basic example which shows you how to create an organisation item:

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

Please note that the citeme project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
