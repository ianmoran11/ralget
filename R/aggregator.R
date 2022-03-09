
aggregator <-  function(edges){
 # browser() 
  
 remaing_edges <- edges %>% keep(~ !is.null(.)) 
 
 if(length(remaing_edges) == 0){return(list(NULL))}
 
 list(remaing_edges %>% reduce(`+`) )
}