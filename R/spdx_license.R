#' @importFrom tools analyze_license
spdx_license <- function(license) {
  spdx_license <- analyze_license(license)
  if (
    package_version(paste(version$major, version$minor, sep = ".")) <
      package_version("4.6.0")
  ) {
    return(
      list(
        license = spdx_license$components,
        notes = "Checking SPDX license is only available from R 4.6.0"
      )
    )
  }
  if (spdx_license$spdx != "") {
    return(list(license = spdx_license$spdx, notes = character(0)))
  }
  return(
    list(
      license = spdx_license$components,
      notes = paste(
        "The license in YAML has no valid SPDX identifier.",
        "Please check https://spdx.org/licenses/ for valid identifiers.",
        sep = "\n"
      )
    )
  )
}
