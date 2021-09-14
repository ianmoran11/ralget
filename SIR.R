rm(list = ls())

library(tidyverse)
library(tidygraph)
library(ggraph)
library(patchwork)
library(magrittr)
# devtools::document(); 3
# devtools::build(); 3
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

S00 <-   v("S00",   .func = const(10000))
I00 <-   v("I00",   .func = const(10))
R00 <-   v("R00",   .func = const(0))
S01 <-   v("S01",   .func = sum)
I01 <-   v("I01",   .func = sum)
R01 <-   v("R01",   .func = sum)
BIS01 <- v("BIS01", .func = product)
GI01  <- v("GI01",  .func = product)
S02 <-   v("S02",   .func = sum)
I02 <-   v("I02",   .func = sum)
R02 <-   v("R02",   .func = sum)
B <- v("B", .func = const(.3/10010))
G <- v("G", .func = const(500/10010))

SIR0 <-
S00 * m(1) * S01 + 
I00 * m(1) * I01 + 
R00 * m(1) * R01 

SIR <- 
S01   * (m(1) * BIS01 + m(1)  * S02 ) +
I01   * (m(1) * BIS01 + m(1)  * I02 + m(1)*GI01 )  +
R01   * (m(1) * R02                 )  +
BIS01 * (m(-1) * S02   + m(1)  * I02 ) + 
GI01  * (m(-1) * I02   + m(1) *  R02 )  +
B     * (m(1) * BIS01) +
G     * (m(1) * GI01)

plot(SIR0 + SIR)

SIR_FULL <- 
    SIR0 + 
    SIR + 
    map(1:150,~ increment_t(SIR,.x)) %>% reduce(`+`)

A <- 
SIR_FULL %>% get_edge_names() %>% activate("nodes") %>% evaluate() %>%
mutate(r = map_dbl(eval_statement, ~ .x)) %>% 
as_tibble() %>% 
select(name, r) %>% 
mutate(t = str_extract(name, "[0-9]+")) %>% 
mutate(name = str_remove(name, "[0-9]+")) %>% 
spread(name,r)

A %>% gather(key,value, -t) %>% 
ggplot(aes(x = as.numeric(t),y = value, color = key )) + 
geom_line() + 
geom_point()

