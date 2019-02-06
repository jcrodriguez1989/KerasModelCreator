library("shiny");

source("Model/ui_model.R");
source("Compile/ui_compile.R");
source("Help/ui_help.R");

shinyUI(fluidPage(
    theme=shinytheme("simplex"),
    
    # help steps code
    includeCSS("introjs.min.css"), # Include IntroJS styling
    includeScript("intro.min.js"), # Include IntroJS library
    # Include JavaScript code to make shiny communicate with introJS
    includeScript("app.js"),
    
    navbarPage("Keras Model Creator", id="nav",
        tabPanel(title="Model", ui_model(), value=1),
        tabPanel(title="Compile", ui_compile(), value=2),
        # Code is a blank panel so the generated code appears up
        tabPanel(title="Code", fluidRow(br()), value=3),
        tabPanel(title="Help", ui_help(), value=4)
    ),
    div(id="code_panel", wellPanel(
        h4("Code"),
        verbatimTextOutput("generated_code")
    ))
))
