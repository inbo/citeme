# Determine if a directory is in a git repository

The path arguments specifies the directory at which to start the search
for a git repository. If it is not a git repository itself, then its
parent directory is consulted, then the parent's parent, and so on.

## Usage

``` r
is_repository(path = ".")
```

## Arguments

- path:

  the location of the git repository, see details.

## Value

TRUE if directory is in a git repository else FALSE

## See also

Other git:
[`is_tracked_not_modified()`](https://inbo.github.io/citeme/reference/is_tracked_not_modified.md),
[`ssh_http()`](https://inbo.github.io/citeme/reference/ssh_http.md)
