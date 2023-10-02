
#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

instantiate <- function(task){
  # browser()
    deps <- task %>% pull(.attrs) %>% .[[1]]  %>%  keep(~ any(c("once", "after") %in% class(.))) 

    if(length(deps)==0){return(instantiate_parent(task))}

    task %>% pull(.attrs) %>% .[[1]] %>% keep(~ any(c("once", "after") %in% class(.))) %>% map(~ .x("intantiated") ) %>%
    reduce(`+`) * instantiate_parent(task)
}
