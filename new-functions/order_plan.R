#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

order_plan <- function(plan){

plan %>%        
    get_edge_names() %>% 
    activate("nodes") %>% 
    mutate(order = node_topo_order()) %>% arrange(order) %>%
    mutate(priority = map_dbl(.attrs, "priority")) %>%
    mutate(time = map(.attrs, "time")) %>%
    mutate(resources = map(.attrs, "resources")) %>%
    mutate(executed = FALSE) 
}