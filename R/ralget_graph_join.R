
ralget_graph_join <- function(g2, g1){
 # browser()
  # 
  shared_edges_g2g1 <- list() 
  shared_edges_g1g2 <- list() 
 
# Check whether there are any waiting edges ---------------------------------
  
 if(((".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes")))) & 
      (".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes"))))) |
   (((".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes")))) & 
    (".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes"))))))){  
  
  
# Get share edges for  g2->g1 ---------------------------------
if(((".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes")))) & 
  (".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes")))))){
  g1_edges_l <- pull(g1 ,.waiting_edge_left) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x)  %>%  flatten  %>% keep(~ .x[["name"]] != ".tmp")
  g2_edges_r <- pull(g2 ,.waiting_edge_right) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x) %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
  shared_edges_g2g1 <- append(g1_edges_l[g1_edges_l %in% g2_edges_r] , g2_edges_r[g2_edges_r %in% g1_edges_l]) %>% unique()
} 
   
# Get share edges for  g1->g2 ---------------------------------
   
if(((".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes")))) & 
   (".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes")))))){
 g1_edges_r <- pull(g1 ,.waiting_edge_right) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x)  %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
 g2_edges_l <- pull(g2 ,.waiting_edge_left) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x)  %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
 shared_edges_g1g2 <- append(g1_edges_r[g1_edges_r %in% g2_edges_l] , g2_edges_l[g2_edges_l %in% g1_edges_r]) %>% unique()
}
   
# If no shared edges, standard graph join ------------------------------------
if(length(shared_edges_g1g2) ==0 & length(shared_edges_g2g1) == 0 ){
  return_graph <- tidygraph::graph_join(g1, g2) 
  return(return_graph)
}
   
# Get shared edges and their locations ---------------------------------------- 
 
 edge_checks_g2g1 <- list()
 edge_checks_g1g2 <- list()
# g2->g1
if(shared_edges_g2g1 %>% keep(~ !is.null(.)) %>% length() %>% `>`(0)){
  edge_checks_g2g1 <- map(shared_edges_g2g1, locate_share_edges,g2 = g2, g1 =g1)
  
  new_joins_g2g1 <- edge_checks_g2g1 %>% map("graph") %>% reduce(tidygraph::graph_join)
  g1_edges_to_drop_g2g1 <-  map(edge_checks_g2g1,"g1_matches") %>% reduce(either)
  g2_edges_to_drop_g2g1 <-  map(edge_checks_g2g1,"g2_matches") %>% reduce(either)
}

# g1->g2
if(shared_edges_g1g2 %>% keep(~ !is.null(.)) %>% length() %>% `>`(0)){
  edge_checks_g1g2 <- map(shared_edges_g1g2, locate_share_edges,g2 = g1, g1 =g2) 
   
  new_joins_g1g2 <- edge_checks_g1g2 %>% map("graph") %>% reduce(tidygraph::graph_join) %>% select(-matches("^\\.waiting"))
  g1_edges_to_drop_g1g2 <-  map(edge_checks_g1g2,"g1_matches") %>% reduce(either)
  g2_edges_to_drop_g1g2 <-  map(edge_checks_g1g2,"g2_matches") %>% reduce(either)
 }

 g1_new <- g1
 g2_new <- g2
 
 
# If only shared in g1->g2, use those 
if(length(edge_checks_g2g1)==0 & length(edge_checks_g1g2)>0){
  new_joins <- new_joins_g1g2 
}
# If only shared in g2->g1 , use those 
if(length(edge_checks_g2g1)>0 & length(edge_checks_g1g2)==0){
  new_joins <- new_joins_g2g1
}
# Combine info from each direction 
 if(length(edge_checks_g2g1)>0 & length(edge_checks_g1g2)>0){
   new_joins <- tidygraph::graph_join(new_joins_g1g2, new_joins_g2g1) 
 }
 
 # Drop old waiting edges 
  # browser()
 #g1(left) g2(right)
if(length(shared_edges_g2g1)>0){
  g1_left_edges <- pull(g1_new,.waiting_edge_left)
  if(depth(g1_left_edges) ==2){g1_expanded_left <-T; g1_left_edges <- list(g1_left_edges)}
  g1_left_edges_to_remove <- map(g1_left_edges, ~ map_lgl(.x, ~ .x %in% shared_edges_g2g1))
  if(exists("g1_expanded_left")){g1_right_edges_to_remove <-  g1_right_edges_to_remove[[1]]}
  g1_left_edge_replacements <- map2(g1_left_edges,g1_left_edges_to_remove, ~ .x[!.y])
  g1_new <- g1_new %>% mutate(.waiting_edge_left = g1_left_edge_replacements)

  g2_right_edges <- pull(g2_new,.waiting_edge_right)
  if(depth(g2_right_edges) ==2){g2_expanded_right <- T ;g2_right_edges <- list(g2_right_edges)}
  g2_right_edges_to_remove <- map(g2_right_edges, ~ map(.x, ~ .x %in% shared_edges_g2g1))
  ##!!#! do same above
  if(exists("g2_expanded_right")){g2_right_edges_to_remove <-  g2_right_edges_to_remove[[1]]}
  g2_right_edge_replacements <- map2(g2_right_edges,g2_right_edges_to_remove, ~ .x[!.y])
  g2_new <- g2_new %>% mutate(.waiting_edge_right = g2_right_edge_replacements)
  
    
}
  

 #g2(left) g1(right)

if(length(shared_edges_g1g2)>0){
  g2_left_edges <- pull(g2_new,.waiting_edge_left)
  if(depth(g2_left_edges) ==2){g2_expanded_left <-T; g2_left_edges <- list(g2_left_edges)}
  g2_left_edges_to_remove <- map(g2_left_edges, ~ map_lgl(.x, ~ .x == shared_edges_g1g2))
  if(exists("g2_expanded_left")){g1_right_edges_to_remove <-  g1_right_edges_to_remove[[1]]}
  g2_left_edge_replacements <- map2(g2_left_edges,g2_left_edges_to_remove, ~ .x[!.y])
  g2_new <- g2_new %>% mutate(.waiting_edge_left = g2_left_edge_replacements)
  
  g1_right_edges <- pull(g1_new,.waiting_edge_right)
  if(depth(g1_right_edges) ==2){g1_expanded_right <- T ;g1_right_edges <- list(g1_right_edges)}
  g1_right_edges_to_remove <- map(g1_right_edges, ~ map(.x, ~ .x == shared_edges_g1g2)) 
  ##!!#! do same above
  if(exists("g1_expanded_right")){g1_right_edges_to_remove <-  g1_right_edges_to_remove[[1]]}
  g1_right_edge_replacements <- map2(g1_right_edges,g1_right_edges_to_remove, ~ .x[!.y])
  g1_new <- g1_new %>% mutate(.waiting_edge_right = g1_right_edge_replacements)  
} 


# Join graphs and return 
 
return_graph <- tidygraph::graph_join(g1_new, g2_new) %>% tidygraph::graph_join(.,new_joins) 

diagram(return_graph)

return(return_graph)

 
 }
  
return_graph <- tidygraph::graph_join(g1, g2) 

return(return_graph)
}



depth <- function(this,thisdepth=0){
  if(!is.list(this)){
    return(thisdepth)
  }else{
    return(max(unlist(lapply(this,depth,thisdepth=thisdepth+1))))    
  }
}