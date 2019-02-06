ui_help <- function() {
  fluidRow(
    div(id="help_mode", checkboxInput("help_mode", "Enable help mode")),
    actionButton("startHelp", "Start guided help"),
    br(),
    br()
  )
}

ui_help_model <- function() {
  wellPanel(
    h4("Help"),
    verbatimTextOutput("ui_help_model")
  );
}

ui_help_compile <- function() {
  wellPanel(
    h4("Help"),
    verbatimTextOutput("ui_help_compile")
  );
}
