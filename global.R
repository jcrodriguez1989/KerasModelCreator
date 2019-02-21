source("dependencies.R");

# create help_steps data frame
help_steps <- data.frame(matrix(c(
  4, NA, "In this guided tour you will learn how to develop a model for the Keras library of R with Keras Model Creator.",
  4, "#help_mode", "If you additionally want to have constant help on the parameters of the model, check this option.",
  4, "#sample_data", "Don't forget that you can get loaded sample datasets and models ready to fit or tune.",
  4, NA, "Let's get started. Load the input matrix file in the 'Data' tab.",
  5, "#browse_input_matrix", "Browse and select the excel, csv, tsv, or any matrix file to upload. First column will be output column by default.",
  5, "#train_percs", "Select the percentage of the rows to randomly use as train and validation sets (test not yet implemented).",
  5, "#num_categ_cols", "Specify which columns have numerical or categorical data. Categorical columns will be transformed to a new matrix, of #categories columns, with 0s and 1s values.",
  5, "#inp_outp_cols", "Specify which are the input columns, and the output colum.",
  5, NA, 'Let\'s go on, in the "Model" tab you can visually create your model.',
  1, "#design_panel", 'On the design panel you can see the layers and connections present. Initially only the "Input" layer will be present.',
  1, "#layer_sel", "Select the layer you want to add.",
  1, "#layer_param", "Configure the layer parameters.",
  1, "#layer_manip", "And add the layer to the design.",
  1, NA, "The new layer will be connected to the last layer added to the design.",
  1, "help_mode", "It is possible to click on layers or connections in the design panel, and delete them by clicking on the respective button.",
  1, "#edges_manip", 'To generate a new connection, select two layers (Ctrl+click) in the design panel, and click on the "Add" button.',
  1, "#edges_manip", 'If you want some connection to be in the other direction, select it from the design panel, and click on "Invert".',
  1, NA, 'Now let\'s set the parameters to compile the model, this is done in the "Compile" tab.',
  2, "#compile_opts", "Complete the options of optimizer, loss function and metrics. Note that you will be able to select multiple metrics.",
  2, NA, "And let\'s go to fit our model!",
  6, "#fit_opts", "Set up the number of epochs to fit, and the batch size. If input data was loaded in the 'Data' tab then we can click the 'Fit' button to get our model trained right now!",
  6, "#fitting_progress", "If input data was loaded, then we can see the training progress epoch by epoch.",
  6, NA, "If no data was loaded, we can see anyways the code that generates our model!",
  3, "#code_panel", "Just copy and paste this code into an R terminal, and your model will be ready to be fitted. Remember that, if you have not uploaded the data matrix, then, you must complete the SHAPE of your model (in the code, where it says SHAPE). For example, if your data are n images of 28x28 then SHAPE=c(28, 28); if your data are n vectors of 512 binary values then SHAPE=512 .",
  3, NA, "Now you are ready to enjoy Keras Model Creator."
), ncol=3, byrow=!F));
colnames(help_steps) <- c("tab", "element", "intro");
help_steps$position <- "auto";
help_steps$step <- seq_len(nrow(help_steps));
help_steps$tab <- as.numeric(as.character(help_steps$tab));
