test_that("multiplication works", {

  library(tidyverse)
  library(tidygraph)
  library(magrittr)
  library(ralget)


  circle <- v("a") * v("b") * v("c")
  line <- v("1")*v("2")*v("3")

  vertices_snap_shot <- c("a_1", "a_2", "a_3", "b_1", "b_2", "b_3", "c_1", "c_2", "c_3")

  edges_snapshot <-
   tribble( 
    ~from,  ~to,
     1,      2,
     1,      3,
     1,      4,
     1,      7,
     2,      3,
     2,      5,
     2,      8,
     3,      6,
     3,      9,
     4,      5,
     4,      6,
     4,      7,
     5,      6,
     5,      8,
     6,      9,
     7,      8,
     7,      9,
     8,      9)


  expect_true(
    all(as_tibble(activate(circle %x% line,"edges")) %>% select(from,to) %>%  `==`(edges_snapshot)) &
    all(pull(as_tibble(circle %x% line),name) == vertices_snap_shot)
    )

})
