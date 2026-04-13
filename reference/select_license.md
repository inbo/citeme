# Select a license for a project, package or dataset

This function allows you to select a license for a project, package or
dataset from the list of allowed licenses for the organisation. If there
is only one license available, it will be selected automatically.

## Usage

``` r
select_license(org, type = c("package", "project", "data"))
```

## Arguments

- org:

  An object of class `org_list` created with
  [`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md)
  or `org_list$new()`.

- type:

  The type of license to select. One of `"package"`, `"project"`, or
  `"data"`. Default is `"package"`.

## Value

The name of the selected license.

## See also

Other organisation:
[`cache_org()`](https://inbo.github.io/citeme/reference/cache_org.md),
[`get_available_organisations()`](https://inbo.github.io/citeme/reference/get_available_organisations.md),
[`get_default_org_list()`](https://inbo.github.io/citeme/reference/get_default_org_list.md),
[`inbo_org_list()`](https://inbo.github.io/citeme/reference/inbo_org_list.md),
[`new_org_item()`](https://inbo.github.io/citeme/reference/new_org_item.md),
[`new_org_list()`](https://inbo.github.io/citeme/reference/new_org_list.md),
[`org_list_from_url()`](https://inbo.github.io/citeme/reference/org_list_from_url.md)
