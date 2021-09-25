library(devtools)
rm(list = ls())
devtools::document()
devtools::install()
library(tidyverse)
library(tidygraph)
library(ggraph)
library(patchwork)
library(magrittr)
library(ralget)
library(ggforce)
library(raldag)
library("conflicted")
options(dplyr.print_max = 3,dplyr.print_min = 3)
conflict_prefer("do", "raldag")
conflict_prefer("filter", "dplyr")
conflict_prefer("simulate", "raldag")

c <- v("c", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 10, sd =  4)))
a <- v("a", .f = d(~ rnorm(n = 10^4, mean = rsum(.x)     , sd =  1)))
x <- v("x", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 30, sd =  4)))
y <- v("y", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) +  7, sd =  2)))
m <- v("m", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 40, sd =  2)))


g <-
  (a * b(9) + m * b(1)) * x +
  (c * b(2) + m * b(5)) * y +
  (a * b(3) + c * b(5)) * m


g %>% evaluate_prepare() %>% evaluate_execute()


g %>% evaluate_prepare() %>% evaluate_execute()



h <-
  (m * b(2) + x * b(1)) * y



h %>% evaluate_prepare() %>% evaluate_execute()




q <- (m * b(2) + x * b(1)) * y  +  ( y * b(2)*c)

q %>% evaluate_prepare() %>% filter(row_number() == 1) %>% evaluate_execute()
q %>% evaluate_prepare() %>% filter(row_number() <= 2) %>% evaluate_execute()
q %>% evaluate_prepare() %>% evaluate_execute()
