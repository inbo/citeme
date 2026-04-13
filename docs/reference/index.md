# Package index

## R6 classes

- [`citation_meta`](https://inbo.github.io/citeme/reference/citation_meta.md)
  :

  The `citation_meta` R6 class

- [`org_item`](https://inbo.github.io/citeme/reference/org_item.md) :

  The `org_item` R6 class

- [`org_list`](https://inbo.github.io/citeme/reference/org_list.md) :

  The `org_list` R6 class

## Helper functions for individuals

- [`add_individual()`](https://inbo.github.io/citeme/reference/add_individual.md)
  : Add an individual to a file

- [`individual2badge()`](https://inbo.github.io/citeme/reference/individual2badge.md)
  : Create a markdown badge for an individual

- [`individual2df()`](https://inbo.github.io/citeme/reference/individual2df.md)
  : Convert person object in a data.frame.

- [`individual2person()`](https://inbo.github.io/citeme/reference/individual2person.md)
  :

  Select the individual information to use as a `person` object

- [`select_individual()`](https://inbo.github.io/citeme/reference/select_individual.md)
  : Select an individual from the local database or add a new
  individual.

- [`store_individuals()`](https://inbo.github.io/citeme/reference/store_individuals.md)
  : Store individual details for later usage

## Helper functions for organisations

- [`cache_org()`](https://inbo.github.io/citeme/reference/cache_org.md)
  : Cache organisation list from URL

- [`get_available_organisations()`](https://inbo.github.io/citeme/reference/get_available_organisations.md)
  : Get the list of available organisations

- [`get_default_org_list()`](https://inbo.github.io/citeme/reference/get_default_org_list.md)
  : Get the default organization list

- [`inbo_org_list()`](https://inbo.github.io/citeme/reference/inbo_org_list.md)
  : The INBO organisation list

- [`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md)
  :

  Interactively create a new `org_item`

- [`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md)
  : Interactively create a new organisation list

- [`org_list_from_url()`](https://inbo.github.io/citeme/reference/org_list_from_url.md)
  : Get the default organisation list from a git URL This function
  retrieves the default organisation list from a git URL. It checks if
  the organisation list is already cached in the user's R configuration.
  If it is, it returns the cached version. If not, it attempts to
  retrieve the organisation list from the specified git URL and caches
  it for future use.

- [`select_license()`](https://inbo.github.io/citeme/reference/select_license.md)
  : Select a license for a project, package or dataset

## Interactively asking for input

- [`ask_email()`](https://inbo.github.io/citeme/reference/ask_email.md)
  : Ask for an e-mail address

- [`ask_language()`](https://inbo.github.io/citeme/reference/ask_language.md)
  : Ask for a language

- [`ask_new_license()`](https://inbo.github.io/citeme/reference/ask_new_license.md)
  : Ask one or more licenses.

- [`ask_orcid()`](https://inbo.github.io/citeme/reference/ask_orcid.md)
  :

  Ask for an `ORCID iD`

- [`ask_ror()`](https://inbo.github.io/citeme/reference/ask_ror.md) :
  Ask for an ROR

- [`ask_url()`](https://inbo.github.io/citeme/reference/ask_url.md) :
  Ask an URL

- [`ask_yes_no()`](https://inbo.github.io/citeme/reference/ask_yes_no.md)
  : Function to ask a simple yes no question

- [`menu_first()`](https://inbo.github.io/citeme/reference/menu_first.md)
  :

  Improved version of
  [`utils::menu()`](https://rdrr.io/r/utils/menu.html)

## Validating input

- [`validate_citation()`](https://inbo.github.io/citeme/reference/validate_citation.md)
  : Validate a citation metadata object

- [`validate_email()`](https://inbo.github.io/citeme/reference/validate_email.md)
  : Check if a vector contains valid email

- [`validate_language()`](https://inbo.github.io/citeme/reference/validate_language.md)
  : Validate language code

- [`validate_license()`](https://inbo.github.io/citeme/reference/validate_license.md)
  : Validate a license list

- [`validate_orcid()`](https://inbo.github.io/citeme/reference/validate_orcid.md)
  :

  Validate the structure of an `ORCID iD`

- [`validate_ror()`](https://inbo.github.io/citeme/reference/validate_ror.md)
  : Validate ROR

- [`validate_url()`](https://inbo.github.io/citeme/reference/validate_url.md)
  : Validate URL

## License utilities

- [`license_local_remote()`](https://inbo.github.io/citeme/reference/license_local_remote.md)
  : Create a data frame mapping local license file names to remote
  license URLs

## Git utilities

- [`is_repository()`](https://inbo.github.io/citeme/reference/is_repository.md)
  : Determine if a directory is in a git repository
- [`is_tracked_not_modified()`](https://inbo.github.io/citeme/reference/is_tracked_not_modified.md)
  : Check if a file is tracked and not modified
- [`ssh_http()`](https://inbo.github.io/citeme/reference/ssh_http.md) :
  Convert SSH URL to HTTP URL

## Utils

- [`add_badges()`](https://inbo.github.io/citeme/reference/add_badges.md)
  : add badges to a README
- [`coalesce()`](https://inbo.github.io/citeme/reference/coalesce.md) :
  coalesce
