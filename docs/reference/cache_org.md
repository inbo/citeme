# Cache organisation list from URL

This function retrieves the organisation list from a given URL and
caches it locally. If the URL is `"https://github.com/inbo"`, it uses
the default INBO organisation list. For other URLs, it checks if a
public `citeme` repository exists and clones it to retrieve the
organisation list. The cached organisation list is stored in a specified
configuration folder.

## Usage

``` r
cache_org(url, config_folder = R_user_dir("citeme", "config"))
```

## Arguments

- url:

  The URL of the organisation list to retrieve.

- config_folder:

  The folder where the cached organisation list should be stored.
  Defaults to the user's R configuration directory for `citeme`.

## Value

The retrieved organisation list, or `NULL` if the URL is invalid or the
repository.

## See also

Other organisation:
[`get_available_organisations()`](https://inbo.github.io/citeme/reference/get_available_organisations.md),
[`get_default_org_list()`](https://inbo.github.io/citeme/reference/get_default_org_list.md),
[`inbo_org_list()`](https://inbo.github.io/citeme/reference/inbo_org_list.md),
[`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md),
[`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md),
[`org_list_from_url()`](https://inbo.github.io/citeme/reference/org_list_from_url.md),
[`select_license()`](https://inbo.github.io/citeme/reference/select_license.md)
