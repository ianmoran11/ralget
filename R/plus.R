
#' Add two ralget graphs
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget
#' @export
#' @S3method  "+" ralget_edge

`+.ralget_edge` <- function(v1,v2){
  if(is.null(v1)){return(v2)}
  if(is.null(v2)){return(v1)}
  overlay(v1,v2)
}

#' Add two ralget graphs
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget
#' @export
#' @S3method  "+" ralget

`+.ralget` <- function(v1,v2){
  overlay(v1,v2)
}

#' Add two ralget graphs - original
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget


overlay <-  function(v1,v2){

## (NULL + V) | (V + NULL) -> V1 ---
  if(is.null(v1)){ return(v2)}
  if(is.null(v2)){ return(v1)}

## ([E] + [E]) -> [E]  ---
  if(("ralget_edge_list" %in% class(v1)) & ("ralget_edge_list" %in% class(v2))){
            
    edge_list <- append(v1,v2)

    class(edge_list) <- c("ralget_edge_list", union(class(v1), class(v2)))

    return(edge_list)
  }

## ([E] + E) -> [E] ---
  if(("ralget_edge_list" %in% class(v1)) & ("ralget_edge" %in% class(v2))){
            
    edge_list <- append(v1,list(v2))

    class(edge_list) <- c("ralget_edge_list", union(class(v1), class(v2)))

    return(edge_list)
  }

## (E + [E]) -> [E]
  if(("ralget_edge" %in% class(v1)) & ("ralget_edge_list" %in% class(v2))){
            
    edge_list <- append(list(v1),v2)

    class(edge_list) <- c("ralget_edge_list", union(class(v1), class(v2)))

    return(edge_list)
  }

## (E + E) -> [E]
  if(("ralget_edge" %in% class(v1)) & ("ralget_edge" %in% class(v2))){
            
    edge_list <- append(list(v1),list(v2))

    class(edge_list) <- c("ralget_edge_list", union(class(v1), class(v2)))

    return(edge_list)
  }

## ([V] + [V]) -> [V]
suppressMessages(
  
  g <- ralget_graph_join(v1, v2)
)

  g

}
