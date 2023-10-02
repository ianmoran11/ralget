#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export


form <- function(plan){
  pull(plan,"name") %>% map(~ filter(plan,name == .x) %>% instantiate()) %>% reduce(`+`) 
}