# if one field increments in one, then decrease it from another field
update_percs <- function(input, session, which) {
  if (is.na(input$train_perc) || is.na(input$validation_perc) || 
      is.na(input$test_perc)) {
    showNotification(paste0("Incorrect train, validation or test percentages!",
                            "\n Check in Data tab"), type="error");
    return();
  }
  
  changes <- c("validation_perc", "test_perc", "train_perc");
  names(changes) <- c("train", "val", "test");
  which <-which(which == names(changes));
  to_change <- changes[[which]];
  
  # if the field from which decrease is 0, then decrease the next field
  if (input[[to_change]] == 0)
    to_change <- changes[[ifelse(which==3, 1, which+1)]];
  
  new_val <- 100-(input$train_perc + input$validation_perc + input$test_perc);
  updateNumericInput(session, to_change, value=input[[to_change]] + new_val);
  # bug? for some reason if long pressed any input, then it gets crazy
}

# depending on rows of the input matrix, and percentages for train, validation,
# and test, it calculates the number of each group
update_data_numbs <- function(input, input_data) {
  if (is.null(input_data))
    return("")
  n_train <- round((input$train_perc*nrow(input_data)) / 100);
  n_val <- round((input$validation_perc*nrow(input_data)) / 100);
  n_test <- nrow(input_data)-n_train-n_val;
  paste0(
    n_train, " + ",
    n_val, " + ",
    n_test, " = ",
    nrow(input_data)
  )
}

read_input_file <- function(input, session) {
  res <- NULL;
  file_path <- input$data_input_file$datapath;
  sep <- isolate(input$data_input_sep);
  sep <- ifelse(sep == "", ",", sep); # comma is the default
  sep <- ifelse(sep == "\\t", "\t", sep); # doesnt work to do it with sub
  progress <- Progress$new(session, max=2);
  on.exit(progress$close());
  
  # first try to read it as excel, if not read it as csv
  progress$set(message="Trying to load as excel file.", value=1);
  tryCatch(
    res <- read_excel(file_path),
    error = function(e) {
      res <- NULL;
    }
  )
  
  # if could not load as excel, try as csv
  progress$set(message="Trying to load as csv or tsv file.", value=2);
  if (is.null(res)) {
    tryCatch(
      res <- read_delim(file_path, sep),
      error = function(e) {
        res <- NULL;
      }
    )
  }
  return(res);
}

# fill choices columns depending in tibble predictions
update_columns_inputs <- function(input_data, session) {
  col_classes <- sapply(input_data, class);
  updateSelectInput(session, "numeric_cols", choices=names(col_classes), 
                    selected=names(col_classes)[col_classes == "numeric"]);
  updateSelectInput(session, "categ_cols", choices=names(col_classes), 
                    selected=names(col_classes)[col_classes != "numeric"]);
  
  updateSelectInput(session, "input_cols", choices=names(col_classes), 
                    selected=names(col_classes)[-1]);
  updateSelectInput(session, "output_col", choices=names(col_classes), 
                    selected=names(col_classes)[[1]]);
}

# switch choices between numeric or categorical (cant be both)
update_cat_cols <- function(input, session, which) {
  changes <- c("numeric_cols", "categ_cols");
  names(changes) <- c("num", "cat");
  which <-which(which == names(changes));
  updateSelectInput(session, changes[[-which]],
                    selected=setdiff(
                      input[[changes[[-which]]]],
                      input[[changes[[which]]]]));
}

# switch choices between input or output (cant be both)
update_inp_cols <- function(input, session, which) {
  changes <- c("input_cols", "output_col");
  names(changes) <- c("input", "output");
  which <-which(which == names(changes));
  new_sel <- setdiff(input[[changes[[-which]]]], input[[changes[[which]]]]);
  
  # if output is going to get empty, then try to fill it with any not input
  # if (changes[[which]] == "input_cols" && length(new_sel) == 0)
  #   new_sel <- setdiff(choices, input$input_cols)[1];
  
  updateSelectInput(session, changes[[-which]], selected=new_sel);
}
