test_that("Installing packages works correctly", {
  withr::with_tempdir({
    usethis::ui_silence(
      usethis::create_project(".", FALSE, FALSE)
    )
    httptest2::with_mock_api({
      impact_renv_init(
        project_path = ".",
        core_packages = c("cli", "impact-initiatives/cleaningtools")
      )
    })
    expect_true(fs::file_exists("./renv.lock"))
    expect_true(fs::file_exists("renv/activate.R"))
    expect_true(fs::file_exists(".here"))
    installed_packages <- names(renv::lockfile_read(project = ".")$Packages)
    expect_true(all(c("cleaningtools", "cli") %in% installed_packages))
  })
})
