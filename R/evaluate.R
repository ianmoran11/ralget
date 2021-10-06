
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

evaluate <- function(g) {
  g %>% evaluate_prepare() %>% evaluate_execute()
}


#' Evaluate a graph where nodes and edges store functions.1
#'
#' @param g ralget
#' @export

evaluate_prepare <- function(g) {

  g %>%
    mutate(order = node_topo_order())  %>%
    arrange(order) %>%
    mutate(edge_funcs = map(row_number(),
     ~ .E()[.E() %>% pull(to) == .x, ] %>% pull(.attrs))) %>%
    mutate(edge_args = map(row_number(),
    ~ .E()[.E() %>% pull(to) == .x, ] %>% pull(from_name)))
}

#' Evaluate a graph where nodes and edges store functions.2
#'
#' @param g ralget
#' @export

evaluate_execute <- function(g){

  g %>%
    mutate(eval_statement = pmap(
      .l = list(name = name,.attrs = .attrs,edge_funcs = edge_funcs,
                edge_args = edge_args),
      .f = function(...){
          tree_list <- list(...)
       # browser()
          edge_results <-
            map2(tree_list$edge_funcs,
                 tree_list$edge_args,
                 function(.x,.y){
                    # browser()
                   edge_result <-  do.call(.x[[1]], list(sym(.y)))
                   return(edge_result)
                 })
          # browser()

          node_result <- do.call(tree_list$.attrs$.f,list(edge_results))


        print(paste0(tree_list$name, "~ ", paste0(tree_list$edge_args, collapse = "+")))
        print(paste0(node_result, "~ ", paste0(edge_results, collapse = "+")))

        # browser()
          assign(x = tree_list$name,value = node_result,envir = .GlobalEnv)
                           })
          )
}


