rm(list = ls())

library(tidyverse)
library(tidygraph)
library(tibble)
library(ggraph)
library(magrittr)
library(ralget)


# Algebra ----------------------------------------------------------------------
## Basic replication -----------------------------------------------------------
p <- v("p"); q <- v("q"); s <- v("s"); r <- v("r");

g1 <- p*q+s
g2 <- q*s+q*r

g1 %>% plot
g2 %>% plot
(g1+g2) %>% plot()

g3 <- s*r
g3 %>% plot()
(g1*g3) %>% plot()
