resolve_project_info <- function(project) {
  if (is.null(project)) {
    return(NULL)
  }

  if (methods::is(project, "OmicsProject")) {
    return(list(
      project_name = project@project_name,
      project_root = project@project_root
    ))
  }

  if (is.list(project) && !is.null(project$project_name) && !is.null(project$project_root)) {
    return(list(
      project_name = project$project_name,
      project_root = project$project_root
    ))
  }

  NULL
}

delete_confirmation_body <- function(project_info) {
  shiny::tagList(
    shiny::tags$p(
      paste0(
        "You are about to delete project \"",
        project_info$project_name,
        "\"."
      )
    ),
    shiny::tags$ul(
      shiny::tags$li("This action is irreversible."),
      shiny::tags$li("All workspaces and data in this project will be deleted."),
      shiny::tags$li(paste0("Project path: ", project_info$project_root))
    )
  )
}

mod_project_dashboard_server <- function(id,
                                         project,
                                         delete_project_fn = delete_project) {
  shiny::moduleServer(id, function(input, output, session) {
    status_message <- shiny::reactiveVal("")

    output$delete_status <- shiny::renderText({
      status_message()
    })

    shiny::observeEvent(input$delete_project, {
      project_info <- resolve_project_info(project())
      if (is.null(project_info)) {
        status_message("No project available to delete.")
        return()
      }

      shiny::showModal(
        shiny::modalDialog(
          title = "Confirm Project Deletion",
          delete_confirmation_body(project_info),
          shiny::checkboxInput(
            session$ns("delete_confirm_ack"),
            label = "I understand this will permanently delete this project.",
            value = FALSE
          ),
          easyClose = TRUE,
          footer = shiny::tagList(
            shiny::modalButton("Cancel"),
            shiny::actionButton(
              session$ns("delete_confirm"),
              "Delete Project",
              class = "btn-danger"
            )
          )
        )
      )
    })

    shiny::observeEvent(input$delete_confirm, {
      project_info <- resolve_project_info(project())
      if (is.null(project_info)) {
        status_message("No project available to delete.")
        return()
      }

      if (!isTRUE(input$delete_confirm_ack)) {
        status_message("Please confirm deletion to proceed.")
        return()
      }

      result <- tryCatch(
        {
          delete_project_fn(project_info$project_root)
          TRUE
        },
        error = function(err) {
          status_message(err$message)
          FALSE
        }
      )

      if (isTRUE(result)) {
        shiny::removeModal()
        status_message(
          paste0("Project deleted: ", project_info$project_name, ".")
        )
      }
    })
  })
}
