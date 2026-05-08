# Organisations

## Why bother setting up an `org_list`?

`citeme` uses the `org_list` to check whether a project complies with
the organisation’s rules about naming conventions, copyright holders,
funders, and publishers. This allows an organisation to enforce a
consistent set of rules across all its projects.

## The `org_item` class

The `org_item` class stores information about a single organisation. It
requires two mandatory fields: `name` and `email`.

- `name` must be a named character vector where each name is a [BCP
  47](https://www.rfc-editor.org/rfc/bcp/bcp47.txt) language code
  (e.g. `"en-GB"`, `"nl-BE"`). This allows the organisation name to be
  used in different languages. The first entry is used as the default
  when no matching language is available.
- `email` serves two purposes:
  1.  It gives users a contact point for the organisation when
      individual authors are unavailable.
  2.  `citeme` uses the email domain to detect whether a person is
      affiliated with the organisation.

Optionally you can provide:

- A [ROR identifier](https://ror.org/) (`ror`)
- A website URL (`website`)
- A logo URL (`logo`)
- Whether affiliated persons must have an [ORCID
  identifier](https://orcid.org/) (`orcid`)
- A [Zenodo community](https://zenodo.org/communities#community-info)
  identifier (`zenodo`)
- Allowed licenses per project type (`license`)

### Roles: `rightsholder`, `funder`, and `publisher`

`org_item` defines the required status of the organisation for each of
the three roles: `rightsholder`, `funder`, and `publisher`. Each accepts
one of the following values:

| Value | Meaning |
|----|----|
| `"optional"` | The organisation may or may not be listed in this role. |
| `"single"` | The organisation must be listed and no other organisation may be listed. |
| `"shared"` | The organisation must be listed; other organisations may be listed too. |
| `"when no other"` | The organisation must be listed only if no other organisation is listed. |

The default for all three roles is `"optional"`.

## The `org_list` class

The `org_list` class holds a collection of `org_item` objects. The rules
of the different items must be mutually compatible. For example, if one
organisation has `rightsholder = "single"`, no other organisation can be
set to `"single"` or `"shared"` for the same role.

The `org_list` also stores the URL of the organisation’s git host.
`citeme` looks for an `organisation.yml` file in the `citeme` repository
at that URL to retrieve the minimum rules for the organisation. For
example, when `git = "https://github.com/inbo"`, `citeme` looks at
`https://github.com/inbo/citeme`.

## Creating an `org_list` programmatically

Use `org_item$new()` to create `org_item` objects. Note that license
values must be URLs pointing to publicly accessible Markdown files with
the license text. We recommend hosting these files in your
organisation’s `citeme` repository. `citeme` caches license files
locally and includes them as `LICENSE.md` in packages and projects.

``` r

library(citeme)

inbo <- org_item$new(
  name = c(
    "nl-BE" = "Instituut voor Natuur- en Bosonderzoek (INBO)",
    "en-GB" = "Research Institute for Nature and Forest (INBO)"
  ),
  email = "info@inbo.be",
  website = "https://www.vlaanderen.be/inbo/en-gb",
  logo = "https://inbo.github.io/citeme/reference/figures/logo-en.png",
  ror = "00j54wy13",
  orcid = TRUE,
  zenodo = "inbo",
  rightsholder = "shared",
  funder = "when no other",
  publisher = "when no other",
  license = list(
    package = c(
      `GPL-3.0` = paste(
        "https://raw.githubusercontent.com/inbo/citeme/refs/heads/main",
        "inst/licenses/gplv3.md",
        sep = "/"
      ),
      MIT = paste(
        "https://raw.githubusercontent.com/inbo/citeme/refs/heads/main",
        "inst/licenses/mit.md",
        sep = "/"
      )
    ),
    project = c(
      `CC BY 4.0` = paste(
        "https://raw.githubusercontent.com/inbo/citeme/refs/heads/main",
        "inst/licenses/cc_by_4_0.md",
        sep = "/"
      )
    ),
    data = c(
      `CC0` = paste(
        "https://raw.githubusercontent.com/inbo/citeme/refs/heads/main",
        "inst/licenses/cc0.md",
        sep = "/"
      )
    )
  )
)
inbo
```

    name
    - nl-BE: Instituut voor Natuur- en Bosonderzoek (INBO)
    - fr-FR: Institut de Recherche sur la Nature et les Forêts (INBO)
    - en-GB: Research Institute for Nature and Forest (INBO)
    - de-DE: Institut für Natur- und Waldforschung (INBO)
    email: info@inbo.be
    ROR: 00j54wy13
    ORCID is required
    zenodo community: inbo
    website: https://www.vlaanderen.be/inbo/en-gb
    logo: https://inbo.github.io/citeme/reference/figures/logo-en.png
    copyright holder: shared
    funder: when no other
    publisher: when no other
    allowed licenses:
    - package: GPL-3 or MIT
    - project: CC BY 4.0
    - data: CC0

``` r

anb <- org_item$new(
  name = c(
    `nl-BE` = "Agentschap voor Natuur en Bos (ANB)",
    `en-GB` = "Agency for Nature & Forests (ANB)"
  ),
  email = "natuurenbos@vlaanderen.be",
  ror = "04wcznf70",
  license = list(
    package = character(0),
    project = character(0),
    data = character(0)
  )
)
anb
```

    name
    - nl-BE: Agentschap voor Natuur en Bos (ANB)
    - en-GB: Agency for Nature & Forests (ANB)
    email: natuurenbos@vlaanderen.be
    ROR: 04wcznf70
    copyright holder: optional
    funder: optional
    publisher: optional
    allowed licenses:
    - package: no requirements
    - project: no requirements
    - data: no requirements

Then combine the items into an `org_list`:

``` r

inbo_org <- org_list$new(inbo, anb, git = "https://github.com/inbo")
inbo_org
```


    ################################################################################
     organisation 1
    ................................................................................
    name
    - nl-BE: Instituut voor Natuur- en Bosonderzoek (INBO)
    - fr-FR: Institut de Recherche sur la Nature et les Forêts (INBO)
    - en-GB: Research Institute for Nature and Forest (INBO)
    - de-DE: Institut für Natur- und Waldforschung (INBO)
    email: info@inbo.be
    ROR: 00j54wy13
    ORCID is required
    zenodo community: inbo
    website: https://www.vlaanderen.be/inbo/en-gb
    logo: https://inbo.github.io/citeme/reference/figures/logo-en.png
    copyright holder: shared
    funder: when no other
    publisher: when no other
    allowed licenses:
    - package: GPL-3 or MIT
    - project: CC BY 4.0
    - data: CC0

    ################################################################################
     organisation 2
    ................................................................................
    name
    - nl-BE: Agentschap voor Natuur en Bos (ANB)
    - en-GB: Agency for Nature & Forests (ANB)
    email: natuurenbos@vlaanderen.be
    ROR: 04wcznf70
    copyright holder: optional
    funder: optional
    publisher: optional
    allowed licenses:
    - package: no requirements
    - project: no requirements
    - data: no requirements

    ################################################################################
    git organisation: https://github.com/inbo
    ################################################################################

The final step is to store the `org_list` in a `citeme` repository.
[`write()`](https://rdrr.io/r/base/write.html) creates an
`organisation.yml` file in the given directory. Commit and push this
file to the remote repository.

``` r

path_to_citeme_repo <- tempfile("citeme")
dir.create(path_to_citeme_repo, recursive = TRUE)
inbo_org$write(path_to_citeme_repo)
```

    [1] "/tmp/RtmpOrqMNL/citeme11f37ffe3497/organisation.yml"

## Creating an `org_list` interactively

Use
[`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md)
to build an `org_list` step by step in an interactive session.
[`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md)
similarly walks you through creating a single `org_item`. Both functions
are intended for use in the console, not inside scripts.

## Getting the default `org_list` for a project

Run
[`get_default_org_list()`](https://inbo.github.io/citeme/reference/get_default_org_list.md)
inside a git project to fetch the default organisation list from the
organisation’s `citeme` repository. The function uses the `origin`
remote of the project to determine which organisation to look up.

[`get_default_org_list()`](https://inbo.github.io/citeme/reference/get_default_org_list.md)
stores the result in `citeme`’s user-level configuration. You only need
to run it once per organisation, or when the organisation’s defaults
change. After that, `org_list$new()$read()` returns the cached
information.

``` r

# Set up a demo git repository
test_dir <- tempfile("test")
dir.create(test_dir)
library(gert)
git_init(test_dir)
git_remote_add(
  url = "https://github.com/inbo/test",
  name = "origin",
  repo = test_dir
)
# Fetch the default organisation list from https://github.com/inbo/citeme
my_org <- get_default_org_list(test_dir)
my_org
```

## Adding an `org_item` to an existing `org_list`

Use the `add_item()` method to extend an existing `org_list`. Call
[`write()`](https://rdrr.io/r/base/write.html) afterwards to persist the
change to the local `organisation.yml` file.

``` r

# Read the current organisation list from a project directory
my_org <- org_list$new()$read(test_dir)
# Add an organisation to the list
my_org <- my_org$add_item(anb)
my_org
# Persist to disc
my_org$write(test_dir)
```

## The built-in INBO organisation list

`citeme` ships with
[`inbo_org_list()`](https://inbo.github.io/citeme/reference/inbo_org_list.md),
a ready-to-use `org_list` for projects affiliated with the Research
Institute for Nature and Forest (INBO) and its partner organisations.

``` r

inbo_org_list()
```


    ################################################################################
     organisation 1
    ................................................................................
    name
    - nl-BE: Instituut voor Natuur- en Bosonderzoek (INBO)
    - fr-FR: Institut de Recherche sur la Nature et les Forêts (INBO)
    - en-GB: Research Institute for Nature and Forest (INBO)
    - de-DE: Institut für Natur- und Waldforschung (INBO)
    email: info@inbo.be
    ROR: 00j54wy13
    ORCID is required
    zenodo community: inbo
    website: https://www.vlaanderen.be/inbo/en-gb
    logo: https://inbo.github.io/citeme/reference/figures/logo-en.png
    copyright holder: shared
    funder: when no other
    publisher: when no other
    allowed licenses:
    - package: GPL-3 or MIT
    - project: CC BY 4.0
    - data: CC0

    ################################################################################
     organisation 2
    ................................................................................
    name
    - nl-BE: Agentschap voor Natuur en Bos (ANB)
    - en-GB: Agency for Nature & Forests (ANB)
    email: natuurenbos@vlaanderen.be
    ROR: 04wcznf70
    website: https://www.natuurenbos.be/
    copyright holder: optional
    funder: optional
    publisher: optional
    allowed licenses:
    - package: no requirements
    - project: no requirements
    - data: no requirements

    ################################################################################
     organisation 3
    ................................................................................
    name
    - nl-BE: Department Omgeving
    email: omgeving@vlaanderen.be
    website: https://omgeving.vlaanderen.be/
    logo: https://omgeving.vlaanderen.be/sites/default/files/entiteitslogo-DOMG-92k2.png
    copyright holder: optional
    funder: optional
    publisher: optional
    allowed licenses:
    - package: no requirements
    - project: no requirements
    - data: no requirements

    ################################################################################
     organisation 4
    ................................................................................
    name
    - nl-BE: Instituut voor Landbouw-, Visserij- en Voedingsonderzoek (ILVO)
    - en-GB: Flanders Research Institute for Agriculture, Fisheries and Food (ILVO)
    email: ilvo@ilvo.vlaanderen.be
    ROR: 05cjt1n05
    website: https://ilvo.vlaanderen.be/en
    logo: https://ilvo.vlaanderen.be/uploads/images/logo-ILVO-2016-eng.png
    copyright holder: optional
    funder: optional
    publisher: optional
    allowed licenses:
    - package: no requirements
    - project: no requirements
    - data: no requirements

    ################################################################################
     organisation 5
    ................................................................................
    name
    - nl-BE: Vlaamse Landmaatschappij (VLM)
    email: info@vlm.be
    website: https://www.vlm.be/
    logo: https://www.vlm.be/nl/SiteCollectionImages/Logo/Logo's%20Vlaamse%20overheid%20en%20VLM/Sponsorlogo_VLM_kleur.jpg
    copyright holder: optional
    funder: optional
    publisher: optional
    allowed licenses:
    - package: no requirements
    - project: no requirements
    - data: no requirements

    ################################################################################
     organisation 6
    ................................................................................
    name
    - nl-BE: Vlaamse Milieumaatschappij (VMM)
    - en-GB: Flanders Environment Agency (VMM)
    email: info@vmm.be
    website: https://en.vmm.vlaanderen.be/
    logo: https://2016.vmm.be/assets/images/logo.svg
    copyright holder: optional
    funder: optional
    publisher: optional
    allowed licenses:
    - package: no requirements
    - project: no requirements
    - data: no requirements

    ################################################################################
     organisation 7
    ................................................................................
    name
    - nl-BE: De Vlaamse Waterweg nv
    email: info@vlaamsewaterweg.be
    website: https://www.vlaamsewaterweg.be/
    copyright holder: optional
    funder: optional
    publisher: optional
    allowed licenses:
    - package: no requirements
    - project: no requirements
    - data: no requirements

    ################################################################################
    git organisation: https://github.com/inbo
    ################################################################################

## FAQ

**Can I use `citeme` without git?**

Yes. Without git, `citeme` only checks rules defined in a local
`organisation.yml` file.

**Is a `citeme` repository at the organisation level required?**

No. Without an organisation-level repository, no organisation-wide rules
are enforced.

**Do I need to add an `organisation.yml` file to my project?**

No, unless you want to add project-specific rules. Any project-level
rules must still comply with the organisation-level rules.
