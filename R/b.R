
#' A shorthand to represent coefficient in a data generating process.
#'
#' @param m coefficient value 
#' @export
 
b <- function(m){ 
    e(.func = list(coeff_func = function(.value){.value * m}, name = "b"),
      name = paste(sample(size = 5,x = LETTERS),collapse = "" ))
    }