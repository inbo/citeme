mock_r_user_dir <- function(alt_dir) {
  function(package, which = c("data", "config", "cache")) {
    which <- match.arg(which)
    return(file.path(alt_dir, which, fsep = "/"))
  }
}
config_dir <- tempfile("config_dir")
