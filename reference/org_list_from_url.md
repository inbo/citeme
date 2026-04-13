# Get the default organisation list from a git URL This function retrieves the default organisation list from a git URL. It checks if the organisation list is already cached in the user's R configuration. If it is, it returns the cached version. If not, it attempts to retrieve the organisation list from the specified git URL and caches it for future use.

Get the default organisation list from a git URL This function retrieves
the default organisation list from a git URL. It checks if the
organisation list is already cached in the user's R configuration. If it
is, it returns the cached version. If not, it attempts to retrieve the
organisation list from the specified git URL and caches it for future
use.

## Usage

``` r
org_list_from_url(git)
```

## Arguments

- git:

  The git URL to retrieve the organisation list from.

## Value

An `org_list` object containing the organisation list.

## See also

Other organisation:
[`cache_org()`](https://inbo.github.io/citeme/reference/cache_org.md),
[`get_available_organisations()`](https://inbo.github.io/citeme/reference/get_available_organisations.md),
[`get_default_org_list()`](https://inbo.github.io/citeme/reference/get_default_org_list.md),
[`inbo_org_list()`](https://inbo.github.io/citeme/reference/inbo_org_list.md),
[`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md),
[`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md),
[`select_license()`](https://inbo.github.io/citeme/reference/select_license.md)
