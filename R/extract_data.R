#' Set value for variable in DAG
#'
#' @param g evaluated ralget graph
#' @export

extract_data <- function(g){
g %>% as_tibble() %>% unnest(eval_statement) %>%
group_by(name) %>% mutate(sim_id = row_number()) %>%
select(name, sim_id, value = eval_statement) %>%
spread(name, value)
}
