init_network <- function() {
  init_nodes <- data.frame(
    id="node_0",
    label="\nInput",
    color=list(background = "lightblue", 
               border = "black"),
    title="",
    shadow=TRUE,
    shape="database"
  );
  init_nodes$params <- list(params=NULL);
  
  init_edges <- data.frame(
    id=character(),
    from=character(),
    to=character(),
    arrows=character()
  );
  
  return(list(nodes=init_nodes, edges=init_edges))
}

add_node <- function(input, net) {
  act_nodes <- net$nodes;
  new_node <- input$add_node_sel;
  last_node <- max(c(as.numeric(
    sub("node_", "", as.character(act_nodes$id))), 0));
  new_node_row <- data.frame(
    id=paste0("node_", last_node+1),
    label=new_node,
    color=list(background = "lightblue", 
               border = "black"),
    shadow=TRUE,
    shape="box"
  );
  new_node_row$params <- list(params=get_node_options(new_node, input));
  new_node_row$title <- paste(names(new_node_row$params$params),
                              new_node_row$params$params,
                              sep="=", collapse="<br/>");
  new_nodes <- rbind(act_nodes, new_node_row);
  net$nodes <- new_nodes;
  
  # try to add an edge from the latest node to the new one
  new_net <- add_edge(paste0("node_", last_node:(last_node+1)), net);
  return(new_net);
}

del_node <- function(input, net) {
  to_del <- setdiff(input$selected_nodes, "node_0");
  if (length(to_del) == 0)
    return(net); # cant delete input node
  nodes <- net$nodes;
  edges <- net$edges;
  sel_nodes_idx <- which(nodes$id %in% to_del);
  new_nodes <- nodes[-sel_nodes_idx,];
  visNetworkProxy("model_network") %>%
    visRemoveNodes(to_del)
  edges_to_remove <- edges[edges$to %in% to_del |
                             edges$from %in% to_del, "id"];
  new_net <- net;
  new_net$nodes <- new_nodes;
  new_net <- del_edge(input, edges_to_remove, new_net);
  return(new_net);
}

add_edge <- function(edge, net) {
  if (length(edge) != 2) {
    showNotification("Select two layers", type="error");
    return(net);
  }
  
  if (!can_add_ege(edge, net)) {
    edge <- rev(edge);
    if (!can_add_ege(edge, net)) {
      return(net);
    }
  }
  edges <- net$edges;
  net$edges <- rbind(edges,
    data.frame(
      id=paste0("edge_", max(c(as.numeric(
        sub("edge_", "", as.character(edges$id))), 0))+1),
      from=edge[[1]],
      to=edge[[2]],
      arrows="to"
    )
  )
  return(net);
}

can_add_ege <- function(edge, net) {
  nodes <- net$nodes;
  edges <- net$edges;
  
  # Embedding layer can only be the first layer
  if (nodes[nodes$id == edge[[2]], "label"] == "Embedding" &&
      nodes[nodes$id == edge[[1]], "label"] != "\nInput") {
    showNotification(paste("Embedding layer can only be added as first layer",
                           "of the model (after Input)"), type="error");
    return(FALSE);
  }
  
  # Global average pooling 1D layer cant be the first layer
  if (nodes[nodes$id == edge[[2]], "label"] == "Global average pooling 1D" &&
      nodes[nodes$id == edge[[1]], "label"] == "\nInput") {
    showNotification(paste("Global average pooling 1D layer can not be added as",
                           " first layer of the model (after Input)"),
                     type="error");
    return(FALSE);
  }
  
  res <- !(has_cycle(edge, net) || already_has_edge(edge, net) ||
             goes_to_input_node(edge, net));
  if (!res)
    showNotification(paste("Model can not have cycles, or two edges from/to",
                           "one node"), type="error");
    
  return(res);
}

has_cycle <- function(edge, net) {
  nodes <- net$nodes;
  edges <- net$edges;

  # if from edge[[2]] I can reach edge[[1]] then it will generate a cycle
  vis_nodes <- edge[[2]];
  next_nodes <- as.character(edges[edges$from %in% vis_nodes, "to"]);
  
  while(length(next_nodes) > 0 && !edge[[1]] %in% vis_nodes) {
    vis_nodes <- c(vis_nodes, next_nodes);
    next_nodes <- as.character(edges[edges$from %in% next_nodes, "to"]);
  }
  
  return(edge[[1]] %in% vis_nodes);
}

already_has_edge <- function(edge, net) {
  edges <- net$edges;
  res <- edge[[1]] %in% edges$from || edge[[2]] %in% edges$to;
  return(res);
}

goes_to_input_node <- function(edge, net) {
  res <- edge[[2]] == "node_0";
  return(res);
}

invert_edge <- function(input, edge_id, net) {
  edges <- net$edges;
  if (is.null(edge_id) || !edge_id %in% edges$id)
    return(net);
  edge_idx <- which(edges$id == edge_id);
  new_net <- net;
  new_net$edges <- edges[-edge_idx,];
  edge <- edges[edge_idx, c("from", "to")];
  
  if (can_add_ege(rev(edge), new_net)) {
    net <- del_edge(input, edge_id, net);
    net <- add_edge(rev(edge), net);
  }
  
  return(net);
}

del_edge <- function(input, edge_id, net) {
  edges <- net$edges;
  edge_id <- edge_id[edge_id %in% edges$id];
  if (is.null(edge_id) || length(edge_id) == 0)
    return(net);
  net$edges <- edges[!edges$id %in% edge_id,];
  visNetworkProxy("model_network") %>%
    visRemoveEdges(edge_id)
  return(net);
}

update_edges <- function(present_edges, net) {
  present_edges[present_edges$from %in% present_nodes$id &
                  present_edges$to %in% present_nodes$id,];
}
