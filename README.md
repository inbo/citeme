<!-- badges: start -->
[![Project Status: Concept - Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![GPL-3](https://img.shields.io/badge/License-GPL-3-brightgreen)](https://raw.githubusercontent.com/inbo/checklist/refs/heads/main/inst/generic_template/gplv3.md)
[![Release](https://img.shields.io/github/release/inbo/citeme.svg)](https://github.com/inbo/citeme/releases)
![GitHub Workflow Status](https://github.com/inbo/citeme/actions/workflows/check_package.yml/badge.svg)
![GitHub repo size](https://img.shields.io/github/repo-size/inbo/citeme)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/inbo/citeme.svg)
![r-universe name](https://inbo.r-universe.dev/badges/:name?color=c04384)
![r-universe package](https://inbo.r-universe.dev/badges/citeme)
[![Codecov test coverage](https://codecov.io/gh/inbo/citeme/branch/main/graph/badge.svg)](https://app.codecov.io/gh/inbo/citeme?branch=main)
<!-- badges: end -->

# citeme: Manage Person and Organisation Information

| [Onkelinx, Thierry![ORCID logo](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0001-8804-4216)[^aut] [^cre] [^INBO]
| [Research Institute for Nature and Forest (INBO)](mailto:info%40inbo.be)[^cph] [^fnd] [^pbl]

[^aut]: author
[^cre]: contact person
[^INBO]: Research Institute for Nature and Forest (INBO)
[^cph]: copyright holder
[^fnd]: funder
[^pbl]: publisher

**keywords**:  organisation, author, standardisation


<!-- description: start -->
Manage person and organisation information with validation and formatting capabilities. Provides R6 classes for managing organisations and their members, with support for multiple languages, ORCID identifiers, ROR identifiers, licensing requirements, publisher information, and integration with citation management systems.
<!-- description: end -->

## Overview

`citeme` keeps the authorship, affiliation and licensing metadata of your R packages, Quarto sites, **bookdown** books and plain project repositories correct, complete and consistent.
You record each person once (name, email, ORCID, affiliation) and each organisation once (names in several languages, ROR identifier, allowed licences, rules on copyright holder, funder and publisher).
From that single source of truth `citeme` creates the main source of citation information in your package.
Depending on the kind of project, this source is a `DESCRIPTION`, `_quarto.yml`, the yaml header in Quarto or bookdown document.
The fallback is the projects `README.md`.
`citeme` creates a `CITATION.cff`, `.zenodo.json`, `inst/CITATION` based on the source file.
Every value is validated before it is written, so a typo in an ORCID or an unsupported licence is caught in your project rather than in a repository such as Zenodo or CRAN.

## Why use citeme?

### Benefits for an individual user

- **Type your details once.**
  Your name, email, ORCID and affiliation are stored in your user data directory (`tools::R_user_dir("citeme", "data")`) and reused in every new project with `add_individual()` or `select_individual()`.
- **No hand-written citation files.**
  `citation_meta$new()` detects the project type and generates `CITATION.cff`, `.zenodo.json` and `inst/CITATION` from the metadata that is already in your project.
- **Mistakes surface early.**
  `validate_orcid()`, `validate_ror()`, `validate_email()`, `validate_url()` and `validate_language()` reject malformed identifiers.
  `citation_meta$new()` checks the licence against the SPDX list (requires R >= 4.6.0).
- **Metadata stays in step.**
  Change an affiliation or add a co-author and regenerating the citation files updates all of them at once.
  So the content of `CITATION.cff`, `.zenodo.json` and `inst/CITATION` always match the content in the source file.
- **Proper credit.**
  Contributor roles (`aut`, `cre`, `ctb`, `rev`, `cph`, `fnd`, `pbl`) and ORCID links are carried through to the README badges and to Zenodo, so your work is attributed to you when it is archived or cited.
- **Interactive where it helps.**
  Helpers such as `ask_orcid()`, `ask_email()`, `ask_keywords()` and `select_license()` prompt you with valid choices instead of leaving you to remember the exact syntax.

### Benefits for an organisation

- **One rulebook for all repositories.**
  An `organisation.yml` file, shared through a Git repository and read with `org_list$new()$read()` or `org_list_from_url()`, defines the official organisation names, the ROR identifier, the permitted licences and the rules for copyright holder, funder and publisher.
- **Consistent and correct affiliations.**
  Everyone uses the same spelling of the organisation name instead of a dozen variants, which makes outputs findable and attributable in bibliographic databases.
- **Automated compliance checks.**
  `org_list$check()` compares a project against the organisation rules and reports violations.
  It recognises a CI environment, so the check can run as part of a GitHub Actions workflow and block non-compliant releases.
- **Licensing under control.**
  Restrict the licences allowed for packages, projects and data (`get_allowed_licenses()`, `select_license()`), so legal requirements are met by default rather than by review.
- **Multilingual by design.**
  Organisation names are stored per language tag (for example `en-GB` and `nl-BE`), which suits bilingual and multilingual institutes.
- **Lower cost of introducing new staff.**
  New staff point at the organisation list and get compliant metadata from their first repository, without needing to learn the institutional conventions first.
- **Archive-ready output.**
  Zenodo communities and keywords are taken from `Config/citeme/communities` and `Config/citeme/keywords` in `DESCRIPTION`, so deposits land in the right community with the right indexing terms.

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
  funder = "when no other",
  publisher = "single"
)

# Print the organisation
org$print()
```

Store a set of organisations in `organisation.yml` and check a project against their rules:

``` r
# Read the organisation list from the current project
ol <- org_list$new()$read(".")

# Check the current project against the organisation rules
ol$check(".")

# Which licences may this organisation use for packages?
ol$get_allowed_licenses(type = "package")
```

Generate the citation files for the current project:

``` r
# Detects a package, Quarto site, bookdown book or plain project
meta <- citation_meta$new(".")

# Inspect what was found and any problems
meta

# Errors, warnings and the extracted metadata
meta$get_errors
meta$get_warnings
meta$get_meta
```

This writes `CITATION.cff`, `.zenodo.json` and, for packages, the `citeme` block in `inst/CITATION`.

Add yourself or a colleague as a contributor, and show the authors as badges in the README:

``` r
# Interactively add a person with a role to DESCRIPTION, README or _quarto.yml
add_individual(".", role = "aut")

# Refresh the author badges between the badge markers in the README
add_badges(".")
```

## Learn more

The vignettes cover the main topics in detail:

- `vignette("organisation", package = "citeme")` for organisation lists and their rules.
- `vignette("individuals", package = "citeme")` for storing and reusing person information.
- `vignette("interactive_input", package = "citeme")` for the interactive prompts and validation helpers.

Full documentation is available at <https://inbo.github.io/citeme/>.

## Code of Conduct

Please note that the citeme project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
