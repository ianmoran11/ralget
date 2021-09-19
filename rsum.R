#' Vector addition
#'
#' @param ... a list of vectors 
#' @export
#' 
rsum <- function(...){

  olst <- list(...)

  if(length(olst)==0){
    return(0)
  }
  if(length(olst)==1){
   return(olst[[1]])
  }else{
   return(unlist(pmap(olst, sum)))
  }
  }
