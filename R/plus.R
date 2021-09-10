
#' Add two ralget graphs
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget
#' @export
#' @S3method  "+" ralget

`+.ralget` <- function(v1,v2){
  plus(v1,v2)
}

#' Add two ralget graphs - original
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget

plus <-  function(v1,v2){
  # browser()

  if(is.null(v1)){ return(v2)}
  if(is.null(v2)){ return(v1)}

  tidygraph::graph_join(v1, v2)

}
