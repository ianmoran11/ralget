#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

T <- 
    function(...){
     initial_list <- list(...)

        function(...){
           do.call("v", append(initial_list,list(...)))
        }
    }