
ralget_graph_join <- function(g2, g1){
 browser()
  
 shared_edges <- list() 
  
if(
  (".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes")))) & 
  (".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes")))) ){
  
# g2 <- g1 
 g1_edges <- pull(g1 ,.waiting_edge_left) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x)  %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
 g2_edges <- pull(g2 ,.waiting_edge_right) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x)  %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
  
 shared_edges <- 
   append(g1_edges[g1_edges %in% g2_edges] , 
          g2_edges[g2_edges %in% g1_edges]) %>% unique()
 
# g2 -> g1 
 
 
 
}
 
  
if(shared_edges %>% keep(~ !is.null(.)) %>% length() %>% `>`(0)){
  
edge_checks <-  
map(shared_edges,function(shared_edge){
  
 # shared_edge  <- shared_edges[[1]]

 g1_matches <- pull(g1,.waiting_edge_left) %>% map( ~ flatten(.x) %in% flatten(shared_edge))
 g2_matches <- pull(g2,.waiting_edge_right) %>% map( ~ flatten(.x) %in% flatten(shared_edge))

 g1_filter <- map_lgl(g1_matches,any) 
 g2_filter <- map_lgl(g2_matches,any) 

 g1_matched_edges <-  g1_matches %>% keep(any)
 g2_matched_edges <-  g2_matches %>% keep(any)

 shared_on_right <- g1 %>% filter(g1_filter) %>% select(-.waiting_edge_left)

 shared_on_left <- g2 %>% filter(g2_filter) %>% select(-.waiting_edge_right)
 
list(graph = (shared_on_left  * shared_edge * shared_on_right), g1_matches = g1_matches, g2_matches = g2_matches)
}) 

new_joins <- edge_checks %>% map("graph") %>% reduce(tidygraph::graph_join)

g1_edges_to_drop <- map2(map(edge_checks,"g1_matches")[[1]],map(edge_checks,"g1_matches")[[2]],~ map2_lgl(.x,.y,function(x,y)!(x|y)))
g2_edges_to_drop <- map2(map(edge_checks,"g2_matches")[[1]],map(edge_checks,"g2_matches")[[2]],~ map2_lgl(.x,.y,function(x,y)!(x|y)))

g1_new <- g1 %>% mutate(.waiting_edge_left = map2(.waiting_edge_left, g1_edges_to_drop, ~ .x[.y]))
g2_new <- g2 %>% mutate(.waiting_edge_right = map2(.waiting_edge_right, g2_edges_to_drop, ~ .x[.y]))

return_graph <- tidygraph::graph_join(g1_new, g2_new) %>% tidygraph::graph_join(.,new_joins) 

diagram(return_graph) 
return(return_graph)
 
 }
  
return_graph <- tidygraph::graph_join(g1, g2) 

return(return_graph)
}


