test_that("Installing packages works correctly", {
  withr::with_tempdir({
    usethis::ui_silence(
      usethis::create_project(".", FALSE, FALSE)
    )
    httptest2::with_mock_api({
      impact_renv_init(project_path = ".", core_packages = "fs")
    })
    expect_true(fs::file_exists("./renv.lock"))
  })
})
