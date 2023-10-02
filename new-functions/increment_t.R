#' Set value for variable in DAG
#'
#' @param g evaluated ralget graph with nodes ending in numbers that represent time periods
#' @param t number of periods to move the dag forward
#' @export
 
increment_t <- function(g, t = 1){
  g %>% 
  mutate(name = 
    str_extract(name,"[0-9]+$") %>% as.numeric() %>% `+`(t) %>% 
    as.character() %>% str_pad(2,"left", "0") %>% 
    str_remove("NA") %>% 
    paste0(str_remove(name,"[0-9]+$"),.) %>% str_remove("NA"))
}