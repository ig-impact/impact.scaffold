cli_impact <- cli::style_bold("IMPACT")
default_core_packages <- c(
  "impact-initiatives/cleaningtools",
  "fs"
)

impact_renv_init <- function(
    project_path,
    core_packages = default_core_packages) {
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

impact_scaffold_project <- function(
    project_path = ".",
    use_rstudio = TRUE,
    use_git = TRUE,
    use_targets = TRUE,
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

  # TODO: handle core packages
  impact_renv_init(project_path = project_path_abs)
}
