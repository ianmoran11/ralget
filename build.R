rm(list = ls())
devtools::document()
devtools::build()
devtools::install()

install.packages("devtools")
library(devtools)
devtools::document()
remove.packages("ralget")
library(ralget)

install.packages("tictoc")
install.packages("boot")