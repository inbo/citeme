# Convert SSH URL to HTTP URL

This function converts a git SSH URL to an HTTP URL. It also removes any
`OAuth2` tokens from the URL. The resulting URL is used to determine the
root URL of the organisation for retrieving the organisation list.

## Usage

``` r
ssh_http(url)
```

## Arguments

- url:

  The git URL to convert.

## Value

The converted HTTP URL.

## See also

Other git:
[`is_repository()`](https://inbo.github.io/citeme/reference/is_repository.md),
[`is_tracked_not_modified()`](https://inbo.github.io/citeme/reference/is_tracked_not_modified.md)
