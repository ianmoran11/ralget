
#' Cartesian product of two ralgets
#'
#' @param x ralget graph
#' @param y ralget graph
#' @export

aggregator <-  function(edges){
 # browser() 
  
 remaing_edges <- edges %>% keep(~ !is.null(.)) 
 
 if(length(remaing_edges) == 0){return(list(NULL))}
 
 list(remaing_edges %>% reduce(`+`) )
}