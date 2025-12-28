create_project <- function(project_name, project_location) {
  project_root <- resolve_project_root(project_location, project_name)

  if (dir.exists(project_root)) {
    stop(
      paste0("Project folder already exists at: ", project_root, "."),
      call. = FALSE
    )
  }

  dir.create(project_root, recursive = TRUE, showWarnings = FALSE)
  if (!dir.exists(project_root)) {
    stop(
      paste0("Failed to create project folder at: ", project_root, "."),
      call. = FALSE
    )
  }

  manifest <- new_project_manifest(
    project_name = project_name,
    project_id = generate_project_id(),
    created_at = as.POSIXct(Sys.time(), tz = "UTC"),
    workspace_registry = list()
  )

  manifest_path <- project_manifest_path(project_root)
  tryCatch(
    write_project_manifest(project_root, manifest),
    error = function(err) {
      if (file.exists(manifest_path)) {
        unlink(manifest_path)
      }
      if (dir.exists(project_root)) {
        unlink(project_root, recursive = TRUE, force = TRUE)
      }
      stop(
        paste0("Failed to create project manifest: ", err$message),
        call. = FALSE
      )
    }
  )

  project <- omics_project_from_manifest(manifest, project_root)
  set_active_project(project)
  project
}

open_project <- function(project_root) {
  project_root <- normalize_project_root(project_root)
  manifest <- read_project_manifest(project_root)
  project <- omics_project_from_manifest(manifest, project_root)
  set_active_project(project)
  project
}

delete_project <- function(project_root, delete_fn = unlink) {
  project_root <- normalize_project_root(project_root)

  if (!dir.exists(project_root)) {
    stop(
      paste0("Project folder not found at: ", project_root, "."),
      call. = FALSE
    )
  }

  read_project_manifest(project_root)

  delete_fn(project_root, recursive = TRUE, force = FALSE)
  if (dir.exists(project_root)) {
    stop(
      paste0(
        "Failed to delete project folder at: ",
        project_root,
        ". Ensure no files are open and you have permission."
      ),
      call. = FALSE
    )
  }

  remove_recent_project(project_root)

  active_project <- get_active_project()
  if (!is.null(active_project) && identical(active_project@project_root, project_root)) {
    reset_active_project()
  }

  invisible(TRUE)
}
