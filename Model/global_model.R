activation_functions <- c(
  "elu",
  "exponential",
  "hard_sigmoid",
  "linear",
  "relu",
  "selu",
  "sigmoid",
  "softmax",
  "softplus",
  "softsign",
  "tanh"
)

regularizer_functions <- c(
  "NULL",
  "regularizer_l1()",
  "regularizer_l2()",
  "regularizer_l1_l2()"
)

# available layers to create, with their inputs ui
av_nodes <- list(
  "Dense"=fluidRow(hr(),
                   numericInput("dense_outp_dim",
                                label="Output dimension",
                                min=1, value=512, step=1),
                   selectInput("dense_activation",
                               "Activation",
                               choices=activation_functions,
                               selected="relu"),
                   selectInput("dense_regularizer",
                               "Regularizer",
                               choices=regularizer_functions,
                               selected="NULL")),
  "Dropout"=fluidRow(hr(),
                     numericInput("dropout_rate",
                                  label="Fraction to drop",
                                  min=0, value=0.5, max=1, step=0.05)),
  "Flatten"=fluidRow(),
  "Embedding"=fluidRow(hr(),
                       numericInput("embedding_outp_dim",
                                    label="Output dimension",
                                    min=1, value=16, step=1)),
  "Global average pooling 1D"=fluidRow()
);

# for the node_name layer gets its inputs as a list
get_node_options <- function(node_name, input) {
  switch(node_name,
    "Dense"=list(
      units=input$dense_outp_dim,
      activation=paste0('"', input$dense_activation, '"'),
      kernel_regularizer=input$dense_regularizer
    ),
    "Dropout"=list(
      rate=input$dropout_rate
    ),
    "Flatten"=list(),
    "Embedding"=list(
      output_dim=input$embedding_outp_dim
    ),
    "Global average pooling 1D"=list()
  )
}
