cli_impact <- cli::style_bold("IMPACT")
default_core_packages <- c(
  "impact-initiatives/cleaningtools",
  "targets",
  "tarchetypes",
  "visNetwork"
)

impact_renv_init <- function(
    project_path,
    core_packages) {
  cli::cli_progress_step("Initializing {.pkg renv}")
  renv::init(
    project = project_path,
    bare = TRUE,
    load = FALSE,
    restart = FALSE
  )


  cli::cli_progress_step("Installing core packages")
  withr::with_options(
    list(),
    {
      renv::install(
        core_packages,
        project = project_path,
        library = renv::paths$library(project = project_path),
        lock = TRUE, prompt = FALSE,
        verbose = FALSE
      )
    }
  )
}

#' Scaffold an IMPACT Project
#'
#' Initializes a new standardized project structure for analysis with {renv},
#' and optionally including setup for RStudio, Git, {targets} environment with
#' pre-defined core packages.
#'
#' @description
#' This function automates the setup of a new project directory. It creates the
#' directory (if it doesn't exist), initializes an RStudio project, a Git
#' repository, and a {targets} pipeline structure based on the arguments
#' provided.
#' It also initializes an {renv} environment and installs a specified set of
#' core R packages, creating an `renv.lock` file.
#'
#' @param project_path A character string. The path to the directory where the
#'   project will be created. Defaults to the current working directory (`"."`).
#'   If the directory does not exist, it will be created.
#' @param use_rstudio Logical. If `TRUE` (the default), an RStudio Project
#'   (`.Rproj` file) will be created.
#' @param use_git Logical. If `TRUE` (the default), a Git repository will be
#'   initialized in the project directory (e.g., using `usethis::use_git()`).
#' @param use_targets Logical. If `TRUE` (the default), a basic {targets}
#'   pipeline will be set up (e.g., by creating `_targets.R` using
#'   `targets::use_targets()`).
#' @param core_packages A character vector of R packages to install into the
#'   project's {renv} library and include in `renv.lock`. This can include
#'   packages from CRAN, Bioconductor, or GitHub (e.g.,
#'   `"username/repo"`). Defaults to `default_core_packages` which includes
#'   packages like `"impact-initiatives/cleaningtools"`, `"targets"`,
#'   `"tarchetypes"`, and `"visNetwork"`.
#' @param ... Additional arguments, potentially to be passed to underlying
#'   functions like `renv::install` (via `impact_renv_init`). (Currently not
#'   fully implemented for passthrough).
#'
#' @return The `project_path` (invisibly), which is the absolute path to the
#'   newly created project.
#'
#' @examples
#' \dontrun{
# Create a new project in a directory named "my_new_analysis"
# with all default settings (RStudio, Git, targets, renv with default
# packages)
#' impact_scaffold_project("my_new_analysis")
#'
#' # Create a project in the current directory, but without Git integration
#' # and with a custom set of core packages
#' impact_scaffold_project(
#'   project_path = ".",
#'   use_git = FALSE,
#'   core_packages = c("dplyr", "ggplot2", "mycustomtool@v1.0")
#' )
#'
#' # Create a project without targets setup
#' impact_scaffold_project("project_without_targets", use_targets = FALSE)
#' }
#' @export
impact_scaffold_project <- function(
    project_path = ".",
    use_rstudio = TRUE,
    use_git = TRUE,
    use_targets = TRUE,
    core_packages = default_core_packages,
    ...) {
  project_path_abs <- fs::path_abs(project_path) # nolint
  cli::cli_progress_step(
    "Creating an {cli_impact} project at {.path { project_path_abs }}"
  )
  usethis::ui_silence(
    usethis::create_project(
      path = project_path_abs,
      rstudio = use_rstudio,
      open = FALSE
    )
  )

  impact_renv_init(
    project_path = project_path_abs,
    core_packages = core_packages
  )

  if (use_targets) {
    cli::cli_progress_step(
      "Initializing {.pkg targets} with {.code targets::use_targets()}"
    )
    withr::with_dir(project_path_abs, {
      targets::use_targets(open = FALSE, overwrite = FALSE)
    })
  }
}
