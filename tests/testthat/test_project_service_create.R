testthat::test_that("create_project creates project folder, manifest, and active session state", {
  create_project <- OmniOmicsHub:::create_project
  read_project_manifest <- OmniOmicsHub:::read_project_manifest
  get_active_project <- OmniOmicsHub:::get_active_project
  reset_active_project <- OmniOmicsHub:::reset_active_project
  project_manifest_path <- OmniOmicsHub:::project_manifest_path

  reset_active_project()

  base_dir <- file.path(tempdir(), "create-project")
  if (dir.exists(base_dir)) {
    unlink(base_dir, recursive = TRUE, force = TRUE)
  }
  dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit({
    if (dir.exists(base_dir)) {
      unlink(base_dir, recursive = TRUE, force = TRUE)
    }
  }, add = TRUE)

  project <- create_project("My Project", base_dir)
  testthat::expect_s4_class(project, "OmicsProject")

  project_root <- project@project_root
  testthat::expect_true(dir.exists(project_root))
  testthat::expect_true(file.exists(project_manifest_path(project_root)))

  manifest <- read_project_manifest(project_root)
  testthat::expect_identical(manifest$project_name, "My Project")
  testthat::expect_true(is.list(manifest$workspace_registry))
  testthat::expect_length(manifest$workspace_registry, 0)

  active_project <- get_active_project()
  testthat::expect_s4_class(active_project, "OmicsProject")
  testthat::expect_identical(active_project@project_id, project@project_id)
})

testthat::test_that("create_project errors without leaving a partial manifest", {
  create_project <- OmniOmicsHub:::create_project
  project_manifest_path <- OmniOmicsHub:::project_manifest_path

  base_dir <- file.path(tempdir(), "create-project-existing")
  if (dir.exists(base_dir)) {
    unlink(base_dir, recursive = TRUE, force = TRUE)
  }
  dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit({
    if (dir.exists(base_dir)) {
      unlink(base_dir, recursive = TRUE, force = TRUE)
    }
  }, add = TRUE)
  project_root <- file.path(base_dir, "Existing Project")
  dir.create(project_root, recursive = TRUE, showWarnings = FALSE)

  testthat::expect_error(
    create_project("Existing Project", base_dir),
    "already exists",
    fixed = TRUE
  )
  testthat::expect_false(file.exists(project_manifest_path(project_root)))
})
