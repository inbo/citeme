check_compatible_rules <- function(items) {
  vapply(
    items,
    FUN.VALUE = character(1),
    FUN = function(x) {
      x$get_rightsholder
    }
  ) |>
    compatible_rules()
  vapply(
    items,
    FUN.VALUE = character(1),
    FUN = function(x) {
      x$get_funder
    }
  ) |>
    compatible_rules()
  vapply(
    items,
    FUN.VALUE = character(1),
    FUN = function(x) {
      x$get_publisher
    }
  ) |>
    compatible_rules()
}
