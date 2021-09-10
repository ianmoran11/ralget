rm(list = ls())

devtools::document()
devtools::build()
devtools::install()


remove.packages("ralget")
library(ralget)


