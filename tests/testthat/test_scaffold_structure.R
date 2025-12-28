testthat::test_that("golem scaffold structure exists", {
  root_dir <- normalizePath(file.path("..", ".."), winslash = "/", mustWork = FALSE)

  testthat::expect_true(dir.exists(root_dir))
  testthat::expect_true(file.exists(file.path(root_dir, "DESCRIPTION")))
  testthat::expect_true(dir.exists(file.path(root_dir, "R")))
  testthat::expect_true(dir.exists(file.path(root_dir, "inst")))
  testthat::expect_true(dir.exists(file.path(root_dir, "tests")))

  desc_path <- file.path(root_dir, "DESCRIPTION")
  desc_lines <- readLines(desc_path, warn = FALSE)
  testthat::expect_true(any(grepl("^Package: OmniOmicsHub$", desc_lines)))

  required_dirs <- c(
    "inst/assets",
    "inst/assets/icons",
    "inst/assets/images",
    "inst/config"
  )

  for (dir_name in required_dirs) {
    testthat::expect_true(dir.exists(file.path(root_dir, dir_name)))
  }

  required_files <- c(
    "R/app_config.R",
    "R/app_server.R",
    "R/app_ui.R",
    "R/domain_omics_project.R",
    "R/persistence_path_resolver.R",
    "R/persistence_project_manifest.R",
    "R/state_app_session_state.R",
    "R/services_project_service.R",
    "R/mod_project_dashboard_ui.R",
    "R/mod_project_dashboard_server.R",
    "R/run_app.R"
  )

  for (file_name in required_files) {
    testthat::expect_true(file.exists(file.path(root_dir, file_name)))
  }
})
