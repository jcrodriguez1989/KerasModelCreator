# generates the full code
generate_code <- function(data_shape, net, compile_opts) {
  libs_code <- 'library("keras")';
  model_code <- generate_model_code(data_shape, net);
  compile_code <- generate_compile_code(compile_opts);
  
  final_code <- paste(libs_code, model_code, compile_code, sep="\n\n");
  
  return(final_code);
}

# generates the model code
generate_model_code <- function(data_shape, net) {
  nodes <- net$nodes;
  edges <-net$edges; 
  
  data_shape <- ifelse(data_shape == 0, "SHAPE", data_shape);
  
  # for each layer create its code
  codes <- lapply(seq_len(nrow(nodes)), function(i)
    to_code(nodes[i,]));
  names(codes) <- nodes$id;
  
  # get which are the starting nodes (no edges going to them)
  starting_nodes_ids <- as.character(setdiff(nodes$id, edges$to));
  
  # for each starting code, attach also their connected layers code
  all_codes <- lapply(starting_nodes_ids, function(act_node_id) {
    res <- act_node_id;
    to_nodes_ids <- as.character(edges[edges$from == act_node_id, "to"]);
    while(length(to_nodes_ids) != 0) {
      res <- c(res, to_nodes_ids);
      to_nodes_ids <- as.character(edges[edges$from == to_nodes_ids, "to"]);
    }
    act_codes <- codes[res];
    
    # add input shape if its the first node after Input
    if (act_node_id == "node_0" && length(res) > 1) {
      # check if first layer is embedding, then it is input_dim
      param_name <- ifelse(nodes[nodes$id == res[[2]], "label"] == "Embedding",
                           "input_dim", "input_shape");
      act_codes[[2]] <- sub("(, ", "(", # if the layer didnt have any param
                            sub(")$",
                                paste0(", ", param_name, "=", data_shape, ")"),
                                            act_codes[[2]]), fixed=TRUE);
    }
    act_code <- paste(act_codes[res], collapse=" %>%\n  ");
    return(act_code);
  })
  
  # paste all the model codes (starting layers)
  model_code <- paste(all_codes, collapse="\n\n");
  return(model_code);
}

to_code <- function(act_node) {
  act_params <- act_node$params$params;
  # if the param is NULL then dont add it to the resulting code
  act_params <- act_params[act_params != "NULL"];
  
  # formatting params (name and value)
  act_params <- paste(
    names(act_params),
    act_params,
    sep="=",
    collapse=", "
  );
  
  # respective keras function for each layer
  act_fun <- switch(as.character(act_node$label),
    "\nInput"="model <- keras_model_sequential",
    "Dense"="layer_dense",
    "Dropout"="layer_dropout",
    "Flatten"="layer_flatten",
    "Embedding"="layer_embedding",
    "Global average pooling 1D"="layer_global_average_pooling_1d"
  );
  paste0(act_fun, "(", act_params, ")");
}

# generates the code from Compile tab
generate_compile_code <- function(compile_opts) {
  # add " to optimizer and loss
  compile_opts$optimizer <- paste0('"', compile_opts$optimizer, '"');
  compile_opts$loss <- paste0('"', compile_opts$loss, '"');
  # metrics can be multiple, so add c() and "
  compile_opts$metrics <- paste(
    'c(',
    paste0('"', compile_opts$metrics, '"', collapse=", "),
    ')',
    sep="");
  
  res <- paste(
    "model %>% compile(\n ",
    paste(names(compile_opts),
          compile_opts, sep="=", collapse=",\n  "),
    "\n)")
  
  return(res);
}
