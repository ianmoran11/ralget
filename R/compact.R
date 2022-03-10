
#' Cartesian product of two ralgets
#'
#' @param x ralget graph
#' @param y ralget graph
#' @export
#' 
compact <- function(graph){
  
  # browser()
  if(!(".attrs" %in% names(as_tibble(graph)))){
    graph <- graph %>% mutate(.attrs = map(row_number, ~ list(NULL)))
  }
  
 # ?summarise 
  
  node_df <- 
  as_tibble(graph) %>% mutate(row_now = row_number()) %>% 
    group_by(name) %>% 
    summarise(
      .attrs = list(.attrs),
              .waiting_edge_left = aggregator(.waiting_edge_left),
              .waiting_edge_right = aggregator(.waiting_edge_right),
      old_rows = list(row_now)
              )  %>% 
    mutate(new_rows = row_number())
  
  new_edges_df_from <- node_df %>% select(old_rows, new_rows) %>% unnest(c("old_rows")) %>% unique() %>% rename(from = old_rows, new_from = new_rows)
  new_edges_df_to <- node_df %>% select(old_rows, new_rows) %>% unnest(c("old_rows")) %>% unique() %>% rename(to = old_rows, new_to = new_rows)
  
  edge_df <- as_tibble(activate(graph, "edges")) 
  
  new_edge_df <- 
  edge_df %>% left_join(new_edges_df_from) %>% left_join(new_edges_df_to) %>% 
    select(-from,-to) %>% select(from = new_from, to = new_to, everything())
  
  new_graph <- tbl_graph(nodes = node_df, edges = new_edge_df)  %>% select(-old_rows, -new_rows)
  
  class(new_graph) <- c("ralget", class(new_graph))
  
  
  if(!(".attrs" %in% names(as_tibble(graph)))){
    new_graph <- new_graph %>% mutate(.attrs = map(row_number, ~ list(NULL)))
  }
  
  new_graph
    
}
