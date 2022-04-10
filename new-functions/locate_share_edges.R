locate_share_edges <- 
function(shared_edge, vl, vr){
  # browser()
  # shared_edge  <- shared_edges[[1]]
  
  vr_matches <- pull(vr,.waiting_edge_left) %>% map( ~ unlist(.x) %in% unlist(shared_edge))
  vl_matches <- pull(vl,.waiting_edge_right) %>% map( ~ unlist(.x) %in% unlist(shared_edge))
  
  vr_filter <- map_lgl(vr_matches,any) 
  vl_filter <- map_lgl(vl_matches,any) 
  
  vr_matched_edges <-  vr_matches %>% keep(any)
  vl_matched_edges <-  vl_matches %>% keep(any)
  
  shared_on_right <- vr %>% filter(vr_filter) %>% select(-.waiting_edge_left)
  
  shared_on_left <- vl %>% filter(vl_filter) %>% select(-.waiting_edge_right)
  
  list(graph = (shared_on_left  * shared_edge * shared_on_right), vr_matches = vr_matches, vl_matches = vl_matches)
}