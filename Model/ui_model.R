source("Model/global_model.R");
source("Help/ui_help.R");

ui_model <- function() {
  fluidRow(
    column(3,
      wellPanel(
        h4("Nodes"),
        fluidRow(div(id="layer_sel",
          selectInput("add_node_sel", "", selectize=FALSE,
                      size=length(av_nodes), choices=names(av_nodes)
        ))),
        div(id="layer_manip", fluidRow(
          actionButton("add_node_btn", "Add"),
          actionButton("del_node_btn", "Delete")
        )),
        div(id="layer_param", # div for help steps
          conditionalPanel("input.add_node_sel === 'Dense'",
                           av_nodes[["Dense"]])
        ),
        conditionalPanel("input.add_node_sel === 'Dropout'",
                           av_nodes[["Dropout"]]),
        conditionalPanel("input.add_node_sel === 'Flatten'",
                           av_nodes[["Flatten"]]),
        conditionalPanel("input.add_node_sel === 'Embedding'",
                           av_nodes[["Embedding"]]),
        conditionalPanel("input.add_node_sel === 'Global average pooling 1D'",
                           av_nodes[["Global average pooling 1D"]])
      ),
      wellPanel(
        h4("Edges"),
        div(id="edges_manip", fluidRow(
          actionButton("add_edge_btn", "Add"),
          actionButton("invert_edge_btn", "Invert"),
          actionButton("del_edge_btn", "Delete")
        ))
      )
    ),
    column(9, fluidRow(
      div(id="design_panel", wellPanel(visNetworkOutput("model_network"))),
      conditionalPanel("input.help_mode", ui_help_model())
    ))
  )
}