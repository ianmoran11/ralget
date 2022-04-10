
#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export
 
ralget_graph_join <- function(vl, vr){
 # browser()
  
  shared_edges_vlvr <- list() 
  shared_edges_vrvl <- list() 
 
# Check whether there are any waiting edges ---------------------------------
  
 if(((".waiting_edge_left" %in% names(as_tibble(activate(vr ,"nodes")))) & 
      (".waiting_edge_right" %in% names(as_tibble(activate(vl ,"nodes"))))) |
   (((".waiting_edge_right" %in% names(as_tibble(activate(vl ,"nodes")))) & 
    (".waiting_edge_left" %in% names(as_tibble(activate(vr ,"nodes"))))))){  
  
  
# Get share edges for  vl->vr ---------------------------------
if(((".waiting_edge_left" %in% names(as_tibble(activate(vr ,"nodes")))) & 
  (".waiting_edge_right" %in% names(as_tibble(activate(vl ,"nodes")))))){
  vr_edges_l <- pull(vr ,.waiting_edge_left) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + e(name = ".tmp") +.x)  %>%  flatten  %>% keep(~ .x[["name"]] != ".tmp")
  vl_edges_r <- pull(vl ,.waiting_edge_right) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + e(name = ".tmp") +.x) %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
  shared_edges_vlvr <- append(vr_edges_l[vr_edges_l %in% vl_edges_r] , vl_edges_r[vl_edges_r %in% vr_edges_l]) %>% unique()
} 
   
# Get share edges for  vr->vl ---------------------------------
   
if(((".waiting_edge_right" %in% names(as_tibble(activate(vr ,"nodes")))) & 
   (".waiting_edge_left" %in% names(as_tibble(activate(vl ,"nodes")))))){
 vr_edges_r <- pull(vr ,.waiting_edge_right) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + e(name = ".tmp") + .x )  %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
 vl_edges_l <- pull(vl ,.waiting_edge_left) %>% map_if(~ !"ralget_edge_list" %in% class(.),~ e(name = ".tmp") + e(name = ".tmp") + .x)  %>% flatten %>% keep(~ .x[["name"]] != ".tmp")
 shared_edges_vrvl <- append(vr_edges_r[vr_edges_r %in% vl_edges_l] , vl_edges_l[vl_edges_l %in% vr_edges_r]) %>% unique()
}
   
# If no shared edges, standard graph join ------------------------------------
if(length(shared_edges_vrvl) ==0 & length(shared_edges_vlvr) == 0 ){
  return_graph <- tidygraph::graph_join(vr, vl) 
  return(return_graph)
}
   
# Get shared edges and their locations ---------------------------------------- 
 
 edge_checks_vlvr <- list()
 edge_checks_vrvl <- list()
# vl->vr
 
if(shared_edges_vlvr %>% keep(~ !is.null(.)) %>% length() %>% `>`(0)){
  edge_checks_vlvr <- map(shared_edges_vlvr, locate_share_edges,vl = vl, vr =vr)
  new_joins_vlvr <- edge_checks_vlvr %>% map("graph") %>% reduce(tidygraph::graph_join)
  new_joins_vlvr <- new_joins_vlvr %>% select(-matches(".waiting"))
  # diagram(new_joins_vlvr)
  vr_edges_to_drop_vlvr <-  map(edge_checks_vlvr,"vr_matches") %>% reduce(either)
  vl_edges_to_drop_vlvr <-  map(edge_checks_vlvr,"vl_matches") %>% reduce(either)
}

# vr->vl
 # browser()
if(shared_edges_vrvl %>% keep(~ !is.null(.)) %>% length() %>% `>`(0)){
  edge_checks_vrvl <- map(shared_edges_vrvl, locate_share_edges,vl = vr, vr =vl) 
  new_joins_vrvl <- edge_checks_vrvl %>% map("graph") %>% reduce(tidygraph::graph_join) %>% select(-matches("^\\.waiting"))
  new_joins_vrvl <- new_joins_vrvl %>% select(-matches(".waiting"))
  # diagram(new_joins_vrvl) 
  vr_edges_to_drop_vrvl <-  map(edge_checks_vrvl,"vr_matches") %>% reduce(either)
  vl_edges_to_drop_vrvl <-  map(edge_checks_vrvl,"vl_matches") %>% reduce(either)
 }

 vr_new <- vr
 vl_new <- vl
 
 
# If only shared in vr->vl, use those 
if(length(edge_checks_vlvr)==0 & length(edge_checks_vrvl)>0){
  new_joins <- new_joins_vrvl 
}
# If only shared in vl->vr , use those 
if(length(edge_checks_vlvr)>0 & length(edge_checks_vrvl)==0){
  new_joins <- new_joins_vlvr
}
# Combine info from each direction 
 if(length(edge_checks_vlvr)>0 & length(edge_checks_vrvl)>0){
   new_joins <- tidygraph::graph_join(new_joins_vrvl, new_joins_vlvr) 
 }
 
 # Drop old waiting edges 
  # browser()
 #vr(left) vl(right)
if(length(shared_edges_vlvr)>0){
  vr_left_edges <- pull(vr_new,.waiting_edge_left)
   # vr_left_edges %>% list.tree
  if(depth(vr_left_edges) ==2 & length(vr_left_edges) ==1){vr_expanded_left <-T; vr_left_edges <- list(vr_left_edges)}
   # vr_left_edges %>% list.tree
  vr_left_edges_to_remove <- map(vr_left_edges, ~ map_lgl(.x, ~ (unlist(.x) %in% unlist(shared_edges_vlvr)) %>% ifelse(length(.) ==0, T, .)))
  # vr_left_edges_to_remove %>% list.tree()
  if(exists("vr_expanded_left")){vr_left_edges_to_remove <-  vr_left_edges_to_remove[[1]]}
   # vr_left_edges_to_remove %>% list.tree 
  vr_left_edge_replacements <- map2(vr_left_edges,vr_left_edges_to_remove, ~ .x[!.y])
  vr_new <- vr_new %>% mutate(.waiting_edge_left = vr_left_edge_replacements)
  
  vl_right_edges <- pull(vl_new,.waiting_edge_right)
  # vl_right_edges %>% list.tree
  # pass on similar change
  if(depth(vl_right_edges) ==2 & length(vl_right_edges) == 1){vl_expanded_right <- T ;vl_right_edges <- list(vl_right_edges)}
  # vl_right_edges %>% list.tree()
  vl_right_edges_to_remove <- map(vl_right_edges, ~ map_lgl(.x,~ (unlist(.x) %in% unlist(shared_edges_vlvr))  %>% ifelse(length(.) ==0, T, .)))
  # vl_right_edges_to_remove %>% list.tree()
  ##!!#! do same above
  if(exists("vl_expanded_right")){vl_right_edges_to_remove <-  vl_right_edges_to_remove[[1]]}
  vl_right_edge_replacements <- map2(vl_right_edges,vl_right_edges_to_remove, ~ .x[!.y])
  # vl_right_edge_replacements %>% list.tree()
  vl_new <- vl_new %>% mutate(.waiting_edge_right = vl_right_edge_replacements)
    
}
  
 #vl(left) vr(right)
# browser()
if(length(shared_edges_vrvl)>0){
  vl_left_edges <- pull(vl_new,.waiting_edge_left)
  if(depth(vl_left_edges) ==2 & length(vl_left_edges) == 1){vl_expanded_left <-T; vl_left_edges <- list(vl_left_edges)}
  vl_left_edges_to_remove <- map(vl_left_edges, ~ map_lgl(.x, ~ (unlist(.x) %in% unlist(shared_edges_vrvl)) %>% ifelse(length(.) ==0, T, .)))  
  if(exists("vl_expanded_left")){vl_left_edges_to_remove <-  vl_left_edges_to_remove[[1]]}
  vl_left_edge_replacements <- map2(vl_left_edges,vl_left_edges_to_remove, ~ .x[!.y])
  vl_new <- vl_new %>% mutate(.waiting_edge_left = vl_left_edge_replacements)
  
  vr_right_edges <- pull(vr_new,.waiting_edge_right)
  if(depth(vr_right_edges) ==2 & length(vr_right_edges) ==1){vr_expanded_right <- T ;vr_right_edges <- list(vr_right_edges)}
  vr_right_edges_to_remove <- map(vr_right_edges, ~ map_lgl(.x, ~ (unlist(.x) %in% unlist(shared_edges_vrvl)) %>% ifelse(length(.) ==0, T, .)))
  ##!!#! do same above
  if(exists("vr_expanded_right")){vr_right_edges_to_remove <-  vr_right_edges_to_remove[[1]]}
  vr_right_edge_replacements <- map2(vr_right_edges,vr_right_edges_to_remove, ~ .x[!.y])
  vr_new <- vr_new %>% mutate(.waiting_edge_right = vr_right_edge_replacements)  
} 

 # browser()

vr_new <- vr_new %>% mutate_at(.vars = vars(matches("^\\.waiting")), .funs = ~ map(., ~ if(length(.x)==0){NULL}else{.}))
vl_new <- vl_new %>% mutate_at(.vars = vars(matches("^\\.waiting")), .funs = ~ map(., ~ if(length(.x)==0){NULL}else{.}))
 
# Join graphs and return 
# diagram(vr_new)
# diagram(vl_new)
# diagram(new_joins)


return_graph <- tidygraph::graph_join(vr_new, vl_new) %>% tidygraph::graph_join(.,new_joins) 


waiting_vars <- return_graph %>% as_tibble() %>% names() %>% keep(~ str_detect(.,"^.waiting"))

if(".waiting_edge_left" %in% waiting_vars){
  wleft <- return_graph %>% pull(.waiting_edge_left)
  wleft_new <- map_if(wleft,map_lgl(wleft,~! any(str_detect(class(.x),"ralget"))), function(.x){ if(length(.x) == 0){return(NULL)}else{.x %>% reduce(`+`)}}) 
  return_graph <- return_graph %>% mutate(.waiting_edge_left = wleft_new)
}

if(".waiting_edge_right" %in% waiting_vars){
wright <- return_graph %>% pull(.waiting_edge_right)
wright_new <- map_if(wright,map_lgl(wright,~! any(str_detect(class(.x),"ralget"))), function(.x){ if(length(.x) == 0){return(NULL)}else{.x %>% reduce(`+`)}}) 
return_graph <- return_graph %>% mutate(.waiting_edge_right = wright_new)  
} 

return_graph <- return_graph %>% mutate_at(.vars = vars(waiting_vars), .funs =  ~ map_if(.x,is.character,.f = function(x)e(x)))
return(return_graph)
 
 }
  
return_graph <- tidygraph::graph_join(vr, vl) 
return(return_graph)
}



depth <- function(this,thisdepth=0){
  if(!is.list(this)){
    return(thisdepth)
  }else{
    return(max(unlist(lapply(this,depth,thisdepth=thisdepth+1))))    
  }
}