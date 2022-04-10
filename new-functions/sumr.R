
#' Sum multiple ralget vertices 
#'
#' @param ...  vertices
#' @export
 
sumv <- function(...){ list(...) %>% reduce(`+`)}