rm(list = ls())

library(tidyverse)
library(tidygraph)
library(ggraph)
library(patchwork)
library(magrittr)
devtools::load_all()
devtools::document(); 3
devtools::build(); 3
devtools::install(); 3
library(ralget)
install.packages("vscDebugger")
library(devtools)
devtools::install_github("ManuelHentschel/vscDebugger")

product <- function(...){list(...) %>% reduce(`*`)}
b <- function(m){ e(.func = function(.value){.value * m})}
const <- function(x){function(...){x}}
increment_t <- function(g, t = 1){
  g %>% 
  mutate(name = 
    str_extract(name,"[0-9]+$") %>% as.numeric() %>% `+`(t) %>% 
    as.character() %>% str_pad(2,"left", "0") %>% 
    str_remove("NA") %>% 
    paste0(str_remove(name,"[0-9]+$"),.) %>% str_remove("NA"))
}

Y <-  v("Y",    .func = function(...){rnorm(10,sum(...) + 100, 10)})
X1 <- v("X1",   .func = function(...){rnorm(10,sum(...) + 100, 10)})
X2 <- v("X2",   .func = function(...){rnorm(10,sum(...) + 100, 10)})

g <- X1*b(2)*Y + X2*b(2)*Y

g %>% ggraph() + geom_edge_link() + geom_node_point()

gp <- g %>% evaluate_prepare()
ge <- gp %>% evaluate_execute()

ge %>% pull(eval_statement)



Y_01 <-  v("Y_01",    .func = function(...){rnorm(10,sum(...) + 100, 10)})
X1_01 <- v("X1_01",   .func = function(...){rnorm(10,sum(...) + 100, 10)})
X2_01 <- v("X2_01",   .func = function(...){rnorm(10,sum(...) + 100, 10)})



g <- X1*b(2)*Y + (X2*b(2)*Y)

t <- (v("t1")*v("t2")) +
     (v("t2")*v("t3")) + 
     (v("t3")*v("t4")) + 
     (v("t4")*v("t5"))

l <- g %x% t
l
plot(g %x% t)

lt <- 
l %>% 
mutate(.attrs = purrr::map(1, ~ list(.func = function(...){rnorm(10,sum(...) + 100, 10)}))) %>%
activate("edges") %>%
mutate(.attrs = purrr::map(1, ~ b(1)))  %>%
activate("nodes") %>% get_edge_names() %>% 
activate("nodes") 

lt %>% evaluate() %>% pull(eval_statement)



