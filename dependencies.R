# try to load a package, if its not installed then it installs it with the
# provided inst_fun, and finally it loads the package
load_install <- function(pkg, inst_fun=install.packages) {
  if (!require(pkg, character.only=TRUE)) {
    inst_fun(pkg);
    library(pkg, character.only=TRUE);
  }
}

# todo: replace by plotly?
load_install("ggplot2");
load_install("jsonlite");
load_install("keras");
if (!is_keras_available()) install_keras();
load_install("readr");
load_install("readxl");
load_install("shinythemes");
load_install("tibble");
load_install("visNetwork");

rm(load_install);
