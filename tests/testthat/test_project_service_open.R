testthat::test_that("open_project loads manifest metadata and workspace registry", {
  create_project <- OmniOmicsHub:::create_project
  open_project <- OmniOmicsHub:::open_project
  read_project_manifest <- OmniOmicsHub:::read_project_manifest
  reset_active_project <- OmniOmicsHub:::reset_active_project

  base_dir <- file.path(tempdir(), "open-project")
  dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)

  created_project <- create_project("Open Project", base_dir)
  project_root <- created_project@project_root

  reset_active_project()

  opened_project <- open_project(project_root)
  testthat::expect_s4_class(opened_project, "OmicsProject")

  manifest <- read_project_manifest(project_root)
  testthat::expect_identical(opened_project@project_name, manifest$project_name)
  testthat::expect_identical(opened_project@project_id, manifest$project_id)
  testthat::expect_identical(opened_project@schema_version, manifest$schema_version)
  testthat::expect_true(is.list(opened_project@workspace_registry))
})

testthat::test_that("open_project blocks missing or invalid manifests", {
  open_project <- OmniOmicsHub:::open_project
  project_manifest_path <- OmniOmicsHub:::project_manifest_path
  project_manifest_schema_version <- OmniOmicsHub:::project_manifest_schema_version

  base_dir <- file.path(tempdir(), "open-project-invalid")
  dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)

  missing_root <- file.path(base_dir, "missing-manifest")
  dir.create(missing_root, recursive = TRUE, showWarnings = FALSE)

  testthat::expect_error(
    open_project(missing_root),
    "Project manifest not found",
    fixed = TRUE
  )

  invalid_root <- file.path(base_dir, "invalid-manifest")
  dir.create(invalid_root, recursive = TRUE, showWarnings = FALSE)
  invalid_manifest <- list(
    project_name = "Invalid",
    project_id = "proj_invalid",
    schema_version = paste0(project_manifest_schema_version(), "-bad"),
    created_at = as.POSIXct("2025-03-01 00:00:00", tz = "UTC"),
    workspace_registry = list()
  )
  saveRDS(invalid_manifest, project_manifest_path(invalid_root))

  testthat::expect_error(
    open_project(invalid_root),
    "Unsupported project manifest schema_version",
    fixed = TRUE
  )
})
