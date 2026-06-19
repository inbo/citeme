#' @title The `citation_meta` R6 class
#' @description A class which contains citation information.
#' @export
#' @importFrom R6 R6Class
#' @importFrom utils file_test
#' @family class
citation_meta <- R6Class(
  "citation_meta",

  public = list(
    #' @description Initialize a new `citation_meta` object.
    #' @param path The path to the root of the project or the file from which to
    #' extract citation metadata.
    #' @importFrom assertthat assert_that is.flag is.string noNA
    initialize = function(path = ".") {
      assert_that(is.string(path), noNA(path))
      normalizePath(path, winslash = "/", mustWork = TRUE) |>
        determine_type() -> private$path
      if (length(private$path) == 0) {
        private$path <- normalizePath(path, winslash = "/", mustWork = FALSE)
        private$errors <- "no supported file found in `path`"
        return(invisible(self))
      }
      switch(
        names(private$path),
        quarto = {
          if (basename(private$path) == "index.Rmd") {
            private$type <- "bookdown"
            meta <- citation_bookdown(self)
          } else {
            private$type <- "quarto"
            meta <- citation_quarto(self)
          }
        },
        description = {
          private$type <- "package"
          meta <- citation_description(self)
        },
        readme = {
          private$type <- "project"
          meta <- citation_readme(
            self,
            org = org_list$new()$read(dirname(private$path))
          )
        },
        stop("`path` type is not supported")
      )
      if (is.null(meta$person)) {
        private$person <- person()
      } else {
        private$person <- meta$person
      }
      private$meta <- meta$meta
      private$errors <- meta$errors
      private$notes <- meta$notes
      private$warnings <- meta$warnings
      if (length(private$errors) == 0) {
        private$errors <- c(private$errors, validate_citation(self))
      }
      if (length(private$errors) > 0) {
        warning(
          "Errors found parsing citation meta data. ",
          "Citation files not updated.",
          call. = FALSE,
          immediate. = TRUE,
          noBreaks. = TRUE
        )
        return(invisible(self))
      }
      private$errors <- c(
        private$errors,
        citation_r(self),
        citation_zenodo(self),
        citation_cff(self)
      )
      return(self)
    },

    #' @description Print the `citation_meta` object.
    #' @param ... currently ignored.
    print = function(...) {
      dots <- list(...)
      if (!is.null(dots$quiet) && dots$quiet) {
        return(invisible(NULL))
      }
      citation_print(
        errors = private$errors,
        meta = private$meta,
        notes = private$notes,
        path = private$path,
        person = private$person,
        warnings = private$warnings
      )
    }
  ),

  active = list(
    #' @field get_errors Return the errors
    get_errors = function() {
      return(private$errors)
    },

    #' @field get_meta Return the meta data as a list
    get_meta = function() {
      return(private$meta)
    },

    #' @field get_notes Return the notes
    get_notes = function() {
      return(private$notes)
    },

    #' @field get_person Return the individuals and organisations as a list of
    #' `person` objects.
    get_person = function() {
      private$person
    },

    #' @field get_type A string indicating the type of source.
    get_type = function() {
      return(private$type)
    },

    #' @field get_path The path to the project.
    get_path = function() {
      return(private$path)
    },

    #' @field get_warnings Return the warnings
    get_warnings = function() {
      return(private$warnings)
    }
  ),
  #' @importFrom utils person
  private = list(
    errors = character(0),
    notes = character(0),
    meta = list(),
    path = character(0),
    person = person(),
    type = character(0),
    warnings = list()
  )
)

citation_print <- function(errors, meta, notes, path, person, warnings) {
  cat(rules())
  cat("\ncitation meta data for", path, "\n")
  cat(rules())
  cat("\ntitle:", meta$title)
  cat("\ncontributors:\n")
  format(
    person,
    braces = list(
      given = c("- given: ", "\n"),
      family = c("  family: ", "\n"),
      email = c("  email: ", "\n"),
      comment = c("  comment: ", "\n"),
      role = c("  role: ", "\n")
    )
  ) |>
    cat()
  cat("\nversion:", as.character(meta$version))
  cat("\nlicense:", meta$license)
  cat("\nlanguage:", meta$language)
  cat("\nupload type:", meta$upload_type)
  cat("\nkeywords:", paste(meta$keywords, collapse = "; "))
  cat("\ncommunities:", paste(meta$community, collapse = "; "))
  cat("\ndoi:", meta$doi)
  cat("\nsource URL:", meta$source)
  cat("\nwebsite URL:", meta$url)
  cat("\ndescription:\n\n")
  cat(meta$description, sep = "\n")
  cat(rules())
  if (length(errors) > 0) {
    cat("\nErrors found while parsing citation meta data\n")
    cat(rules("-"))
    cat(errors, sep = "\n")
    cat(rules())
  }
  if (length(warnings) > 0) {
    cat("\nWarnings found while parsing citation meta data\n")
    cat(rules("-"))
    cat(warnings, sep = "\n")
    cat(rules())
  }
  if (length(notes) > 0) {
    cat("\nNotes found while parsing citation meta data\n")
    cat(rules("-"))
    cat(notes, sep = "\n")
    cat(rules())
  }
}
