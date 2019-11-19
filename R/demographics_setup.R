# demographics set-up

# install required packages
if (!require(tidyverse)) {
  install.packages("tidyverse")
}
if (!require(tidycensus)) {
  install.packages("tidycensus")
}
if (!(require(ggplot2))) {
  install.packages("ggplot2")
}
if (!require(devtools)) {
  install.packages("devtools")
}
if (!(require(databraryapi))) {
  devtools::install_github("PLAY-behaviorome/databraryapi")
}

# 
