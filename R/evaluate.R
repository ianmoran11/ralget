 
#' Evaluate a graph where nodes and edges store functions.
#'
#' @param g ralget
#' @export
 
evaluate <- function(g){
g %>% 
mutate(order = node_topo_order())  %>%
 arrange(order) %>% 
 mutate(edge_funcs = map(row_number(), ~ .E()[.E() %>% pull(to) == .x,] %>% pull(.attrs) )) %>% 
 mutate(edge_args = map(row_number(), ~ .E()[.E() %>% pull(to) == .x,] %>% pull(from_name) )) %>%
 mutate(eval_statement = pmap_dbl(  
    list(name = name,.attrs = .attrs, edge_funcs= edge_funcs,edge_args= edge_args), 
     .f = function(...){
        wk <- list(...)
        assign(
            x = wk$name,
            value =  
                do.call(
                    wk$.attrs$.func, 
                    map2(wk$edge_funcs,wk$edge_args, ~ do.call(.x[[1]], list(sym(.y))))
                    ),
            envir = .GlobalEnv)
            }
    )
) 
}
