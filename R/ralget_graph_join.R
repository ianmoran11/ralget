
ralget_graph_join <- function(g2, g1){
 # browser()
  
 shared_edges <- list() 
  
if(
  (".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes")))) & 
  (".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes")))) ){
 shared_edges <- pull(g1, .waiting_edge_left)[pull(g1, .waiting_edge_left) %in% pull(g2,.waiting_edge_right)]  
 }
  
if(shared_edges %>% keep(~ !is.null(.)) %>% length() %>% `>`(0)){
  
new_joins <-  
map(shared_edges,function(shared_edges){
shared_on_right <- 
g1 %>%
  mutate(matched = map_lgl(.waiting_edge_left, ~ .x == shared_edges)) %>% 
  filter(matched == TRUE)  %>% 
  select(-.waiting_edge_left, -matched)

shared_on_left <- 
g2 %>%
  mutate(matched = map_lgl(.waiting_edge_right, ~ .x == shared_edges)) %>% 
  filter(matched == TRUE)  %>% 
  select(-.waiting_edge_right, -matched)

(shared_on_left  * shared_edges * shared_on_right)
}) %>% reduce(`+`) 

g1_new <- 
g1 %>% mutate(.waiting_edge_left = 
map_if(pull(g1, .waiting_edge_left),
      pull(g1, .waiting_edge_left) %in% pull(g2,.waiting_edge_right),
      ~ NULL))
g2_new <- 
g2 %>% mutate(.waiting_edge_right = 
map_if(pull(g2, .waiting_edge_right),
      pull(g2, .waiting_edge_right) %in% pull(g1,.waiting_edge_left),
      ~ NULL))

return_graph <- tidygraph::graph_join(g1_new, g2_new) %>% tidygraph::graph_join(.,new_joins) 
 
return(return_graph)
 
 }
  
return_graph <- tidygraph::graph_join(g1, g2) 

return(return_graph)
}


