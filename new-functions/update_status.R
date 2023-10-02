
#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

update_status <- function(formed_plan_01){
    formed_plan_01 %>%
    filter(executed == F) %>%
    mutate(outstanding_deps = map_lgl(name,function(node_name) {
        .E() %>% filter(to_name == node_name) %>% pull(to_name) -> deps
        .N() %>% filter(name %in% deps) %>% pull(executed) %>% `==`(F) %>% any
    })) 
}
