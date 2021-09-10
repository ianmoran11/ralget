#' Cartesian product of two ralgets
#'
#' @param x ralget graph
#' @param y ralget graph
#' @export

`%x%` <- function(x,y){cartesian_product(x,y)}

#' Cartesian product of two ralgets
#'
#' @param x ralget graph
#' @param y ralget graph
#' @export

cartesian_product <- function(x,y){
  tmp <-
    crossing(x = as_tibble(x) %>% pull(name),
             y = as_tibble(y) %>% pull(name)) %>%
    mutate(new_name = paste(x,y,sep ="-"))

  combo <-
    bind_cols(
      crossing(src = tmp$new_name, trg = tmp$new_name) %>% full_join(tmp, by = c("src" = "new_name")) %>% set_names(c("src","trg","x_src","y_src")),
      crossing(src = tmp$new_name, trg = tmp$new_name) %>% full_join(tmp, by = c("trg" = "new_name"))  %>% select(-src,-trg) %>% set_names(c("x_trg","y_trg"))
    )
  x_edges <- x %>% get_edge_names() %>% as_tibble() %$%  map2(from_name,to_name, ~ list(.x,.y))
  y_edges <- y %>% get_edge_names() %>% as_tibble() %$%  map2(from_name,to_name, ~ list(.x,.y))


  combo_filtered <-
    combo %>%
    mutate(x_links= map2(x_src,x_trg, ~ list(.x,.y))) %>%
    mutate(y_links= map2(y_src,y_trg, ~ list(.x,.y))) %>%
    mutate(x_link_lgl = map_lgl(x_links, ~ list(.x) %in% x_edges ))  %>%
    mutate(y_link_lgl = map_lgl(y_links, ~ list(.x) %in% y_edges ))  %>%
    mutate(x_new_link = x_link_lgl & (y_src == y_trg)) %>%
    mutate(y_new_link = y_link_lgl & (x_src == x_trg)) %>%
    mutate(new_link = y_new_link | x_new_link ) %>%
    filter(new_link)

  combo_filtered %>% select(src,trg) %>% as_tbl_graph()

}
