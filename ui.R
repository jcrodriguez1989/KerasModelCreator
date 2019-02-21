library("shiny");

source("Data/ui_data.R");
source("Model/ui_model.R");
source("Compile/ui_compile.R");
source("Fit/ui_fit.R");
source("Help/ui_help.R");

shinyUI(fluidPage(
  theme=shinytheme("simplex"),
  
  # help steps code
  includeCSS("www_utils/introjs.min.css"), # Include IntroJS styling
  includeScript("www_utils/intro.min.js"), # Include IntroJS library
  # Include JavaScript code to make shiny communicate with introJS
  includeScript("www_utils/app.js"),
  
  navbarPage("Keras Model Creator", id="nav",
    tabPanel(title="Data", ui_data(), value=5),
    tabPanel(title="Model", ui_model(), value=1),
    tabPanel(title="Compile", ui_compile(), value=2),
    tabPanel(title="Fit", ui_fit(), value=6),
    # Code is a blank panel so the generated code appears up
    tabPanel(title="Code", fluidRow(br()), value=3),
    tabPanel(title="Help", ui_help(), value=4)
  ),
  div(id="code_panel", wellPanel(
    h4("Code"),
    verbatimTextOutput("generated_code")
  ))
))
