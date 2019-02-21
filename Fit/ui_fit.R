ui_fit <- function() {
  wellPanel(
    div(id="fit_opts", fluidRow(
      column(5, numericInput("n_epochs", "#Epochs", min=1, value=10, step=1)),
      column(5,
             numericInput("batch_sz", "Batch size", min=1, value=32, step=1)),
      column(2, actionButton("fit", "Fit"))
    )),
    div(id="fitting_progress", fluidRow(
      plotOutput("fit_plot")
    ))
  )
}
