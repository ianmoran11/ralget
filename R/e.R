#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export


e <- function(name, ...){

  e_obj <- list(name = name, ...)

  class(e_obj) <- c("ralget_edge", class(e_obj))

  e_obj

}
