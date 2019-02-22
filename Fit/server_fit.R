# depending on inputs, it will load train, validation, and test submatrices
prepare_fit_data <- function(input_data, input, session) {
  if (is.null(input_data)) {
    showNotification("No data matrix loaded!\n Check in Data tab",
                     type="error");
    return(list());
  }
  if (is.na(input$train_perc) || 
      input$train_perc > 100 || input$train_perc < 0 ||
      is.na(input$validation_perc) || 
      input$validation_perc > 100 || input$validation_perc < 0 ||
      is.na(input$test_perc)  || 
      input$test_perc > 100 || input$test_perc < 0) {
    showNotification(paste0("Incorrect train, validation or test percentages!",
                            "\n Check in Data tab"), type="error");
    return(list());
  }
  if (is.na(input$n_epochs) || input$n_epochs < 1 ||
      is.na(input$batch_sz) || input$batch_sz < 1) {
    showNotification(paste0("Incorrect number for epochs and batch size!",
                            "\n Check in Data tab"), type="error");
    return(list());
  }
  if (length(input$input_cols) < 1 || length(input$output_col) < 1) {
    showNotification("Select columns for input and output!\n Check in Data tab",
                     type="error");
    return(list());
  }
  progress <- Progress$new(session, max=3);
  on.exit(progress$close());
  
  progress$set(message="Sampling rows for train and validation", value=1);
  # todo: implement input$balanced_input
  idxs <- seq_len(nrow(input_data));
  train_idxs <- sample(idxs,
                       round((input$train_perc*nrow(input_data)) / 100));
  idxs <- setdiff(idxs, train_idxs);
  val_idxs <- sample(idxs,
                     round((input$validation_perc*nrow(input_data)) / 100));
  test_idxs <- setdiff(idxs, val_idxs);
  
  # todo: check that what they say is numeric
  # merge numerical matrix with (previously transformed) categorical matrix
  progress$set(message="Converting categorical columns to numeric", value=2);
  inp_data <- input_data[, input$input_cols];
  inp_data <- cbind(
    as.matrix(inp_data[, intersect(input$numeric_cols, input$input_cols)]),
    do.call(cbind, lapply(intersect(input$categ_cols, input$input_cols),
                          function(i) {
      act_col <- as.matrix(inp_data[,i]);
      res <- to_categorical(as.numeric(as.factor(act_col))-1);
      colnames(res) <- paste(i, seq_len(ncol(res)), sep="_");
      res
    }))
  )
  
  # merge numerical matrix with (previously transformed) categorical matrix
  outp_data <- input_data[, input$output_col];
  outp_data <- cbind(
    as.matrix(outp_data[, intersect(input$numeric_cols, input$output_col)]),
    do.call(cbind, lapply(intersect(input$categ_cols, input$output_col),
                          function(i) {
      act_col <- as.matrix(outp_data[,i]);
      res <- to_categorical(as.numeric(as.factor(act_col))-1);
      colnames(res) <- paste(i, seq_len(ncol(res)), sep="_");
      res
    }))
  )
  
  progress$set(message="Data prepared to fit", value=3);
  return(list(
    x_train=inp_data[train_idxs,], y_train=outp_data[train_idxs,,drop=FALSE],
    x_val=inp_data[val_idxs,], y_val=outp_data[val_idxs,,drop=FALSE],
    x_test=inp_data[test_idxs,], y_test=outp_data[test_idxs,,drop=FALSE]
  ))
}

# run one fitting epoch and update the history
fit_model <- function(fit_data, model_history, gen_code) {
  if (length(fit_data) == 0)
    return(list());
  model_code <- parse(text=gen_code);
  model_code <- model_code[seq_len(length(model_code)-1)];
  model <- model_history$model;
  
  if (is.null(model)) {
    # lets create the model from 0 (from the code)
    tryCatch(
      eval(model_code),
      error = function(e) {
        showNotification(paste0("Error when creating model\n", e$message),
                         type="error")
      }
    )
    if (is.null(model)) # there was an error
      return(list());
  }
  
  x_train <- fit_data$x_train;
  y_train <- fit_data$y_train;
  x_val <- fit_data$x_val;
  y_val <- fit_data$y_val;
  
  old_history <- model_history$history;
  
  init_epoch <- 0;
  # get which epoch we have to exec
  if (!is.null(old_history))
    init_epoch <- old_history$params$epochs;
  
  # we have finnished
  n_epochs <- as.numeric(sub(".*epochs=(.+),.*", "\\1", gen_code));
  if (init_epoch+1 > n_epochs)
    return(model_history);
  
  fit_code <- 
    sub("epochs=.*,", 
        paste0("initial_epoch=", init_epoch, ", epochs=", init_epoch+1, ","),
        gen_code);
  fit_code <- rev(parse(text=fit_code))[[1]]; # just the fit part
  
  history <- NULL;
  tryCatch(
    eval(fit_code),
    error = function(e) {
      showNotification(paste0("Error when fitting model\n", e$message),
                       type="error")
    }
  )
  if (is.null(history)) # there was an error
    return(list());
  
  # update old_history with the new one
  if (!is.null(old_history)) {
    history$metrics <- lapply(seq_along(history$metrics), function(i) {
      c(old_history$metrics[[i]], history$metrics[[i]])
    })
    names(history$metrics) <- names(old_history$metrics);
  }
  
  return(list(model=model, history=history));
}
