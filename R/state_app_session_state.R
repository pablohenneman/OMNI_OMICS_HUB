.app_session_state <- new.env(parent = emptyenv())
.app_session_state$active_project <- NULL
.app_session_state$recent_projects <- list()

set_active_project <- function(project) {
  if (!is.null(project) && !methods::is(project, "OmicsProject")) {
    stop("Active project must be an OmicsProject or NULL.", call. = FALSE)
  }

  .app_session_state$active_project <- project
  invisible(project)
}

get_active_project <- function() {
  .app_session_state$active_project
}

reset_active_project <- function() {
  .app_session_state$active_project <- NULL
  invisible(NULL)
}

as_recent_project_entry <- function(project) {
  if (methods::is(project, "OmicsProject")) {
    return(list(
      project_root = project@project_root,
      project_name = project@project_name,
      project_id = project@project_id
    ))
  }

  if (!is.list(project)) {
    stop("Recent project entry must be a list or OmicsProject.", call. = FALSE)
  }

  if (is.null(project$project_root) || is.null(project$project_name)) {
    stop("Recent project entry must include project_root and project_name.", call. = FALSE)
  }

  list(
    project_root = project$project_root,
    project_name = project$project_name,
    project_id = if (!is.null(project$project_id)) project$project_id else NA_character_
  )
}

normalize_recent_project_entry <- function(project) {
  entry <- as_recent_project_entry(project)
  entry$project_root <- normalize_project_root(entry$project_root)
  entry
}

set_recent_projects <- function(projects) {
  if (!is.list(projects)) {
    stop("Recent projects must be a list.", call. = FALSE)
  }

  entries <- lapply(projects, normalize_recent_project_entry)
  .app_session_state$recent_projects <- entries
  invisible(entries)
}

get_recent_projects <- function() {
  .app_session_state$recent_projects
}

reset_recent_projects <- function() {
  .app_session_state$recent_projects <- list()
  invisible(NULL)
}

add_recent_project <- function(project) {
  entry <- normalize_recent_project_entry(project)
  existing <- .app_session_state$recent_projects
  filtered <- Filter(
    function(item) !identical(item$project_root, entry$project_root),
    existing
  )

  .app_session_state$recent_projects <- c(list(entry), filtered)
  invisible(entry)
}

remove_recent_project <- function(project_root) {
  project_root <- normalize_project_root(project_root)
  existing <- .app_session_state$recent_projects
  .app_session_state$recent_projects <- Filter(
    function(item) !identical(item$project_root, project_root),
    existing
  )
  invisible(project_root)
}
