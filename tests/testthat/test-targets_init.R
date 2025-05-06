test_that("targets initalization works correctly", {
  # NOTE: this test is redundant with regards to the renv initialization
  withr::with_tempdir({
    usethis::ui_silence(
      usethis::create_project(".", FALSE, FALSE)
    )
    httptest2::with_mock_api({
      impact_scaffold_project(
        project_path = ".",
        core_packages = c("targets"),
        use_targets = TRUE
      )
    })
    installed_packages <- names(renv::lockfile_read(project = ".")$Packages)
    expect_true("targets" %in% installed_packages)
    expect_true(fs::file_exists("_targets.R"))
    expect_no_error(targets::tar_manifest())
  })
})
