resolve_project_root <- function(project_location, project_name) {
  if (!is.character(project_location) || length(project_location) != 1 || project_location == "") {
    stop("Project location must be a non-empty string.", call. = FALSE)
  }

  if (!is.character(project_name) || length(project_name) != 1 || project_name == "") {
    stop("Project name must be a non-empty string.", call. = FALSE)
  }

  normalizePath(file.path(project_location, project_name), winslash = "/", mustWork = FALSE)
}

normalize_project_root <- function(project_root) {
  if (!is.character(project_root) || length(project_root) != 1 || project_root == "") {
    stop("Project root must be a non-empty string.", call. = FALSE)
  }

  normalizePath(project_root, winslash = "/", mustWork = FALSE)
}

project_manifest_path <- function(project_root) {
  project_root <- normalize_project_root(project_root)
  file.path(project_root, "project_manifest.rds")
}

project_manifest_temp_path <- function(project_root) {
  project_root <- normalize_project_root(project_root)
  if (!dir.exists(project_root)) {
    stop("Project root does not exist; cannot write manifest.", call. = FALSE)
  }

  tempfile("project_manifest_", tmpdir = project_root, fileext = ".tmp")
}
