
#' Add two ralget graphs
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget
#' @export


to_json <- function(g){
  #convert graph into a list


  g <- g %>% ralget::compact() 
  graph <- list()
  graph$edges <- as_data_frame(g, what = "edges")
  graph$vertices <- as_data_frame(g, what="vertices")
  # polish vertices
  row.names(graph$vertices) <- NULL
  if(ncol(graph$vertices)==0) graph$vertices <- NULL #in case the 
  
  graph$directed <- is.directed(g)
  graph$name <- g$name
  #convert list into a json
  json.content <- toJSON(graph)
  #return the json in case you need it
  return(json.content)
}