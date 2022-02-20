
ralget_graph_join <- function(g2, g1){
 # browser()
  
  shared_edges_g2g1 <- list() 
  shared_edges_g1g2 <- list() 
  
 if(((".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes")))) & 
      (".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes"))))) |
   (((".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes")))) & 
    (".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes"))))))){  
  
  
  
if(
  ((".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes")))) & 
  (".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes")))))){
  g1_edges_l <- pull(g1 ,.waiting_edge_left) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x)  %>%  flatten  %>% keep(~ .x[["name"]] != ".tmp")
  g2_edges_r <- pull(g2 ,.waiting_edge_right) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x) %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
  
  shared_edges_g2g1 <- append(g1_edges_l[g1_edges_l %in% g2_edges_r] , g2_edges_r[g2_edges_r %in% g1_edges_l]) %>% unique()
  
  
} 
if(((".waiting_edge_right" %in% names(as_tibble(activate(g2 ,"nodes")))) & 
   (".waiting_edge_left" %in% names(as_tibble(activate(g1 ,"nodes")))))){
  
 g1_edges_r <- pull(g1 ,.waiting_edge_right) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x)  %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
 g2_edges_l <- pull(g2 ,.waiting_edge_left) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + .x)  %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
 
 shared_edges_g1g2 <- append(g1_edges_r[g1_edges_r %in% g2_edges_l] , g2_edges_l[g2_edges_l %in% g1_edges_r]) %>% unique()

}
 

 either <- function(e1,e2){map2(e1,e2,~ map2_lgl(.x,.y,function(x,y)!(x|y)))}    
  
 edge_checks_g2g1 <- list()
 edge_checks_g1g2 <- list()
if(shared_edges_g2g1 %>% keep(~ !is.null(.)) %>% length() %>% `>`(0)){
  edge_checks_g2g1 <- map(shared_edges_g2g1, locate_share_edges,g2 = g2, g1 =g1)
}

 if(shared_edges_g1g2 %>% keep(~ !is.null(.)) %>% length() %>% `>`(0)){
   edge_checks_g1g2 <- map(shared_edges_g1g2, locate_share_edges,g2 = g1, g1 =g2) 
 }
 
 
if(length(edge_checks_g2g1)>0){
  new_joins_g2g1 <- edge_checks_g2g1 %>% map("graph") %>% reduce(tidygraph::graph_join)
  
  g1_edges_to_drop_g2g1 <-  map(edge_checks_g2g1,"g1_matches") %>% reduce(either)
  g2_edges_to_drop_g2g1 <-  map(edge_checks_g2g1,"g2_matches") %>% reduce(either)

}
if(length(edge_checks_g1g2)>0){
  new_joins_g1g2 <- edge_checks_g1g2 %>% map("graph") %>% reduce(tidygraph::graph_join)
  
  g1_edges_to_drop_g1g2 <-  map(edge_checks_g1g2,"g1_matches") %>% reduce(either)
  g2_edges_to_drop_g1g2 <-  map(edge_checks_g1g2,"g2_matches") %>% reduce(either)
}

if(length(edge_checks_g2g1)>0 & length(edge_checks_g1g2)>0){
  new_joins <- tidygraph::graph_join(new_joins_g1g2, new_joins_g2g1)
  g1_edges_to_drop <- either(g1_edges_to_drop_g2g1,g2_edges_to_drop_g1g2)
  g2_edges_to_drop <- either(g2_edges_to_drop_g2g1,g2_edges_to_drop_g1g2)
}


if(length(edge_checks_g2g1)==0 & length(edge_checks_g1g2)>0){
  new_joins <- new_joins_g1g2
  g1_edges_to_drop <- g2_edges_to_drop_g1g2
  g2_edges_to_drop <- g2_edges_to_drop_g1g2
}

if(length(edge_checks_g2g1)>0 & length(edge_checks_g1g2)==0){
  new_joins <- new_joins_g2g1
  g1_edges_to_drop <- g1_edges_to_drop_g2g1
  g2_edges_to_drop <- g2_edges_to_drop_g2g1
  
}

 g1_new <- g1
 g2_new <- g2

 if(exists("g1_edges_to_drop")){
   g1_new <- g1 %>% mutate(.waiting_edge_left  = map2(.waiting_edge_left,  g1_edges_to_drop, ~ .x[.y]))
 } 
 if(exists("g2_edges_to_drop")){
    g2_new <- g2 %>% mutate(.waiting_edge_right = map2(.waiting_edge_right, g2_edges_to_drop, ~ .x[.y]))
 } 
 

return_graph <- tidygraph::graph_join(g1_new, g2_new) %>% tidygraph::graph_join(.,new_joins) 

# diagram(return_graph) 
return(return_graph)
 
 }
  
return_graph <- tidygraph::graph_join(g1, g2) 

return(return_graph)
}


