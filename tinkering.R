library(rlang)


# Evaluate locally ---------------------------------------------------
reg %>% 
  mutate(value = map_dbl(.attrs, ~ .x[[1]] %>%  eval_tidy)) %>% 
  mutate(order = node_topo_order()) %>% 
  mutate(starter = name == "z1") %>% 
  mutate(env = map_local_dbl(order = 1, .f = function(graph,node,neighborhood,...){
    node_df = as_tibble(graph) %>% filter(row_number()== node)

    neibours = neighborhood  %>% activate("edges") %>% get_edge_names() %>%
    filter(to_name == node_df$name) %>%
    mutate(value = map_dbl(from_name, ~ neighborhood %>% filter(name == .x) %>% pull(value))) %>%
    as_tibble() %>% unnest(.attrs) 

    value = sum(neibours$.attrs * neibours$value) + node_df$value

 #    list(node_df, neibours, value)
value
   })) 


# Compiler approach ---------------------------------------------------

S01 <- v("S01")
I01 <- v("I01")
R01 <- v("R01")
BIS01 <- v("BIS01")
GI01 <- v("GI01")

S02 <- v("S02")
I02 <- v("I02")
R02 <- v("R02")

SIR <- 
S01    * (BIS01 + S02) +
I01    * (GI01  + I02) +
R01    * (GI01  + R02) +
BIS01  * (S02   + I02) +
GI01   * (I02   + R02)

SIR <- activate(SIR, "edges") %>% mutate(.attrs = 1) %>% activate("nodes")

increment_t <- function(g, t = 1){
  g %>% 
  mutate(name = 
    str_extract(name,"[0-9]+$") %>% as.numeric() %>% `+`(t) %>% 
    as.character() %>% str_pad(2,"left", "0") %>% 
    paste0(str_remove(name,"[0-9]+$"),.)) 
}

SIRT <- map(1:5, increment_t, g = SIR) %>% reduce(`+`)

plot(SIRT)

SIRT <- SIRT %>% mutate(.attrs = map(row_number(), ~ list(form =  quo(rnorm(1,1,0)))))

ralget_sim(SIRT %>% get_edge_names %>% activate("nodes"), n = 100)
