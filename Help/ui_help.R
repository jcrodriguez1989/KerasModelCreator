ui_help <- function() {
  fluidRow(
    div(id="help_mode", checkboxInput("help_mode", "Enable help mode")),
    div(id="sample_data", fluidRow(
      column(2, actionButton("startHelp", "Start guided help")),
      column(2, selectInput("sample_data", label=NULL, choices="Iris")),
      column(2, actionButton("load_sample_data", "Load sample"))
    )),
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
