#' Vector addition
#'
#' @param ... a list of vectors 
#' @export
#' 
unsafe_rsum <- function(...){
  #browser()

# lengthp <- possibly(length, return(0))

# lengthp(list(...))

#if(r == 0){return(0)}

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

#' Vector addition
#'
#' @param ... a list of vectors 
#' @export
#' 
rsum <- purrr::possibly(unsafe_rsum,0)
