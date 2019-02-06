Keras Model Creator
================

Visually design [Keras models for R
language](https://keras.rstudio.com/).

The idea of Keras Model Creator is based on [Deep Learning
Studio](https://deepcognition.ai/features/deep-learning-studio/).

Take a look at the [guided
tour\!](https://jcrodriguez.shinyapps.io/KerasModelCreator/?help)

## Features

  - Add layers and connections manually.

  - Set compile options.

  - Get automatically generated code.

## Installation

Clone KerasModelCreator repository, i.e., from a bash console:

``` bash
git clone https://github.com/jcrodriguez1989/KerasModelCreator.git;
```

Install package dependencies, i.e., from R console:

``` r
install.packages(c(
  "jsonlite",
  "keras", # not a dependency, but come on!
  "shiny",
  "shinythemes",
  "visNetwork"
));
```

## Usage

From an R console type:

``` r
# replace by the PATH where KerasModelCreator was cloned
setwd("KERASMODELCREATOR_PATH");

library("shiny");
# will open the app in a web browser
runApp();
```

Or visit the [example
app](https://jcrodriguez.shinyapps.io/KerasModelCreator/) at
shinyapps.io

And take the [guided
tour](https://jcrodriguez.shinyapps.io/KerasModelCreator/?help).

## Limitations

  - Few network layers already developed.
