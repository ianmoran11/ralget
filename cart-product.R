rm(list = ls())
library(tidyverse)
library(tidygraph)
library(ggraph)
library(patchwork)
library(magrittr)
library(ralget)
devtools::load_all()

v0 <- v(name = "00") 
v1 <- v(name = "01") 
v2 <- v(name = "02") 
v3 <- v(name = "03") 

A <- v("A")
B <- v("B")
C <- v("C")
D <- v("D")
E <- v("E")

x = A*B+B*C+C*D+D*E+E*A
y = v0*v1+v1*v2+v2*v3

y <- y %>% activate("edges") %>% mutate(.attrs = map(1, list(1))) %>% activate("nodes")
x <- x %>% activate("edges") %>% mutate(.attrs = map(1, list(2))) %>% activate("nodes")

plot(x %x% y)