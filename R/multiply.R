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

#' Connect two ralget graphs - original
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget

connect <- function(v1, v2){
  # browser()


  if(("ralget_edge" %in% class(v1)) & (!"ralget_edge" %in% class(v2))){

    attributes(v2) <- c(attributes(v2), list(waiting_edge_left = v1))

    v2 <- v2 %>% mutate(.waiting_edge_left = v1)

    return(v2)

  }

  if((!"ralget_edge" %in% class(v1)) & ("ralget_edge" %in% class(v2))){

    attributes(v1) <- c(attributes(v1), list(waiting_edge_right = v2))

    v1 <- v1 %>% mutate(.waiting_edge_right = v2)

    return(v1)

  }

  v1_names <- activate(v1,"nodes") %>% pull(name)
  v2_names <- activate(v2,"nodes") %>% pull(name)

  new_edges <- tidyr::crossing(from = v1_names, to = v2_names)

suppressMessages(
  bound <-   tidygraph::graph_join(v1,v2)
)

  bound_edge_tbl <-
    activate(bound,"edges") %>%
    mutate(from_name = map_chr(from, ~ .N() %>% filter(row_number() == .x) %>% pull(name))) %>%
    mutate(to_name = map_chr(to, ~ .N() %>% filter(row_number() == .x) %>% pull(name)))  %>%
    as_tibble() %>%
    select(from = from_name, to = to_name)


suppressMessages(
  edges_to_add <- anti_join(new_edges,bound_edge_tbl)
)


  if(nrow(edges_to_add)>0){
    bound <- bound %>%
      activate("edges") %>% mutate(new =F) %>%
      bind_edges(edges_to_add) %>%
      mutate(new = ifelse(is.na(new),T,new))
  }

  # if waiting edge right on v1
  if(".waiting_edge_right" %in% names(as_tibble(v1)) ){
    bound <-
      bound %>%
      get_edge_names() %>%
      mutate(.attrs_right_t = map(
        from,
        ~ .N() %>%
          filter(row_number() == .x) %>%
          filter(name %in% v1_names) %>%
          pull(.waiting_edge_right) %>% unlist()
      )
      ) %>%
      mutate(.attrs_right = map2(new,.attrs_right_t,
                                 function(new,.attrs_right_t){ifelse(new,list(.attrs_right_t),list(NULL)) %>% unlist})) %>%
      select(-.attrs_right_t) %>%
      rename(.attrs = .attrs_right) %>%
      activate("nodes") %>% select(-.waiting_edge_right) %>%
      activate("edges")


  }

  # browser()
  if(".waiting_edge_left" %in% names(as_tibble(v2)) ){
    bound <-
      bound <-
      bound %>%
      get_edge_names() %>%
      mutate(.attrs_left_t = map(
        to,
        ~ .N() %>%
          filter(row_number() == .x) %>%
          filter(name %in% v2_names) %>%
          pull(.waiting_edge_left) %>% unlist()
      )
      ) %>%
      mutate(.attrs_left = map2(new,.attrs_left_t,
                                function(new,.attrs_left_t){ifelse(new,list(.attrs_left_t),list(NULL)) %>% unlist})) %>%
      select(-.attrs_left_t) %>%
      rename(.attrs = .attrs_left) %>%
      activate("nodes") %>% select(-.waiting_edge_left)  %>%
      activate("edges")

  }

  bound %>% activate("nodes")

}
