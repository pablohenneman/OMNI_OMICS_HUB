testthat::test_that("project dashboard requires explicit confirmation before deletion", {
  mod_project_dashboard_server <- OmniOmicsHub:::mod_project_dashboard_server

  delete_calls <- 0
  delete_stub <- function(project_root) {
    delete_calls <<- delete_calls + 1
    project_root
  }

  project <- shiny::reactive(list(
    project_name = "Demo Project",
    project_root = file.path(tempdir(), "demo-project")
  ))

  shiny::testServer(
    mod_project_dashboard_server,
    args = list(
      id = "project",
      project = project,
      delete_project_fn = delete_stub
    ),
    {
      session$setInputs(delete_project = 1)
      session$setInputs(delete_confirm = 1, delete_confirm_ack = FALSE)
      session$flushReact()
      testthat::expect_equal(delete_calls, 0)

      session$setInputs(delete_confirm_ack = TRUE)
      session$setInputs(delete_confirm = 2)
      session$flushReact()
      testthat::expect_equal(delete_calls, 1)
    }
  )
})
