#' Set value for variable in DAG
#'
#' @param g ralget
#' @param p assignment expressions for node in DAG
#' @export

do.ralget <-function(graph,...){
 #browser()

l <- list(...)
var = names(l)
val = l[[1]]


graph %>% 
  mutate(.attrs =map_if(
      .attrs,
      name == var, 
      ~ list(.func = const_map(.x$.f,val)))) 
}

#' Set value for variable in DAG
#'
#' @param f a function
#' @param val a constant value to replace return values of a function
#' 
const_map <-  function(f,val){

  function(...){ ifelse("hesdlkfjsldfkjllo" != f(...),val, f(...))}

}

#' Set value for variable in DAG
#'
#' @param g ralget
#' @param p assignment expressions for node in DAG
#' @export

 do <- function (graph,...){
    UseMethod("do")
}