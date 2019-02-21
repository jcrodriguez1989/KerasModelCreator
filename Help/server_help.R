get_model_help <- function(input) {
  node_name <- input$add_node_sel;
  layer_help <- get_layer_help(node_name);
  opts_help <- get_layer_opts_help(node_name, input);
  
  return(paste(layer_help, opts_help, sep="\n\n\n"));
}

get_layer_help <- function(layer_name) {
  switch(
    layer_name,
    "Dense"=paste(
      "Dense layer: Just your regular densely-connected NN layer."),
    "Dropout"=paste(
      "Dropout layer consists in randomly setting a fraction rate of input\n", 
      "units to 0 at each update during training time, which helps prevent\n",
      "overfitting."),
    "Flatten"=paste(
      "Flatten layer flattens the input, does not affect the batch size."),
    "Embedding"=paste(
      "Embedding layer turns positive integers (indexes) into dense vectors\n",
      "of fixed size.\n",
      "For example, list(4, 20) ~> list(c(0.25, 0.1), c(0.6, -0.2)) .\n",
      "This layer can only be used as the first layer in a model."),
    "Global average pooling 1D"=paste(
      "Global average pooling operation for temporal data.")
  )
}

get_layer_opts_help <- function(node_name, input) {
  switch(node_name,
         "Dense"=paste0(
           "Output dimension: dimensionality of the output space.\n\n",
           paste0(
             "Activation: Activation function to use.\n",
             get_activation_fns_help(input$dense_activation), "\n\n"),
           paste0(
             "Regularizers allow to apply penalties on layer parameters or\n",
             "layer activity during optimization. These penalties are\n",
             "incorporated in the loss function that the network optimizes.\n",
             get_regularizer_fns_help(input$dense_regularizer), "\n\n")
         ),
         "Dropout"="Fraction: fraction of the input units to drop.",
         "Flatten"=paste(),
         "Embedding"="Output dimension: dimension of the dense embedding.",
         "Global average pooling 1D"=paste()
  )
}

get_activation_fns_help <- function(activ_fn_name) {
  switch(activ_fn_name,
         "elu"="ELU: Exponential linear unit.",
         "exponential"="Exponential (base e) activation function.",
         "hard_sigmoid"=paste(
           "Hard sigmoid activation function.\n",
           "Faster to compute than sigmoid activation."),
         "linear"="Linear (i.e. identity) activation function. a(x) := x .",
         "relu"="RELU: Rectified Linear Unit.",
         "selu"="SELU: Scaled Exponential Linear Unit.",
         "sigmoid"="Sigmoid activation function.",
         "softmax"="Softmax activation function.",
         "softplus"="Softplus activation function.",
         "softsign"="Softsign activation function.",
         "tanh"="tanh: Hyperbolic tangent activation function."
  )
}

get_regularizer_fns_help <- function(regul_fn_name) {
  switch(regul_fn_name,
         "NULL"="NULL: Dont use regularizer layer.",
         "regularizer_l1()"="L1 penalty.",
         "regularizer_l2()"="L2 penalty.",
         "regularizer_l1_l2()"="L1 and L2 penalties."
  )
}

get_compile_help <- function(compile_opts) {
  optimizer_help <- get_optimizer_help(compile_opts$optimizer);
  loss_help <- get_loss_help(compile_opts$loss);
  metrics_help <- get_metrics_help(compile_opts$metrics);
  
  paste(optimizer_help, loss_help, metrics_help, sep="\n\n\n");
}

get_optimizer_help <- function(optimizer_opts) {
  res <- paste(
    "Optimizer — This is how the model is updated based on the data it\n",
    "sees and its loss function.");
  selected_opt_help <- switch(
    optimizer_opts,
    "adadelta"=paste(
      "Adadelta is a more robust extension of Adagrad that adapts learning\n",
      "rates based on a moving window of gradient updates, instead of\n",
      "accumulating all past gradients. This way, Adadelta continues\n",
      "learning even when many updates have been done. Compared to Adagrad,\n",
      "in the original version of Adadelta you don't have to set an initial\n",
      "learning rate. In this version, initial learning rate and decay\n",
      "factor can be set, as in most other Keras optimizers."),
    "adagrad"=paste(
      "Adagrad is an optimizer with parameter-specific learning rates, which\n",
      "are adapted relative to how frequently a parameter gets updated\n",
      "during training. The more updates a parameter receives, the smaller\n",
                      "the updates."),
    "adam"=paste(
      "Adam optimizer as described in Adam - A Method for Stochastic\n",
      "Optimization. https://arxiv.org/abs/1412.6980v8"),
    "adamax"=paste(
      "Adamax optimizer from Section 7 of the Adam paper. It is a variant of\n",
      "Adam based on the infinity norm. https://arxiv.org/abs/1412.6980v8"),
    "nadam"=paste(
      "Much like Adam is essentially RMSprop with momentum, Nadam is Adam\n",
      "RMSprop with Nesterov momentum."),
    "rmsprop"=paste(
      "RMSProp optimizer. This optimizer is usually a good choice for\n",
      "recurrent neural networks."),
    "sgd"=paste(
      "Stochastic gradient descent optimizer with support for momentum,\n",
      "learning rate decay, and Nesterov momentum.")
  )
  paste(res, selected_opt_help, sep="\n\n");
}

get_loss_help <- function(loss_opts) {
  res <- paste(
    "Loss function — This measures how accurate the model is during\n",
    "training. We want to minimize this function to “steer” the model in the\n",
    "direction.");
  selected_opt_help <- switch(
    loss_opts,
    "binary_crossentropy"=paste(),
    "categorical_crossentropy"=paste(
      "When using the categorical_crossentropy loss, your targets should be\n",
      "in categorical format (e.g. if you have 10 classes, the target for\n",
      "each sample should be a 10-dimensional vector that is all-zeros\n",
      "except for a 1 at the index corresponding to the class of the\n",
      "sample). In order to convert integer targets into categorical\n",
      "targets, you can use the Keras utility function to_categorical()"),
    "categorical_hinge"=paste(
      "max(c(0, max((1. - y_true) * y_pred) - sum(y_true * y_pred) + 1))"),
    "cosine_proximity"=paste(
      "sum(l2_normalize(y_true) * l2_normalize(y_pred))"),
    "hinge"=paste(
      "mean(max(c(1 - y_true * y_pred), 0))"),
    "kullback_leibler_divergence"=paste(
      "y_true <- clip(y_true, epsilon(), 1)\n",
      "y_pred <- clip(y_pred, epsilon(), 1)\n",
      "sum(y_true * log(y_true / y_pred))"),
    "logcosh"=paste(
      "Logarithm of the hyperbolic cosine of the prediction error.\n",
      "log(cosh(x)) is approximately equal to (x ** 2) / 2 for small x and\n",
      "to abs(x) - log(2) for large x. This means that 'logcosh' works\n",
      "mostly like the mean squared error, but will not be so strongly\n",
      "affected by the occasional wildly incorrect prediction. However, it\n",
      "may return NaNs if the intermediate value cosh(y_pred - y_true) is\n",
      "too large to be represented in the chosen precision."),
    "mean_absolute_error"=paste(
      "mean(abs(y_pred - y_true))"),
    "mean_absolute_percentage_error"=paste(
      "100 * mean(abs((y_true - y_pred) / clip(abs(y_true), epsilon(),\n",
      "None)))"),
    "mean_squared_error"=paste(
      "mean((y_pred - y_true) ^ 2)"),
    "mean_squared_logarithmic_error"=paste(
      "mean((log(clip(y_pred, epsilon(), None) + 1) - log(clip(y_true,\n",
      "epsilon(), None) + 1)) ^ 2)"),
    "poisson"=paste(
      "mean(y_pred - y_true * log(y_pred + epsilon()))"),
    "sparse_categorical_crossentropy"=paste(),
    "squared_hinge"=paste(
      "mean(max(c(1 - y_true * y_pred, 0)) ^ 2)")
  )
  selected_opt_help <- paste0(loss_opts, ":\n", selected_opt_help);
  paste(res, selected_opt_help, sep="\n\n");
}

get_metrics_help <- function(metrics_opts) {
  res <- paste(
    "Metrics — Used to monitor the training and testing steps. The\n",
    "following example uses accuracy, the fraction of the images that are\n",
    "correctly classified.");
  selected_opt_help <- lapply(metrics_opts, function(metric_opts) {
    switch(
      metric_opts,
      "binary_accuracy"=paste(
        "mean(y_true == round(y_pred))"),
      "binary_crossentropy"=paste(),
      "categorical_accuracy"=paste(
        "argmax(y_true) == argmax(y_pred)"),
      "categorical_crossentropy"=paste(
        "When using the categorical_crossentropy loss, your targets should\n",
        "be in categorical format (e.g. if you have 10 classes, the target\n",
        "for each sample should be a 10-dimensional vector that is all-zeros\n",
        "except for a 1 at the index corresponding to the class of the\n",
        "sample). In order to convert integer targets into categorical\n",
        "targets, you can use the Keras utility function to_categorical()"),
      "cosine_proximity"=paste(
        "sum(l2_normalize(y_true) * l2_normalize(y_pred))"),
      "hinge"=paste(
        "mean(max(c(1 - y_true * y_pred), 0))"),
      "kullback_leibler_divergence"=paste(
        "y_true <- clip(y_true, epsilon(), 1)\n",
        "y_pred <- clip(y_pred, epsilon(), 1)\n",
        "sum(y_true * log(y_true / y_pred))"),
      "mean_absolute_error"=paste(
        "mean(abs(y_pred - y_true))"),
      "mean_absolute_percentage_error"=paste(
        "100 * mean(abs((y_true - y_pred) / clip(abs(y_true), epsilon(),\n",
        "None)))"),
      "mean_squared_error"=paste(
        "mean((y_pred - y_true) ^ 2)"),
      "mean_squared_logarithmic_error"=paste(
        "mean((log(clip(y_pred, epsilon(), None) + 1) - log(clip(y_true,\n",
        "epsilon(), None) + 1)) ^ 2)"),
      "poisson"=paste(
        "mean(y_pred - y_true * log(y_pred + epsilon()))"),
      "sparse_categorical_crossentropy"=paste(),
      "sparse_top_k_categorical_accuracy"=paste(
        "mean(in_top_k(y_pred, flatten(y_true), k)),"),
      "squared_hinge"=paste(
        "mean(max(c(1 - y_true * y_pred, 0)) ^ 2)"),
      "top_k_categorical_accuracy"=paste(
        "mean(in_top_k(y_pred, argmax(y_true), k))")
    )
  })
  selected_opt_help <- paste0(metrics_opts, ":\n", selected_opt_help);
  paste(res, paste(selected_opt_help, collapse="\n\n"), sep="\n\n");
}

# load the selected sample data (just iris for now)
load_sample_data <- function(input, session) {
  switch(
    input$sample_data,
    "Iris"=load_iris_data(input, session)
  )
}

# load iris sample data (matrix and model). Also update input fields as loss
load_iris_data <- function(input, session) {
  input_data <- as_tibble(iris[,c(5,1:4)]);
  
  # create the model network
  present_net <- list();
  present_net$nodes <- data.frame(
    id=paste0("node_", 0:4),
    label=c("\nInput", rep("Dense", 4)),
    color.background="lightblue",
    color.border="black",
    title=c(
      "",
      'units=30<br/>activation="relu"<br/>kernel_regularizer=NULL',
      'units=10<br/>activation="relu"<br/>kernel_regularizer=NULL',
      'units=5<br/>activation="relu"<br/>kernel_regularizer=NULL',
      'units=3<br/>activation="softmax"<br/>kernel_regularizer=NULL'
      ),
    shadow=TRUE,
    shape=c("database", rep("box", 4))
  )
  present_net$nodes$params <- list(
    params=NULL,
    params=list(),
    params=list(),
    params=list(),
    params=list()
  )
  present_net$nodes$params[[2]]$units <- 30;
  present_net$nodes$params[[2]]$activation <- "\"relu\"";
  present_net$nodes$params[[2]]$kernel_regularizer <- "NULL";
  present_net$nodes$params[[3]]$units <- 10;
  present_net$nodes$params[[3]]$activation <- "\"relu\"";
  present_net$nodes$params[[3]]$kernel_regularizer <- "NULL";
  present_net$nodes$params[[4]]$units <- 5;
  present_net$nodes$params[[4]]$activation <- "\"relu\"";
  present_net$nodes$params[[4]]$kernel_regularizer <- "NULL";
  present_net$nodes$params[[5]]$units <- 3;
  present_net$nodes$params[[5]]$activation <- "\"softmax\"";
  present_net$nodes$params[[5]]$kernel_regularizer <- "NULL";
  
  present_net$edges <- data.frame(
    id=paste0("edge_", 1:4),
    from=paste0("node_", 0:3),
    to=paste0("node_", 1:4),
    arrows="to"
  );
  
  updateSelectInput(session, "optimizer_sel", selected="adam");
  updateSelectInput(session, "loss_sel", 
                    selected="categorical_crossentropy");
  updateSelectInput(session, "metrics_sel", selected="categorical_accuracy");
  
  updateNumericInput(session, "n_epochs", value=30);
  updateNumericInput(session, "batch_sz", value=5);
  
  updateTabsetPanel(session, "nav", "5"); # go to data tab page
  
  return(list(input_data=input_data, present_net=present_net));
}
