rm(list = ls())
library(devtools)
library(tidyverse)
library(ggdag)
library(tidygraph)
library(dagitty)
library(ggraph)
library(patchwork)
library(magrittr)
library(ggforce)
library(boot)
library(ralget)
library(raldag)
options(width = 120)

z <- v("z", .f = d(~ rnorm(n = 10^2, mean =  rsum(.x), sd = 1)))
x <- v("x", .f = d(~ rnorm(n = 10^2, mean =  rsum(.x), sd = 1)))
y <- v("y", .f = d(~ rnorm(n = 10^2, mean =  rsum(.x), sd = 1)))

g <- (z * b(1) + x * b(1)) * y +
     (z * b(1) * x)

t1 <- v("t1", .f = d(~ rnorm(n = 10^3, mean = rsum(.x), sd =  1)))
t2 <- v("t2", .f = d(~ rnorm(n = 10^3, mean = rsum(.x), sd =  1)))
t3 <- v("t3", .f = d(~ rnorm(n = 10^3, mean = rsum(.x), sd =  1)))
t4 <- v("t4", .f = d(~ rnorm(n = 10^3, mean = rsum(.x), sd =  1)))
t5 <- v("t5", .f = d(~ rnorm(n = 10^3, mean = rsum(.x), sd =  1)))

t <- (t1 * b(1) * t2) + (t2 * b(1) * t3) +
     (t3 * b(1) * t4) + (t4 * b(1) * t5)

xt <- cartesian_product(g,t,node_combine =  ~ c(.x), edge_combine =  ~ c(.x,.y))

z_t2_0 <- xt %>% manipulate(z_t2 = 0) %>% simulate(label = "z_t2 = 0",seed = 2)
z_t2_1 <- xt %>% manipulate(z_t2 = 1) %>% simulate(label = "z_t2 = 1",seed = 2)

bind_rows(z_t2_0,z_t2_1) %>%
mutate(sim_id = row_number()) %>%
gather(var,val, -sim_id, -label)  %>%
separate(var, c("var", "period"), sep = "_") %>%
mutate(period  = period %>% str_remove("t") %>% as.numeric()) %>%
ggplot(aes(x = period, y = val, group = sim_id, color = label)) + geom_line(alpha = .075) + 
facet_wrap(~var, scales = "free") +  
stat_summary(aes(group = label),fun=mean,geom="line", size = 1)  +
theme_bw()
