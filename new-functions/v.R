
#' Create vertex
#'
#' @param name vertext name (character)
#' @param ...  objects stored as vertex attributes.
#' @export

v <- function(name, ...){
  # browser()

  v <- tidygraph::create_path(1, directed = T) %>% activate("nodes") %>%
    mutate(name = name) %>%
    mutate(.attrs = ifelse(length(list(...)) ==0, list(),list(list(...))))

  class(v) <- c("ralget", class(v))

  v
}
