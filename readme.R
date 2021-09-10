rm(list = ls())

library(tidyverse)
library(tidygraph)
library(tibble)
library(ggraph)
library(magrittr)
library(ralget)
library("visNetwork")

# Algebra ----------------------------------------------------------------------
## Basic replication -----------------------------------------------------------
p <- v("p"); q <- v("q"); s <- v("s"); r <- v("r");

g1 <- p*q+s
g2 <- q*s+q*r

g1 %>%

my_pplot <-   visNetwork(nodes = as_tibble(g1), edges = as.data.frame(activate(g1,"edges")))

g1 %>% plot
g2 %>% plot
(g1+g2) %>% plot()



html_name <- tempfile(fileext = ".html")
visSave(my_pplot, html_name)

library(webshot); #webshot::install_phantomjs() #in case phantomjs was not installed

library("webshot")
webshot(html_name, zoom = 2, file = "ex.png")



gg <- (g1+g2)
my_pplot <-  visNetwork(nodes = as_tibble(gg) %>% mutate(id = row_number()), edges = as_tibble(activate(gg,"edges")))


g3 <- s*r
g3 %>% plot()
(g1*g3) %>% plot()
