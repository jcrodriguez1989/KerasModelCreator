library("shiny");

source("Data/server_data.R", local=TRUE);
source("Model/server_model.R", local=TRUE);
source("Fit/server_fit.R", local=TRUE);
source("CodeGenerator/server_code_generator.R", local=TRUE);
source("Help/server_help.R", local=TRUE);
source("help_steps.R", local=TRUE);

shinyServer(function(input, output, session) {
  
  ################### Data
  # update numeric inputs when one of them change
  observeEvent(input$train_perc, update_percs(input, session, "train"));
  observeEvent(input$validation_perc, update_percs(input, session, "val"));
  observeEvent(input$test_perc, update_percs(input, session, "test"));
  # update the text that shows the number of samples per group
  output$data_numbs <- renderText(update_data_numbs(input, input_data()));
  
  # update input_data when file uploaded
  input_data <- reactiveVal(NULL);
  observeEvent(input$data_input_file, input_data(read_input_file(input)));
  
  # show input_data
  output$input_table <- renderDataTable(input_data());
  
  # fill columns select input
  observeEvent(input_data(), update_columns_inputs(input_data(), session));
  
  # update columns category selection when one or other is modified
  observeEvent(input$numeric_cols, update_cat_cols(input, session, "num"));
  observeEvent(input$categ_cols, update_cat_cols(input, session, "cat"));
  
  # update columns outp/input select when one or other is modified
  observeEvent(input$input_cols, update_inp_cols(input, session, "input"));
  observeEvent(input$output_col, update_inp_cols(input, session, "output"));
  
  ################### Model
  start_net <- init_network();
  present_net <- reactiveVal(start_net); # model network to be updated
  
  # create the empty model network, with its options
  output$model_network <- renderVisNetwork({
    visNetwork(start_net$nodes, start_net$edges) %>%
      visPhysics(solver="forceAtlas2Based") %>%
      visInteraction(multiselect=TRUE) %>%
      visEvents(selectNode="function(nodes){
                  Shiny.onInputChange('selected_nodes', nodes.nodes);
                  ;}",
                deselectNode="function(nodes){
                  Shiny.onInputChange('selected_nodes', nodes.nodes);
                  ;}",
                selectEdge="function(edges){
                  Shiny.onInputChange('selected_edges', edges.edges);
                  ;}",
                deselectEdge="function(edges){
                  Shiny.onInputChange('selected_edges', edges.edges);
                  ;}"
      )
  });
  
  # update the nodes when net nodes get modified
  observeEvent(present_net(), {
    visNetworkProxy("model_network") %>%
      visUpdateNodes(present_net()$nodes)
  })
  
  # update the edges when net edges get modified
  observeEvent(present_net(), {
    visNetworkProxy("model_network") %>%
      visUpdateEdges(present_net()$edges)
  })
  
  # add node event
  observeEvent(input$add_node_btn, present_net(add_node(input, present_net())));
  
  # delete node event (and the associated edges)
  observeEvent(input$del_node_btn, present_net(del_node(input, present_net())));
  
  # add edge event
  observeEvent(input$add_edge_btn, {
    present_net(add_edge(edge=input$selected_nodes, present_net()));
  })
  
  # invert edge event
  observeEvent(input$invert_edge_btn, {
    present_net(invert_edge(input, input$selected_edges, present_net()));
  })
  
  # delete edge event
  observeEvent(input$del_edge_btn, {
    present_net(del_edge(input, input$selected_edges, present_net()));
  })
  
  ################### Compile
  # the compile inputs will be a reactive list
  compile_opts <- reactive(list(
    optimizer=input$optimizer_sel,
    loss=input$loss_sel,
    metrics=input$metrics_sel
  ));
  
  ################### Fit
  # the fit inputs will be a reactive list
  fit_opts <- reactive(list(
    epochs=input$n_epochs,
    batch_size=input$batch_sz
  ))
  
  # list to store x_train, y_train, x_test, etc.
  fit_data <- reactiveVal(list());
  # when hit on fit, first step is to prepare fit_data
  epochs_ran <- reactiveVal(0);
  observeEvent(input$fit, {
    model_history(list());
    fit_data(prepare_fit_data(input_data(), input));
    # strange thing to have the plot being updated
    epochs_ran(0);
    observe({
      isolate({
        epochs_ran(epochs_ran()+1);
        model_history(fit_model(
          fit_data(), model_history(), isolate(gen_code())));
      })
      if (isolate(epochs_ran() < input$n_epochs) && # if didnt finish
          isolate(length(model_history())) > 0) { # and there was not error
        invalidateLater(0, session);
      }
    });
  });
  
  # list to store the current model, and the fit history
  model_history <- reactiveVal(list());
  output$fit_plot <- renderPlot({
    if (is.null(model_history()$history)) {
      return(print(ggplot()));
    } else {
      plot(model_history()$history) + 
        coord_cartesian(xlim=c(1, isolate(input$n_epochs)), ylim=c(0, 1));
    }
  });
  
  ################### Code Generator
  # re-generate code whenever code or compile options change
  gen_code <- reactive(
    generate_code(
      length(input$input_cols),
      present_net(),
      compile_opts(),
      fit_opts()
    )
  );
  output$generated_code <- renderText(gen_code());
  
  ################### Help
  # if help mode activated then model and compile helps will be constantly
  # updating
  output$ui_help_model <- renderText(get_model_help(input));
  output$ui_help_compile <- renderText(get_compile_help(compile_opts()));
  
  # check if, according to the url, it has to start in guide tour mode
  observeEvent(parseQueryString(session$clientData$url_search), {
    if ("help" %in% names(parseQueryString(session$clientData$url_search))) {
      updateTabsetPanel(session, "nav", "4"); # go to help tab page
      set_help_content("4");
      # and start help
      session$sendCustomMessage(type="startHelp", message=list(""));
    }
  })
  
  # events to go switching between help steps and tabs
  help_steps <- help_steps();
  set_help_content <- function(act_tab) {
    # Index help data into right tab
    tab_idx <- help_steps$tab == act_tab;
    if (!any(tab_idx)) return()
    next_page <- help_steps[help_steps$step ==
                              max(help_steps[tab_idx, "step"])+1, "tab"];
    # set help content
    session$sendCustomMessage(type='setHelpContent',
                              message=list(steps=toJSON(help_steps[tab_idx,]),
                                           nextPage=next_page));
  }
  
  # when changing tab, help_steps have to be updated
  observe(set_help_content(input$nav))
  
  # Auto start help if we press next_page
  observeEvent(input$autoStartHelp, {
    if (input$autoStartHelp == 0) return()
    session$sendCustomMessage(type="startHelp", message=list(""));
  })
  
  # on click, send custom message to start help
  observeEvent(input$startHelp, {
    session$sendCustomMessage(type="startHelp", message=list(""));
  })
  
  # on click load data and network, and put them as current
  observeEvent(input$load_sample_data, {
    samp_data <- load_sample_data(input, session);
    input_data(samp_data$input_data);
    present_net(samp_data$present_net);
  })
  
  ################### Utils
  
  # if (exists("in_debug")) {
  #   input_data(read_excel("~/mytmp/iris.xlsx"));
  #   present_net <- reactiveVal(get(load(file="~/mytmp/net.RData")));
  # }
  
})
