# citeme 0.1.0

* Migrate the `citation_meta` class from `checklist`.
* Export a set of interactive input functions: `ask_email()`, `ask_language()`,
  `ask_new_license()`, `ask_orcid()`, `ask_ror()`, `ask_url()`, `ask_yes_no()`,
  `new_org_list()`, `new_org_item()`, `select_license()`.
* Export a set of validation functions: `validate_citation()`,
  `validate_language()`, `validate_license()`, `validate_orcid()`,
  `validate_ror()`, `validate_url()`.
* Export organisation related functions: `cache_org()`,
  `get_available_organisations()`
* Export utility functions `coalesce()`, `is_tracked_not_modified()`,
  `ssh_http()`,  `org_list_from_url()`.
* Rename `*author` and `author*` functions to `*individual` and `individual*`
  functions.
* Add Markdown version of licenses.
* Add [`checklist`](https://inbo.github.io/checklist/) machinery.
* Add draft of AI agent instructions.
* Remove the dependencies on the `fs` and `sessioninfo` packages.

# citeme 0.0.1

* Initial release
* Extracted person and organisation management functionality from
  [`checklist`](https://inbo.github.io/checklist/) package.
* Core R6 classes: `org_item` and `org_list`
* Author management functions: `use_author()`, `store_authors()`, `author2df()`
* Validation functions: `validate_email()`, `validate_orcid()`
* Support for multiple languages, ORCID/ROR identifiers, and licensing
  requirements.
