install.packages("renv")
renv::deactivate()

rm(list = ls())
library(devtools)
document()
install()
library(tidyverse)
library(ggdag)
library(tidygraph)
library(dagitty)
library(ggraph)
library(patchwork)
library(magrittr)
library(ggforce)
library(boot)
library(conflicted)
load_all("../raldag")
load_all()
conflict_prefer("filter", "dplyr")
library(ralget)
library(raldag)

c <- v("c", .f = d(~ rnorm(n = 10^1, mean = rsum(.x) + 10, sd =  4)))
a <- v("a", .f = d(~ rnorm(n = 10^1, mean = rsum(.x)     , sd =  1)))
x <- v("x", .f = d(~ rnorm(n = 10^1, mean = rsum(.x) + 30, sd =  4)))
y <- v("y", .f = d(~ rnorm(n = 10^1, mean = rsum(.x) +  7, sd =  2)))
m <- v("m", .f = d(~ rnorm(n = 10^1, mean = rsum(.x) + 40, sd =  2)))

g <-
  (a * b(9) + m * b(1)) * x +
  (c * b(2) + m * b(5)) * y +
  (a * b(3) + c * b(5)) * m


rsum_list <<- list()

str(rsum_list)

g %>% evaluate()

append(rsum_list, list(list(1)))

d <- g %>% simulate(seed = 123)
print(d)

z <- v("z", .f = d(~ rnorm(n = 10, mean =  rsum(.x), sd = 0)))
x <- v("x", .f = d(~ rnorm(n = 10, mean =  rsum(.x), sd = 0)))
y <- v("y", .f = d(~ rnorm(n = 10, mean =  rsum(.x), sd = 0)))

g <- (z * b(1) + x * b(1)) * y +
     (z * b(1) * x)

t1 <- v("t1", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))
t2 <- v("t2", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))
t3 <- v("t3", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))
t4 <- v("t4", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))
t5 <- v("t5", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))

t <- (t1 * b(1) * t2) + (t2 * b(1) * t3) +
     (t3 * b(1) * t4) + (t4 * b(1) * t5)

xt <- cartesian_product(g,t,node_combine =  ~ c(.x), edge_combine =  ~ c(.x,.y))

xt %>% plot()

xt %>% simulate() %>% glimpse()

xt %>% manipulate(z_t2 = 1) %>% simulate() %>% glimpse()

xt1 %>%
    manipulate(z_t1 = 0 ) %>%
    manipulate(z_t2 = 1 ) %>%
    manipulate(z_t3 = 0 ) %>%
    simulate() %>%
    gather(var, value, -sim_id) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    mutate(value = as.numeric(value)) %>%
    ggplot(aes(x = period, y= value, group = sim_id)) +
    geom_line(alpha = .55) +
    facet_wrap(~var, scale = "free")