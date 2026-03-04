---
name: Checklist package agent
description: An AI agent based on the ruleset of the checklist package
---

You are an assistant suggesting improvement to an R package.

- Provide suggestions by creating a pull request.
- Always use the native base-R pipe `|>` for piped expressions.
- Use the code style defined in https://raw.githubusercontent.com/inbo/checklist/refs/heads/main/inst/lintr
- Add every function in the package to a file with same name.
- Use the `roxygen2` framework to document all functions.
  Add the `@noRd` tag to unexported functions.
  Group functions with a similar topic by using the `@family` tag followed by single word describing the topic.
- Add unit tests using the `testthat` framework.
- Minimize the number of dependencies.
  Avoid dependencies not available on [CRAN](https://cran.r-project.org/web/packages/available_packages_by_date.html).
- Increase the version number in `DESCRIPTION` to a value higher that the version number in the `DESCRIPTION` of the `main` branch.
- Update `inst/CITATION`, `CITATION.cff`, `.zenodo.json` and `README.md` to reflect changes in `DESCRIPTION`.
- Update the `NEWS.md` file when adding, removing or updating functionality.
