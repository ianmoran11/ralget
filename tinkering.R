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

B <- v("B")
G <- v("G")

SIR <- 
S01    * (BIS01 + S02) +
I01    * (GI01  + BIS01 +  I02) +
R01    * (GI01  + R02) +
BIS01  * (S02   + I02) +
GI01   * (I02   + R02) +
B      * (BIS01) + 
G      * (GI01)


SIR <- 
S01    * ( e(1) * BIS01  + e(1)  * S02                  ) +
I01    * ( e(1) * GI01   + e(1)  * BIS01  +  e(1) * I02 ) +
R01    * ( e(1) * GI01   + e(1)  * R02                  ) +
BIS01  * ( e(-1) * S02    + e(1) * I02                  ) +
GI01   * ( e(-1) * I02    + e(1) * R02                  ) +
B      * ( e(.1/1010) * BIS01                                ) + 
G      * ( e(.1/1010) * GI01                                 )

plot(SIR)

ralget_sim_2 <- function(graph, n = 1){
  intermediate <- 
    graph  %>% mutate(form = map_chr(row_number(), 
    ~ filter(.E(), to == .x) %>% as_tibble() %>% mutate(out = paste(.attrs, from_name, sep = "*"))  %>% 
    pull(out) %>% paste(collapse = " * ")
    # mutate(form = map2(from_name, .attr, ~paste(.x,.y[[1]],sep ="*"))
    )) %>%
    mutate(init = map_chr(.attrs, ~ .x %>% as.character() %>%  str_remove("~"))) %>%
    mutate(expr = paste(init, form, sep = "+") %>% str_remove("\\+$")) %>%
    mutate(mu = paste0(name," = ", expr)) %>%
    mutate(mu2= paste0(name," = ", "rep(NA,",n,")")) %>%
    mutate(order = node_topo_order())  %>%
    as_tibble() %>%
    arrange(order)  

 intermediate

  #render(intermediate$mu2,intermediate$mu,n) %>% paste(collapse = "\n") %>% parse(text = .) %>% eval()
}

SIR %>% as_tibble() %>% print(n = Inf)
plot(SIR)
plot(increment_t(SIR, 0:1))

increment_t <- function(g, t = 1){
  g %>% 
  mutate(name = 
    str_extract(name,"[0-9]+$") %>% as.numeric() %>% `+`(t) %>% 
    as.character() %>% str_pad(2,"left", "0") %>% 
    str_remove("NA") %>% 
    paste0(str_remove(name,"[0-9]+$"),.) %>% str_remove("NA"))
}

SIRT <- map(0:5, increment_t, g = SIR) %>% reduce(`+`)

SIRT %>% as_tibble() %>% print(n = Inf)
plot(SIRT)

SIRT <- 
SIRT %>% 
 mutate(param = case_when( 
    name == "S01" ~ 1000, 
    name == "I01" ~  10 ,  
    name == "R01" ~  0  , 
    T ~ 1
 )) %>% 
mutate(.attrs = map(param, ~ list(form = paste0("~rnorm(1,", .x,",0)"))))

ralget_sim_2(SIRT %>% get_edge_names %>% activate("nodes"), n = 1) %>% 
pull(form)

gather() %>% 
mutate(period = str_extract(key,"[0-9]+"))  %>%
mutate(key = str_remove(key,"[0-9]+")) %>% 
filter(!key %in% c("BNA","GNA" ) ) %>% 
spread(key, value)

1000 

write.csv("output.csv")


















