
rm(list = ls())

library(tidyverse)
library(tidygraph)
library(ggraph)
library(patchwork)
library(magrittr)
devtools::document(); 3
devtools::build(); 3
devtools::install(); 3
library(ralget)

product <- function(...){list(...) %>% reduce(`*`)}
m <- function(m){ e(.func = function(.value){.value * m})}
const <- function(x){function(...){x}}
increment_t <- function(g, t = 1){
  g %>% 
  mutate(name = 
    str_extract(name,"[0-9]+$") %>% as.numeric() %>% `+`(t) %>% 
    as.character() %>% str_pad(2,"left", "0") %>% 
    str_remove("NA") %>% 
    paste0(str_remove(name,"[0-9]+$"),.) %>% str_remove("NA"))
}

Sj00 <-   v("Sj00",   .func = const(10000))
Si00 <-   v("Si00",   .func = const(1000))
SiT00 <- v("SiT00",   .func = sum)
SjT00 <- v("SjT00",   .func = sum)

Sj01 <-   v("Sj01",   .func = sum)
Si01 <-   v("Si01",   .func = sum)
SjT01 <- v("SjT01",   .func = sum)
SiT01 <- v("SiT01",   .func = sum)

Sj02 <-   v("Sj02",   .func = sum)
Si02 <-   v("Si02",   .func = sum)
SjT02 <- v("SjT02",   .func = sum)
SiT02 <- v("SiT02",   .func = sum)

g0 <- 
(Sj00 * m(1) * Sj01) +
(Si00 * m(1) * Si01)

g <- 
# Inertia 
  (Sj01 * m(1) * Sj02)  + 
  (Si01 * m(1) * Si02)  + 
# Transfer amounts
  (Sj01 * m(.1) * SjT01)  +
  (Si01 * m(.1) * SiT01)  +
# Transfer addition
  (SjT01 * m(1) * Si02)  +
  (SiT01 * m(1) * Sj02) +
# Transfer subtraction
  (SjT01 * m(-1) * Sj02)  +
  (SiT01 * m(-1) * Si02)  

plot(g)
plot(increment_t(g,1))

plot(g0 + g + increment_t(g,1) + increment_t(g,2))
evaluate(g0 + g + increment_t(g,1) + increment_t(g,2)) %>% pull(eval_statement)

plot(g + increment_t(g,1) + increment_t(g,1))

plot(g + increment_t(g,1) + increment_t(g,2))


evaluate(g) %>% pull(eval_statement)



