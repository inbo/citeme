# Changelog

## citeme 0.1.4

- Add
  [`ask_keywords()`](https://inbo.github.io/citeme/reference/ask_keywords.md)
  function for interactive keyword input.
- Handle non-existing configuration directory
  ([\#15](https://github.com/inbo/citeme/issues/15) by
  [@damianoodolni](https://github.com/damianoodolni)).
- Make sure to use `true` and `false` when writing logical values to
  YAML.

## citeme 0.1.3

- Handle `README` without language badge.

## citeme 0.1.2

- [`ask_language()`](https://inbo.github.io/citeme/reference/ask_language.md)
  now requires a vector of languages instead of an `org_list`.
- [`individual2badge()`](https://inbo.github.io/citeme/reference/individual2badge.md)
  now supports the `"pbl"` role for publishers.
- `citation_meta` handles publishers in `README.md`.
- Improve rule handling by `org_list`.

## citeme 0.1.1

- Add `publisher` field to `org_item` class with role `"pbl"`
  ([\#6](https://github.com/inbo/citeme/issues/6)). Similar to `funder`,
  this allows organisations to specify publisher requirements.
- Add `which_publisher` and `get_default_publisher` active bindings to
  `org_list`.
- Update `validate_rules()` to validate publisher requirements.
- Update `citation_description.R` to include publisher in community
  detection.
- Update `yaml_individual()` to handle publisher entries from YAML
  metadata.

## citeme 0.1.0

- Migrate the `citation_meta` class from `checklist`.
- Export a set of interactive input functions:
  [`ask_email()`](https://inbo.github.io/citeme/reference/ask_email.md),
  [`ask_language()`](https://inbo.github.io/citeme/reference/ask_language.md),
  [`ask_new_license()`](https://inbo.github.io/citeme/reference/ask_new_license.md),
  [`ask_orcid()`](https://inbo.github.io/citeme/reference/ask_orcid.md),
  [`ask_ror()`](https://inbo.github.io/citeme/reference/ask_ror.md),
  [`ask_url()`](https://inbo.github.io/citeme/reference/ask_url.md),
  [`ask_yes_no()`](https://inbo.github.io/citeme/reference/ask_yes_no.md),
  [`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md),
  [`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md),
  [`select_license()`](https://inbo.github.io/citeme/reference/select_license.md).
- Export a set of validation functions:
  [`validate_citation()`](https://inbo.github.io/citeme/reference/validate_citation.md),
  [`validate_language()`](https://inbo.github.io/citeme/reference/validate_language.md),
  `validate_license()`,
  [`validate_orcid()`](https://inbo.github.io/citeme/reference/validate_orcid.md),
  [`validate_ror()`](https://inbo.github.io/citeme/reference/validate_ror.md),
  [`validate_url()`](https://inbo.github.io/citeme/reference/validate_url.md).
- Export organisation related functions:
  [`cache_org()`](https://inbo.github.io/citeme/reference/cache_org.md),
  [`get_available_organisations()`](https://inbo.github.io/citeme/reference/get_available_organisations.md)
- Export utility functions
  [`coalesce()`](https://inbo.github.io/citeme/reference/coalesce.md),
  [`is_tracked_not_modified()`](https://inbo.github.io/citeme/reference/is_tracked_not_modified.md),
  [`ssh_http()`](https://inbo.github.io/citeme/reference/ssh_http.md),
  [`org_list_from_url()`](https://inbo.github.io/citeme/reference/org_list_from_url.md).
- Rename `*author` and `author*` functions to `*individual` and
  `individual*` functions.
- Add Markdown version of licenses.
- Add [`checklist`](https://inbo.github.io/checklist/) machinery.
- Add draft of AI agent instructions.
- Remove the dependencies on the `fs` and `sessioninfo` packages.

## citeme 0.0.1

- Initial release
- Extracted person and organisation management functionality from
  [`checklist`](https://inbo.github.io/checklist/) package.
- Core R6 classes: `org_item` and `org_list`
- Author management functions: `use_author()`, `store_authors()`,
  `author2df()`
- Validation functions:
  [`validate_email()`](https://inbo.github.io/citeme/reference/validate_email.md),
  [`validate_orcid()`](https://inbo.github.io/citeme/reference/validate_orcid.md)
- Support for multiple languages, ORCID/ROR identifiers, and licensing
  requirements.
