.app_session_state <- new.env(parent = emptyenv())
.app_session_state$active_project <- NULL

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
