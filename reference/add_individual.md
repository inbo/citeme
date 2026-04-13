# Add an individual to a file

Add an individual to a file

## Usage

``` r
add_individual(path = ".", role = c("aut", "rev", "cph", "fnd"))
```

## Arguments

- path:

  A path to a file or directory. The file must be a quarto file (e.g.
  `_quarto.yml` or `*.qmd`).

- role:

  The role of the person to add. One of `"aut"` (author), `"rev"`
  (reviewer), `"cph"` (copyright holder), or `"fnd"` (funder).

## See also

Other individual:
[`individual2badge()`](https://inbo.github.io/citeme/reference/individual2badge.md),
[`individual2df()`](https://inbo.github.io/citeme/reference/individual2df.md),
[`individual2person()`](https://inbo.github.io/citeme/reference/individual2person.md),
[`select_individual()`](https://inbo.github.io/citeme/reference/select_individual.md),
[`store_individuals()`](https://inbo.github.io/citeme/reference/store_individuals.md)
