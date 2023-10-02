#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

once <- function(target){
    class(target) <- c("once", class(target))
    target
}
