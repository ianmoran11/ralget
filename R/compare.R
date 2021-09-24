#' Create vertex
#'
#' @param v1 ralget graph
#' @param v2 ralget graph
#' @S3method  "==" ralget
#' @export

`==.ralget` <- function(v1,v2){

  compare(v1,v2)

}

compare <- function(v1,v2){
  # browser()

  nodes <-
    all_equal(
      (activate(v1, "nodes") %>% arrange(name) %>% as.data.frame),
      (activate(v2, "nodes") %>% arrange(name) %>% as.data.frame)) == T

  edges <-
    all_equal(
      (v1 %>% get_edge_names() %>%  as.data.frame %>% select(from = from_name, to = to_name) %>%  arrange(from,to)),
      (v2 %>% get_edge_names() %>%  as.data.frame %>% select(from = from_name, to = to_name) %>%  arrange(from,to))) == T


  nodes & edges

}
