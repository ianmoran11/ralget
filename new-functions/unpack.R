unpack <- function(graph, cluster = FALSE){
  
  graph <- graph %>%  pack("test")
  
    output_graph <- graph %>% pull(.attrs) %>% map(".graph") %>% .[[1]]
    
  if(cluster == FALSE) {
    return(output_graph)
  }
  
  if(!(".cluster" %in% names(as_tibble(activate(output_graph,"nodes"))))){
    output_graph <- output_graph %>% mutate(.cluster = map(row_number(),~ NULL))
  } 
    
  if(cluster == TRUE) {
    output_graph <- output_graph %>% mutate(.cluster = map(.cluster,~ append(.x,pull(graph,name)))) 
    return(output_graph)
  }
    
  output_graph <- output_graph %>% mutate(.cluster = map(.cluster,~ append(.x,cluster))) 
   return(output_graph)
  
}