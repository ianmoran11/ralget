#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export


e <- function(name = NULL, ...){

   if(is.null(name)){  name <- paste(sample(letters,5) ,collapse = "")}
   
  e_obj <- list(name = name, ...)

  class(e_obj) <- c("ralget_edge", class(e_obj))

  e_obj

}
