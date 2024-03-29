#' Multiply two ralget graphs
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget
#' @export
#' @S3method  "*" ralget

`*.ralget` <- function(v1,v2){
  connect(v1,v2)
}
#' Multiply two ralget graphs
#'
#' @param current_graph a ralget graph
#' @param side a ralget graph
#' @return ralget

separate_edges <- function(current_graph, side){
  current_graph_edges_n <- pull(current_graph,!!sym(side))[[1]] %>% length()
  purrr::map(1:current_graph_edges_n,extract_edgelist_n, graph = current_graph, side = side) %>% bind_graphs()
}

#' Multiply two ralget graphs
#'
#' @param graph a ralget graph
#' @param n a ralget graph
#' @param side a ralget graph
#' @return ralget
extract_edgelist_n <- function(graph, n, side){
 graph %>% mutate(!!sym(side) := map(!!sym(side),n))
}

#' Connect two ralget graphs - original
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget

connect <- function(v1, v2){
## Outline: ----
### IF (EDGE * _)|(_ * EDGE) -> (GRAPH,WAITING EDGE)
# browser()
  if(("ralget_edge" %in% class(v1)) & (!"ralget_edge" %in% class(v2))){
    attributes(v2) <- c(attributes(v2), list(waiting_edge_left = v1))
    v2 <- v2 %>% mutate(.waiting_edge_left = purrr::map(1, ~ v1))
    return(v2)
  }

  if((!"ralget_edge" %in% class(v1)) & ("ralget_edge" %in% class(v2))){
    attributes(v1) <- c(attributes(v1), list(waiting_edge_right = v2))
    v1 <- v1 %>% mutate(.waiting_edge_right = purrr::map(1, ~ v2))
    return(v1)
  }

if( ".waiting_edge_right" %in% names(as_tibble(v1))){
  v1_list <-  map(1:nrow(as_tibble(activate(v1,"nodes"))),~ v1 %>% filter(row_number() == .x))
  v1_list_gt1 <- map_lgl(v1_list, ~ .x %>% pull(.waiting_edge_right) %>% .[[1]] %>% length() %>% `>`(1))
  v1_waiting <- map_if(v1_list, v1_list_gt1,separate_edges, side = ".waiting_edge_right") %>% bind_graphs()
}

if( ".waiting_edge_left" %in% names(as_tibble(v2))){
  v2_list <-  map(1:nrow(as_tibble(activate(v2,"nodes"))),~ v2 %>% filter(row_number() == .x))
  v2_list_gt1 <- map_lgl(v2_list, ~ .x %>% pull(.waiting_edge_left) %>% .[[1]] %>% length() %>% `>`(1))
  v2_waiting <- map_if(v2_list, v2_list_gt1,separate_edges, side = ".waiting_edge_left") %>% bind_graphs()
}

## Get names of nodes in  each graph ------
  v1_names <- activate(v1,"nodes") %>% pull(name)
  v2_names <- activate(v2,"nodes") %>% pull(name)

## Create dataframe of all new edges V1 Nodes x V2 Nodes --- 
  new_edges <- tidyr::crossing(from = v1_names, to = v2_names)

if(exists("v1_waiting")){
  new_edges  <- left_join(new_edges, as_tibble(v1_waiting), by = c("from"= "name"))
}

if(exists("v2_waiting")){
  new_edges  <-  left_join(new_edges, as_tibble(v2_waiting), by = c("to"= "name"))
}

## Join V1 to V2 ---
suppressMessages(
  bound <- tidygraph::graph_join(v1,v2)
)

## Create data frame of edges present after graph_join --- 
  bound_edge_tbl <-
    activate(bound,"edges") %>%
    mutate(from_name = map_chr(from, ~ .N() %>% filter(row_number() == .x) %>% pull(name))) %>%
    mutate(to_name = map_chr(to, ~ .N() %>% filter(row_number() == .x) %>% pull(name)))  %>%
    as_tibble() %>%
    select(from = from_name, to = to_name)

## Identify which edges are missing after join --- 
suppressMessages(
  edges_to_add <- anti_join(new_edges,bound_edge_tbl)
)

## If there are edges to add, bind edges --- 
if(nrow(edges_to_add)>0){
  bound <- bound %>%
    activate("edges") %>% mutate(new =F) %>%
    bind_edges(edges_to_add) %>%
    mutate(new = ifelse(is.na(new),T,new))
}

## If waiting edge right on v1
if(".waiting_edge_right" %in% names(as_tibble(v1)) ){
    bound <-
      bound <-
      bound %>%
      activate("edges") %>%
      mutate(.attrs = pmap(list(new,.attrs,.waiting_edge_right), 
              function(new,.attrs,.waiting_edge_right){ifelse(new, .waiting_edge_right, 
              ifelse(is.null(.attrs),list(NULL), .attrs)) %>% unlist})) %>%
      activate("nodes") %>% select(-.waiting_edge_right)  %>%
      activate("edges") %>%
      select(-.waiting_edge_right, -new)
}

  if(".waiting_edge_left" %in% names(as_tibble(v2)) ){
    bound <-
      bound <-
      bound %>%
      activate("edges") %>%
      mutate(.attrs = pmap(list(new,.attrs,.waiting_edge_left), 
              function(new,.attrs,.waiting_edge_right){ifelse(new, .waiting_edge_left, 
              ifelse(is.null(.attrs),list(NULL), .attrs)) %>% unlist})) %>%
      activate("nodes") %>% select(-.waiting_edge_left)  %>%
      activate("edges") %>%
      select(-.waiting_edge_left, -new)
  }

  bound %>% select(-matches("^new$")) %>% activate("nodes")

}
