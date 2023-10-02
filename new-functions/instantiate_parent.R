

#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export
#' 
instantiate_parent <-function(task){
     .attrs_new <- task %>% pull(.attrs) %>% .[[1]] %>% keep(~ !typeof(.) == "closure") %>% c(.,"intantiated")

    task %>% mutate(.attrs = list(.attrs_new))

}