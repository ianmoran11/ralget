
#' A shorthand to represent coefficient in a data generating process.
#'
#' @param m coefficient value 
#' @export
 
b <- function(m){ 
    e(.func = function(.value){.value * m})
    }