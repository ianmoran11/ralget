locate_share_edges <- 
function(shared_edge, g2, g1){
  
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
}