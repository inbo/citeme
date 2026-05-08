# Convert organisation object to a data.frame

Results in a data.frame with the email, default name, ROR, ORCID
requirement, Zenodo community, website, and logo of the organisation.

## Usage

``` r
organisation2df(x)
```

## Arguments

- x:

  An `org_list` or `org_item` object.

## Value

A data.frame with the organisation information.

## See also

Other organisation:
[`cache_org()`](https://inbo.github.io/citeme/reference/cache_org.md),
[`get_available_organisations()`](https://inbo.github.io/citeme/reference/get_available_organisations.md),
[`get_default_org_list()`](https://inbo.github.io/citeme/reference/get_default_org_list.md),
[`inbo_org_list()`](https://inbo.github.io/citeme/reference/inbo_org_list.md),
[`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md),
[`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md),
[`org_list_from_url()`](https://inbo.github.io/citeme/reference/org_list_from_url.md),
[`select_license()`](https://inbo.github.io/citeme/reference/select_license.md),
[`store_organisations()`](https://inbo.github.io/citeme/reference/store_organisations.md),
[`stored_organisations()`](https://inbo.github.io/citeme/reference/stored_organisations.md)
