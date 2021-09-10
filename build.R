rm(list = ls())

renv::init()
renv::restore()
devtools::document()
devtools::build()
devtools::install()


remove.packages("ralget")
library(ralget)


