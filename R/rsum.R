#' Vector addition
#'
#' @param ... a list of vectors 
#' @export
#' 
rsum <- function(...){
  # browser()

r <- tryCatch(list(...), error = return(0),warning = return(2) ,finally =return(3))

if(r == 0){return(0)}

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
