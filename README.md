Keras Model Creator (Alpha Version)
================

Visually design [Keras models for R language](https://keras.rstudio.com/).

The idea of Keras Model Creator is based on [Deep Learning Studio](https://deepcognition.ai/features/deep-learning-studio/).

Take a look at the [guided tour!](https://jcrodriguez.shinyapps.io/KerasModelCreator_dev/?help)

Features
--------

-   Load input matrix.
    -   Select percentage of data to use as train and validation.
    -   Select input and output columns.
-   Add layers and connections manually.

-   Set compile options.

-   Get automatically generated code.

-   Fit your model! And visualize epoch by epoch its metrics.

-   Choose sample dataset and model to try Keras Model Creator.

Installation / Usage
--------------------

### Using shiny::runGitHub function

From an R console:

``` r
library("shiny");
runGitHub("KerasModelCreator", "jcrodriguez1989", ref="dev");
```

### Cloning the GitHub repository

Clone KerasModelCreator repository, i.e., from a bash console:

``` bash
git clone -b dev https://github.com/jcrodriguez1989/KerasModelCreator.git;
```

And run it, from an R console type:

``` r
# replace by the PATH where KerasModelCreator was cloned
setwd("KERASMODELCREATOR_PATH");

library("shiny");
# will open the app in a web browser
runApp();
```

### Online ShinyApps example

Visit the [example app](https://jcrodriguez.shinyapps.io/KerasModelCreator_dev/) at shinyapps.io

And take the [guided tour](https://jcrodriguez.shinyapps.io/KerasModelCreator_dev/?help).

R dependencies
--------------

**Note:** Keras Model Creator will also depend on wether the `keras` library can get in a working state, i.e.,

``` r
library("keras");
install_keras();
```

If not previously installed, these dependencies are going to be installed automatically

Dependencies:

-   `ggplot2`
-   `jsonlite`
-   `keras`
-   `readr`
-   `readxl`
-   `shinythemes`
-   `tibble`
-   `visNetwork` <!-- ```{r eval=FALSE} --> <!-- install.packages(c( --> <!--   "jsonlite", --> <!--   "keras", # not a dependency, but come on! --> <!--   "shiny", --> <!--   "shinythemes", --> <!--   "visNetwork" --> <!-- )); --> <!-- ``` -->

Limitations
-----------

-   Few network layers already developed.
