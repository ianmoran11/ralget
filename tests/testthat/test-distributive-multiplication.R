test_that("multiplication works", {
  library(tidyverse)
  library(tidygraph)
  library(ralget)
  library(testthat)

expect_true(v("a") * (v("b") + v("c")) ==  v("a")*v("b") + v("a")*v("c"))

})
