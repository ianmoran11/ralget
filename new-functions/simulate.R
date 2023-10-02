
#' Simulate data from a dag
#'
#' @param g a ralget DAG 
#' @param label the label associated with simulated data. 
#' @param seed the label associated with simulated data. 
#' @export
#' 
simulate <- function(g,label = "simulation set", seed = NULL){ 

   if(!is.null(seed)){set.seed(seed)}

    g %>% evaluate() %>% extract_data() %>% mutate(label = label)
    
    }