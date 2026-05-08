# Retrieve stored organisation information

This function retrieves organisation information that was previously
stored using
[`store_organisations()`](https://inbo.github.io/citeme/reference/store_organisations.md).

## Usage

``` r
stored_organisations()
```

## Value

A data.frame with the stored organisation information. The data.frame
contains the columns: `email`, `default_name`, `names`, `ror`, `orcid`,
`zenodo`, `website`, and `logo`. Returns an empty data.frame if no
organisations are stored.

## See also

Other organisation:
[`cache_org()`](https://inbo.github.io/citeme/reference/cache_org.md),
[`get_available_organisations()`](https://inbo.github.io/citeme/reference/get_available_organisations.md),
[`get_default_org_list()`](https://inbo.github.io/citeme/reference/get_default_org_list.md),
[`inbo_org_list()`](https://inbo.github.io/citeme/reference/inbo_org_list.md),
[`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md),
[`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md),
[`org_list_from_url()`](https://inbo.github.io/citeme/reference/org_list_from_url.md),
[`organisation2df()`](https://inbo.github.io/citeme/reference/organisation2df.md),
[`select_license()`](https://inbo.github.io/citeme/reference/select_license.md),
[`store_organisations()`](https://inbo.github.io/citeme/reference/store_organisations.md)
