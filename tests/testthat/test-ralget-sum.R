test_that("multiplication works", {

  library(tidyverse)
  library(tidygraph)
  library(magrittr)
  library(ralget)

expect_true(v("1") + v("2") == sumv(v("1"), v("2")))


})
