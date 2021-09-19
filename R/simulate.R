
#' Simulate data from a dag
#'
#' @param g a ralget DAG 
#' @param label the label associated with simulated data. 
#' @export
#' 
simulate <- function(g,label){ g %>% evaluate() %>% extract_data() %>% mutate(label = label)}