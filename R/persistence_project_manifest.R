PROJECT_MANIFEST_SCHEMA_VERSION <- "1.0.0"

project_manifest_schema_version <- function() {
  PROJECT_MANIFEST_SCHEMA_VERSION
}

new_project_manifest <- function(project_name,
                                 project_id,
                                 created_at = Sys.time(),
                                 workspace_registry = list()) {
  manifest <- list(
    project_name = project_name,
    project_id = project_id,
    schema_version = project_manifest_schema_version(),
    created_at = created_at,
    workspace_registry = workspace_registry
  )

  validate_project_manifest(manifest)
  manifest
}

validate_project_manifest <- function(manifest) {
  if (!is.list(manifest)) {
    stop("Project manifest must be a list.", call. = FALSE)
  }

  required_fields <- c(
    "project_name",
    "project_id",
    "schema_version",
    "created_at",
    "workspace_registry"
  )

  missing_fields <- required_fields[!required_fields %in% names(manifest)]
  if (length(missing_fields) > 0) {
    stop(
      paste0(
        "Project manifest missing required field: ",
        paste(missing_fields, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  if (!is.character(manifest$project_name) || length(manifest$project_name) != 1 || manifest$project_name == "") {
    stop("Project manifest field 'project_name' must be a non-empty string.", call. = FALSE)
  }

  if (!is.character(manifest$project_id) || length(manifest$project_id) != 1 || manifest$project_id == "") {
    stop("Project manifest field 'project_id' must be a non-empty string.", call. = FALSE)
  }

  if (!is.character(manifest$schema_version) || length(manifest$schema_version) != 1) {
    stop("Project manifest field 'schema_version' must be a string.", call. = FALSE)
  }

  if (manifest$schema_version != project_manifest_schema_version()) {
    stop(
      paste0(
        "Unsupported project manifest schema_version: ",
        manifest$schema_version,
        ". Expected ",
        project_manifest_schema_version(),
        "."
      ),
      call. = FALSE
    )
  }

  if (!inherits(manifest$created_at, "POSIXct")) {
    stop("Project manifest field 'created_at' must be POSIXct.", call. = FALSE)
  }

  if (!is.list(manifest$workspace_registry)) {
    stop("Project manifest field 'workspace_registry' must be a list.", call. = FALSE)
  }

  TRUE
}

write_project_manifest <- function(project_root, manifest) {
  if (!dir.exists(project_root)) {
    stop("Project root does not exist; cannot write manifest.", call. = FALSE)
  }

  validate_project_manifest(manifest)

  manifest_path <- project_manifest_path(project_root)
  temp_path <- project_manifest_temp_path(project_root)
  backup_path <- paste0(manifest_path, ".bak")

  on.exit({
    if (file.exists(temp_path)) {
      unlink(temp_path)
    }
  }, add = TRUE)

  saveRDS(manifest, temp_path)

  if (file.exists(manifest_path)) {
    if (file.exists(backup_path)) {
      unlink(backup_path)
    }
    if (!file.rename(manifest_path, backup_path)) {
      stop("Failed to prepare existing project manifest for replace.", call. = FALSE)
    }
  }

  if (!file.rename(temp_path, manifest_path)) {
    if (file.exists(backup_path)) {
      file.rename(backup_path, manifest_path)
    }
    stop("Failed to write project manifest atomically.", call. = FALSE)
  }

  if (file.exists(backup_path)) {
    unlink(backup_path)
  }

  manifest_path
}

read_project_manifest <- function(project_root) {
  manifest_path <- project_manifest_path(project_root)
  if (!file.exists(manifest_path)) {
    stop(
      paste0("Project manifest not found at: ", manifest_path, "."),
      call. = FALSE
    )
  }

  manifest <- tryCatch(
    readRDS(manifest_path),
    error = function(err) {
      stop(
        paste0("Failed to read project manifest: ", err$message),
        call. = FALSE
      )
    }
  )

  validate_project_manifest(manifest)
  manifest
}
