# Changelog

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
  [`validate_license()`](https://inbo.github.io/citeme/reference/validate_license.md),
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
