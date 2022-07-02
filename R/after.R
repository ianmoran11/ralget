#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

after <- function(target){
    class(target) <- c("after", class(target))
    target
}