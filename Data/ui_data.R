ui_data <- function() {
  wellPanel(
    fluidRow(
      column(9, fileInput("data_input_file", label="Excel or csv")),
      column(3, textInput("data_input_sep", label="Separator",
                          placeholder="Used if csv"))
    ),
    fluidRow(
      column(3, numericInput("train_perc", label="Training (%)",
                             min=0, max=100, step=1, value=70)),
      column(3, numericInput("validation_perc", label="Validation (%)",
                             min=0, max=100, step=1, value=15)),
      column(3, numericInput("test_perc", label="Test (%)",
                             min=0, max=100, step=1, value=15)),
      column(2, verbatimTextOutput("data_numbs")),
      column(1, checkboxInput("balanced_input", label="Balanced"))
    ),
    fluidRow(
      column(6, selectInput("numeric_cols", "Numerical columns", choices=c(),
                            multiple=TRUE)),
      column(6, selectInput("categ_cols", "Categorical columns", choices=c(),
                            multiple=TRUE))
    ),
    fluidRow(
      column(6, selectInput("input_cols", "Input columns", choices=c(),
                            multiple=TRUE)),
      column(6, selectInput("output_col", "Output column", choices=c()))
    ),
    hr(),
    dataTableOutput("input_table")
  )
}