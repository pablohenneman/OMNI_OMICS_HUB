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
    "R/domain",
    "R/state",
    "R/persistence",
    "R/provenance",
    "R/services",
    "R/modules",
    "R/utils",
    "R/modules/workspace_nav",
    "R/modules/workspace_stepper",
    "R/modules/project_dashboard",
    "R/modules/workspace_dashboard",
    "R/modules/configuration/step_00_properties",
    "R/modules/configuration/step_01_import",
    "R/modules/configuration/step_02_mapping",
    "R/modules/configuration/step_03_rowdata",
    "R/modules/configuration/step_04_coldata",
    "R/modules/preprocessing/step_01_filtering",
    "R/modules/preprocessing/step_02_normalization",
    "R/modules/preprocessing/step_03_imputation_scaling",
    "R/modules/preprocessing/step_04_variable_features_dr",
    "inst/assets",
    "inst/assets/icons",
    "inst/assets/images",
    "inst/config"
  )

  for (dir_name in required_dirs) {
    testthat::expect_true(dir.exists(file.path(root_dir, dir_name)))
  }
})
