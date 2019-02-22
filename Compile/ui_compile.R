source("Compile/global_compile.R", local=TRUE);
source("Help/ui_help.R", local=TRUE);

ui_compile <- function() {
  fluidRow(
    div(id="compile_opts", wellPanel(
      selectInput("optimizer_sel",
                  "Optimizer",
                  selectize=FALSE,
                  choices=optimizer_functions,
                  selected="adam",
                  size=round(length(optimizer_functions)*.5)),
      selectInput("loss_sel",
                  "Loss function",
                  selectize=FALSE,
                  choices=loss_functions,
                  selected="binary_crossentropy",
                  size=round(length(loss_functions)*.5)),
      selectInput("metrics_sel",
                  "Metrics",
                  selectize=FALSE,
                  multiple=TRUE,
                  choices=metric_functions,
                  selected="binary_accuracy",
                  size=round(length(metric_functions)*.5))
    )),
    conditionalPanel("input.help_mode", ui_help_compile())
  )
}
