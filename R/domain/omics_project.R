setClass(
  "OmicsProject",
  slots = c(
    project_name = "character",
    project_id = "character",
    schema_version = "character",
    created_at = "POSIXct",
    workspace_registry = "list",
    project_root = "character"
  )
)

omics_project <- function(project_name,
                          project_id,
                          schema_version,
                          created_at,
                          workspace_registry,
                          project_root) {
  if (!is.character(project_name) || length(project_name) != 1 || project_name == "") {
    stop("Project name must be a non-empty string.", call. = FALSE)
  }

  if (!is.character(project_id) || length(project_id) != 1 || project_id == "") {
    stop("Project id must be a non-empty string.", call. = FALSE)
  }

  if (!is.character(schema_version) || length(schema_version) != 1 || schema_version == "") {
    stop("Project schema version must be a non-empty string.", call. = FALSE)
  }

  if (!inherits(created_at, "POSIXct")) {
    stop("Project created_at must be POSIXct.", call. = FALSE)
  }

  if (!is.list(workspace_registry)) {
    stop("Workspace registry must be a list.", call. = FALSE)
  }

  project_root <- normalize_project_root(project_root)

  methods::new(
    "OmicsProject",
    project_name = project_name,
    project_id = project_id,
    schema_version = schema_version,
    created_at = created_at,
    workspace_registry = workspace_registry,
    project_root = project_root
  )
}

omics_project_from_manifest <- function(manifest, project_root) {
  validate_project_manifest(manifest)
  omics_project(
    project_name = manifest$project_name,
    project_id = manifest$project_id,
    schema_version = manifest$schema_version,
    created_at = manifest$created_at,
    workspace_registry = manifest$workspace_registry,
    project_root = project_root
  )
}

generate_project_id <- function() {
  timestamp <- format(Sys.time(), "%Y%m%d%H%M%S", tz = "UTC")
  suffix <- sprintf("%04d", sample.int(9999, 1))
  paste0("proj_", timestamp, "_", suffix)
}
