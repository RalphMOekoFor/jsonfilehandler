#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    shinyWidgets::useShinydashboard(),
    # List the first level UI elements here
    dashboardPage(
      dashboardHeader(title = "Json File Generator"),

      # Sidebar -----------------------------------------------------------------
      dashboardSidebar(
        sidebarMenu(
          id = "sidebar",
          div(class = "sticky_footer",
              shiny::img(src = "www/images.png", #tags$a(img(src = "www/images.png", align = "right", height="13%", width="13%"), href="https://oekofor.netlify.app/de/"),
                         width = "228")),
          hr(),
            menuItem(h4("Select settings"),
                    tabName = "select_settings"
           )
        )
      ),

      # Body --------------------------------------------------------------------
      dashboardBody(
        tabItems(
          tabItem(
            tabName = "select_settings",
            # Your application UI logic
            fluidPage(
              fluidRow(
                column(
                  12,
                  box(mod_jsonfilecreator_ui("jsonfilecreator_1"), width = NULL)
                )
              )
            )
          )#,
          #tabItem(
          #  tabName = "recorder_tab_char",
          #)
      )
    )
  )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "jsonfilehandler"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
