test_that("Addition is commutative", {

  library(tidyverse)
  library(tidygraph)
  library(ralget)

  expect_true(v("a") + v("b") == v("b") + v("a")

)
})
