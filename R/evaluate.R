 
#' Evaluate a graph where nodes and edges store functions.
#'
#' @param g ralget
#' @export
#' @examples
#' \dontrun{
#'
#'  product <- function(...){list(...) %>% reduce(`*`)}
#'  const <- function(x){function(...){x}}
#'  
#'  S01 <-   v("S01",   .func = const(10000))
#'  I01 <-   v("I01",   .func = const(10))
#'  BIS01 <- v("BIS01", .func = product)
#'  
#'  S02 <-   v("S02",   .func = sum)
#'  I02 <-   v("I02",   .func = sum)
#'  
#'  SIR <- 
#'  S01    * ( e(.func = function(.value){.value * .5} ) * BIS01  + 
#'             e(.func = function(.value){.value * 1} )  * S02 ) +
#'  
#'  I01    * ( e(.func = function(.value){.value * 1} ) * BIS01  +
#'             e(.func = function(.value){.value * 1}) * I02 )  +
#'  
#'  BIS01  *  (e(.func = function(.value){.value * 1} ) * S02  +
#'             e(.func = function(.value){.value * -2}) *  I02 ) 
#'  
#'  evaluate(SIR)
#' }


evaluate <- function(g){
g %>% 
mutate(order = node_topo_order())  %>%
 arrange(order) %>% 
 mutate(edge_funcs = map(row_number(), ~ .E()[.E() %>% pull(to) == .x,] %>% pull(.attrs) )) %>% 
 mutate(edge_args = map(row_number(), ~ .E()[.E() %>% pull(to) == .x,] %>% pull(from_name) )) %>%
 mutate(eval_statement = pmap(  
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
