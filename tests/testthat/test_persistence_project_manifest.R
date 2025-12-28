testthat::test_that("project manifest schema fields and versioning are enforced", {
  project_manifest_schema_version <- OmniOmicsHub:::project_manifest_schema_version
  new_project_manifest <- OmniOmicsHub:::new_project_manifest
  validate_project_manifest <- OmniOmicsHub:::validate_project_manifest

  manifest <- new_project_manifest(
    project_name = "Test Project",
    project_id = "proj_123",
    created_at = as.POSIXct("2025-01-01 00:00:00", tz = "UTC"),
    workspace_registry = list()
  )

  testthat::expect_true(is.list(manifest))
  testthat::expect_true(all(c(
    "project_name",
    "project_id",
    "schema_version",
    "created_at",
    "workspace_registry"
  ) %in% names(manifest)))
  testthat::expect_identical(manifest$schema_version, project_manifest_schema_version())
  testthat::expect_true(inherits(manifest$created_at, "POSIXct"))
  testthat::expect_true(is.list(manifest$workspace_registry))

  testthat::expect_true(validate_project_manifest(manifest))

  missing_field <- manifest
  missing_field$project_name <- NULL
  testthat::expect_error(
    validate_project_manifest(missing_field),
    "missing required field",
    fixed = TRUE
  )

  bad_version <- manifest
  bad_version$schema_version <- "0.0.0"
  testthat::expect_error(
    validate_project_manifest(bad_version),
    "Unsupported project manifest schema_version",
    fixed = TRUE
  )
})

testthat::test_that("project manifest read/write uses validation and atomic replace", {
  new_project_manifest <- OmniOmicsHub:::new_project_manifest
  write_project_manifest <- OmniOmicsHub:::write_project_manifest
  read_project_manifest <- OmniOmicsHub:::read_project_manifest
  project_manifest_path <- OmniOmicsHub:::project_manifest_path

  project_root <- file.path(tempdir(), "project-manifest-read-write")
  dir.create(project_root, recursive = TRUE, showWarnings = FALSE)
  on.exit({
    if (dir.exists(project_root)) {
      unlink(project_root, recursive = TRUE, force = TRUE)
    }
  }, add = TRUE)

  manifest <- new_project_manifest(
    project_name = "Read Write Project",
    project_id = "proj_rw_001",
    created_at = as.POSIXct("2025-02-01 12:00:00", tz = "UTC"),
    workspace_registry = list()
  )

  manifest_path <- write_project_manifest(project_root, manifest)
  testthat::expect_true(file.exists(manifest_path))
  testthat::expect_identical(manifest_path, project_manifest_path(project_root))

  loaded_manifest <- read_project_manifest(project_root)
  testthat::expect_identical(loaded_manifest$project_name, manifest$project_name)
  testthat::expect_identical(loaded_manifest$project_id, manifest$project_id)
  testthat::expect_identical(loaded_manifest$schema_version, manifest$schema_version)
  testthat::expect_true(inherits(loaded_manifest$created_at, "POSIXct"))

  updated_manifest <- manifest
  updated_manifest$project_name <- "Read Write Project Updated"
  updated_manifest_path <- write_project_manifest(project_root, updated_manifest)
  testthat::expect_identical(updated_manifest_path, manifest_path)
  updated_loaded <- read_project_manifest(project_root)
  testthat::expect_identical(updated_loaded$project_name, updated_manifest$project_name)

  invalid_manifest_path <- project_manifest_path(project_root)
  saveRDS(list(schema_version = manifest$schema_version), invalid_manifest_path)
  testthat::expect_error(
    read_project_manifest(project_root),
    "missing required field",
    fixed = TRUE
  )
})

testthat::test_that("path resolver derives project root and manifest paths", {
  resolve_project_root <- OmniOmicsHub:::resolve_project_root
  project_manifest_path <- OmniOmicsHub:::project_manifest_path
  project_manifest_temp_path <- OmniOmicsHub:::project_manifest_temp_path

  base_dir <- normalizePath(tempdir(), winslash = "/", mustWork = FALSE)
  project_root <- resolve_project_root(base_dir, "omics-project")
  expected_root <- normalizePath(file.path(base_dir, "omics-project"), winslash = "/", mustWork = FALSE)

  testthat::expect_identical(project_root, expected_root)

  expected_manifest <- file.path(project_root, "project_manifest.rds")
  testthat::expect_identical(project_manifest_path(project_root), expected_manifest)

  dir.create(project_root, recursive = TRUE, showWarnings = FALSE)
  temp_path <- project_manifest_temp_path(project_root)
  testthat::expect_identical(dirname(temp_path), project_root)

  testthat::expect_error(
    resolve_project_root(base_dir, "../escape"),
    "Project name must not contain path separators",
    fixed = TRUE
  )
  testthat::expect_error(
    resolve_project_root(base_dir, "nested/path"),
    "Project name must not contain path separators",
    fixed = TRUE
  )
  testthat::expect_error(
    resolve_project_root(base_dir, "nested\\path"),
    "Project name must not contain path separators",
    fixed = TRUE
  )
})
