#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export


e <- function(...){

  e_obj <- list(...)

  class(e_obj) <- c("ralget_edge", class(e_obj))

  e_obj

}
