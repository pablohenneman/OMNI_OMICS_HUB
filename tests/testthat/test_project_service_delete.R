testthat::test_that("delete_project removes project folder and registry entries on success", {
  create_project <- OmniOmicsHub:::create_project
  delete_project <- OmniOmicsHub:::delete_project
  set_recent_projects <- OmniOmicsHub:::set_recent_projects
  get_recent_projects <- OmniOmicsHub:::get_recent_projects
  reset_recent_projects <- OmniOmicsHub:::reset_recent_projects
  get_active_project <- OmniOmicsHub:::get_active_project
  get_active_project <- OmniOmicsHub:::get_active_project
  reset_active_project <- OmniOmicsHub:::reset_active_project

  base_dir <- file.path(tempdir(), "delete-project-success")
  if (dir.exists(base_dir)) {
    unlink(base_dir, recursive = TRUE, force = TRUE)
  }
  dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit({
    if (dir.exists(base_dir)) {
      unlink(base_dir, recursive = TRUE, force = TRUE)
    }
    reset_recent_projects()
  }, add = TRUE)

  reset_active_project()
  reset_recent_projects()

  project <- create_project("Delete Me", base_dir)
  project_root <- project@project_root

  set_recent_projects(list(
    list(
      project_root = project_root,
      project_name = project@project_name,
      project_id = project@project_id
    )
  ))

  delete_project(project_root)

  testthat::expect_false(dir.exists(project_root))
  testthat::expect_length(get_recent_projects(), 0)
  testthat::expect_null(get_active_project())
})

testthat::test_that("delete_project leaves registry intact when deletion fails", {
  create_project <- OmniOmicsHub:::create_project
  delete_project <- OmniOmicsHub:::delete_project
  set_recent_projects <- OmniOmicsHub:::set_recent_projects
  get_recent_projects <- OmniOmicsHub:::get_recent_projects
  reset_recent_projects <- OmniOmicsHub:::reset_recent_projects

  base_dir <- file.path(tempdir(), "delete-project-failure")
  if (dir.exists(base_dir)) {
    unlink(base_dir, recursive = TRUE, force = TRUE)
  }
  dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit({
    if (dir.exists(base_dir)) {
      unlink(base_dir, recursive = TRUE, force = TRUE)
    }
    reset_recent_projects()
  }, add = TRUE)

  reset_recent_projects()

  project <- create_project("Delete Failure", base_dir)
  project_root <- project@project_root

  set_recent_projects(list(
    list(
      project_root = project_root,
      project_name = project@project_name,
      project_id = project@project_id
    )
  ))

  delete_stub <- function(path, recursive = TRUE, force = FALSE) {
    FALSE
  }

  testthat::expect_error(
    delete_project(project_root, delete_fn = delete_stub),
    "Failed to delete project folder",
    fixed = TRUE
  )
  testthat::expect_true(dir.exists(project_root))
  testthat::expect_length(get_recent_projects(), 1)
  testthat::expect_s4_class(get_active_project(), "OmicsProject")
})

testthat::test_that("delete_project blocks missing manifest and preserves registry", {
  delete_project <- OmniOmicsHub:::delete_project
  set_recent_projects <- OmniOmicsHub:::set_recent_projects
  get_recent_projects <- OmniOmicsHub:::get_recent_projects
  reset_recent_projects <- OmniOmicsHub:::reset_recent_projects

  base_dir <- file.path(tempdir(), "delete-project-missing-manifest")
  if (dir.exists(base_dir)) {
    unlink(base_dir, recursive = TRUE, force = TRUE)
  }
  dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
  on.exit({
    if (dir.exists(base_dir)) {
      unlink(base_dir, recursive = TRUE, force = TRUE)
    }
    reset_recent_projects()
  }, add = TRUE)

  reset_recent_projects()

  project_root <- file.path(base_dir, "Missing Manifest")
  dir.create(project_root, recursive = TRUE, showWarnings = FALSE)

  set_recent_projects(list(
    list(
      project_root = project_root,
      project_name = "Missing Manifest",
      project_id = "proj_missing"
    )
  ))

  testthat::expect_error(
    delete_project(project_root),
    "Project manifest not found",
    fixed = TRUE
  )
  testthat::expect_true(dir.exists(project_root))
  testthat::expect_length(get_recent_projects(), 1)
})
