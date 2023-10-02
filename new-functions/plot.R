#' Set value for variable in DAG
#'
#' @param x ralget
#' @param ... other args
#' @export
#' @return ralget
#' @S3method  "+" ralget
#' 
#' 
plot.ralget <- function(x,...){

x %>% 
get_edge_names() %>%
activate("edges") %>% 
mutate(daggity_text= paste0(from_name, " -> ",to_name)) %>% 
pull(daggity_text) %>% paste(collapse = "\n") %>% paste("dag {",.,"}") %>% dagitty() %>%
tidy_dagitty() %>%
ggdag(.) +
  theme_dag()

}