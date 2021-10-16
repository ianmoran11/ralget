library(devtools)
install("../raldag")
library("tidyverse")
library("ggdag")
library("tidygraph")
library("dagitty")
library("ggraph")
library("patchwork")
library("magrittr")
library("ggforce")
library("boot")
library("conflicted")
library("stringr")
library("stringr")
library("stringi")
library("purrr")
library(tidyverse)
conflict_prefer("filter", "dplyr")
load_all()
load_all("../raldag")

logit <- function(...)

z <- v("z", .f = d(~ rnorm(n = 10, mean =  rsum(.x), sd = 0)))
x <- v("x", .f = d(~ rnorm(n = 10, mean =  rsum(.x), sd = 0)))
y <- v("y", .f = d(~ rnorm(n = 10, mean =  rsum(.x), sd = 0)))

g <-
 (z * b(1) + x * b(1)) * y +
 (z * b(1)  * x)

t1 <- v("t1", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))
t2 <- v("t2", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))
t3 <- v("t3", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))
t4 <- v("t4", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))
t5 <- v("t5", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  0)))

t <-
(t1 * b(1) * t2) +
(t2 * b(1) * t3) +
(t3 * b(1) * t4) +
(t4 * b(1) * t5)


xt <- cartesian_product(g,t,node_combine =  ~ c(.x), edge_combine =  ~ c(.x,.y))

xt %>% plot()

xt %>% simulate() %>% glimpse()

xt %>% manipulate(z_t2 = 1) %>% simulate() %>% glimpse

xt %>% manipulate(z_t2 = 0) %>% simulate() %>% glimpse




xt %>% manipulate(z_t2 = 1) %>% simulate() %>% glimpse

simulate() %>% glimpse()

xt1 <-
xt %>%
activate("edges") %>%
mutate(.attrs = map(1, ~ list(.func = function (.value){.value * 1}))) %>%
activate("nodes")

evaluate_prepare() %>% pull(edge_funcs)

xt1 %>%
    manipulate(z_t1 = 0 ) %>%
    manipulate(z_t2 = 1 ) %>%
    simulate() %>%
    gather(var, value, -sim_id) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    mutate(value = as.numeric(value)) %>%
    ggplot(aes(x = period, y= value, group = sim_id)) +
    geom_line(alpha = .55) +
    facet_wrap(~var, scale = "free")

  treated <- xt %>%  manipulate(z_t1 = 0 ) %>% manipulate(z_t2 = 1 ) %>% simulate("treated",1)
untreated <- xt %>%  manipulate(z_t1 = 0 ) %>% manipulate(z_t2 = 0 ) %>% simulate("untreated",1)

bind_rows(treated,untreated) %>%
    gather(var, value, -sim_id, -label) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    mutate(value = as.numeric(value)) %>%
    ggplot(aes(x = period, y= value, group = label, color = label)) +
    # geom_point(alpha = .55) +
    facet_wrap(~var, scale = "free") +
    geom_smooth(alpha = .01) +
    theme_bw()


bind_rows(treated,untreated) %>%
    gather(var, value, -sim_id, -label) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    mutate(value = as.numeric(value)) %>%
    group_by(var,period,label) %>%
    summarise(value = mean(value)) %>%
    print(n = Inf)
    filter(var == "y") %>%
    ggplot(aes(x = period, y = value, color = label, group = label)) +
    geom_line()




bind_rows(treated,untreated) %>%
    gather(var, value, -sim_id, -label) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    mutate(value = as.numeric(value)) %>%
    spread(label ,value) %>% print(n = Inf)




bind_rows(treated,untreated) %>%
    gather(var, value, -sim_id, -label) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    mutate(value = as.numeric(value)) %>%
    group_by(var,period,label) %>%
    summarise(value = mean(value)) %>%
    spread(label ,value) %>%
    print(n = Inf)



ralget::get

temp <-
map(1:50, ~ v(paste0("v",.x))) %>%
reduce(`*`) %>%
get_edge_names() %>%
activate("nodes")

class(temp) <- class(temp)[-1]

plot(temp)
