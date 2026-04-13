# Get the default organization list

This function retrieves the default organisation list from the
`organisation.yml` file in the organisations `citeme` repository. The
`origin` of the repository is used to determine the root URL of the
organisation.

## Usage

``` r
get_default_org_list(x = ".")
```

## Arguments

- x:

  The path to the repository. Defaults to the current working directory.

## Value

An `org_list` object containing the organisation list. The function also
stores the information in the user's R configuration.

## See also

Other organisation:
[`cache_org()`](https://inbo.github.io/citeme/reference/cache_org.md),
[`get_available_organisations()`](https://inbo.github.io/citeme/reference/get_available_organisations.md),
[`inbo_org_list()`](https://inbo.github.io/citeme/reference/inbo_org_list.md),
[`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md),
[`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md),
[`org_list_from_url()`](https://inbo.github.io/citeme/reference/org_list_from_url.md),
[`select_license()`](https://inbo.github.io/citeme/reference/select_license.md)
