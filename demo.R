rm(list = ls())
library(devtools)

document()
install()
test()
check()
usethis::use_pkgdown()
library(usethis)

usethis::use_pkgdown_github_pages()

library(tidyverse)
library(tidygraph)
library(ggraph)
library(dagitty)
library(patchwork)
library(igraph)
library(ggdag)
library(magrittr)
library(ralget)
library(raldag)

# Test ----------------------------------------------------
circle <- v("a") * v("b") * v("c")
line <- v("1")*v("2")*v("3")

as_tibble(circle %x% line) %>% pull(name)
as_tibble(activate(circle %x% line,"edges"))

a <- v("a")
b <- v("b")
c <- v("c")
d <- v("d")

g <-
  (a * b(9) + m * b(1)) * x +
  (c * b(2) + m * b(5)) * y +
  (a * b(3) + c * b(5)) * m

g %>% evaluate_prepare() %>% evaluate_execute()


h <- (m * b(2) + x * b(1)) * y
h %>% evaluate_prepare() %>% evaluate_execute()


q <- (m * b(2) + x * b(1)) * y  +  ( y * b(2)*c)
q %>% evaluate_prepare() %>% filter(row_number() == 1) %>% evaluate_execute()
q %>% evaluate_prepare() %>% filter(row_number() <= 2) %>% evaluate_execute()
q %>% evaluate_prepare() %>% evaluate_execute()


# Raldag

c <- v("c", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 10, sd =  4)))
a <- v("a", .f = d(~ rnorm(n = 10^4, mean = rsum(.x)     , sd =  1)))
x <- v("x", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 30, sd =  4)))
y <- v("y", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) +  7, sd =  2)))
m <- v("m", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 40, sd =  2)))


t1 <- v("t1", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))
t2 <- v("t2", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))
t3 <- v("t3", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))
t4 <- v("t4", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))
t5 <- v("t5", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))

t <-
(t1 * b(1) * t2) +
(t2 * b(1) * t3) +
(t3 * b(1) * t4) +
(t4 * b(1) * t5)

g <-
 (a * b(9) + m * b(1)) * x +
 (c * b(2) + m * b(5)) * y +
 (a * b(3) + c * b(5)) * m

xt <- cartesian_product(g,t,node_combine =  ~ c(.x,.y), edge_combine =  ~ c(.x,.y))

xt %>% activate("edges") %>% mutate(daggity_text= paste0(from_name, " -> ",to_name)) %>%
pull(daggity_text) %>% paste(collapse = "\n") %>% paste("dag {",.,"}") %>% dagitty::dagitty() %>%
tidy_dagitty() %>%
ggdag(.) +
  theme_dag()


xtc <-
xt %>%
    select(-.attrs.y) %>%
    activate("edges") %>%
    mutate(.attrs = map2(.attrs,.attrs.y, ~ c(.x,.y))) %>%
    select(-.attrs.y) %>%
    activate("nodes")  %>%
    get_edge_names() %>%
    activate("nodes")  %>%
    filter(!is.na(x_src))

xtc %>% evaluate_prepare() %>% pull(.attrs)
xtc %>% simulate()



