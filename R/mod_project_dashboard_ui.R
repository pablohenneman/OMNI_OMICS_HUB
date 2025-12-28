mod_project_dashboard_ui <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::actionButton(
      ns("delete_project"),
      "Delete Project",
      class = "btn-danger"
    ),
    shiny::tags$div(
      class = "project-delete-status",
      shiny::textOutput(ns("delete_status"))
    )
  )
}
