require("jsonlite");
require("shinythemes");
require("visNetwork");

# create help_steps data frame
help_steps <- data.frame(matrix(c(
  4, NA, "In this guided tour you will learn how to develop a model for the Keras library of R with Keras Model Creator.",
  4, "#help_mode", "If you additionally want to have constant help on the parameters of the model, check this option.",
  4, NA, "Let's get started.",
  4, NA, 'In the "Model" tab you can visually create your model.',
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
  2, NA, "And now we are ready to see the R code that generates our model!",
  3, "#code_panel", "Just copy and paste this code into an R terminal, and your model will be ready to be fitted. Remember that you must complete the SHAPE of your model (in the code, where it says SHAPE). For example, if your data are n images of 28x28 then SHAPE=c(28, 28); if your data are n vectors of 512 binary values then SHAPE=512 .",
  3, NA, "Now you are ready to enjoy Keras Model Creator."
), ncol=3, byrow=!F));
colnames(help_steps) <- c("tab", "element", "intro");
help_steps$position <- "auto";
help_steps$step <- seq_len(nrow(help_steps));
help_steps$tab <- as.numeric(as.character(help_steps$tab));
