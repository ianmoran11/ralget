#' #' @export
#' #' @S3method  print mmtable
#' #' @importFrom magrittr %>%
#' #' 
#' print.ralget <- function(x,...){
#'   
#'  d <- diagram(x)  
#'  new_class <- class(x) %>% keep(~ !str_detect(.,"ralget"))
#'  class(x)   <- new_class
#'  print(x) 
#'   
#'  print(d)
#'  
#'  invisible(x)
#' }
