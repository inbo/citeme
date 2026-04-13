# add badges to a README

- `doi`: add a DOI badge

- `language`: add a language badge

- `license`: add a license badge

- `url`: add a website badge

- `version`: add a version badge

## Usage

``` r
add_badges(readme_path = ".", ...)
```

## Arguments

- readme_path:

  Directory containing the `README.md` or `README.Rmd` file.

- ...:

  Additional arguments

## See also

Other utils:
[`coalesce()`](https://inbo.github.io/citeme/reference/coalesce.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  add_badges(url = "https://www.inbo.be")
  add_badges(doi = "10.5281/zenodo.8063503")
  add_badges(version = "v0.1.2")
  add_badges(url = "https://www.inbo.be", doi = "10.5281/zenodo.8063503")
} # }
```
