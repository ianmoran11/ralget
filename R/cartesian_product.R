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

 # browser()

  tmp <-
    tidyr::crossing(x = as_tibble(x) %>% pull(name),
             y = as_tibble(y) %>% pull(name)) %>%
    mutate(new_name = paste(x,y,sep ="-"))

  combo <-
    bind_cols(
      tidyr::crossing(src = tmp$new_name, trg = tmp$new_name) %>% full_join(tmp, by = c("src" = "new_name")) %>% set_names(c("src","trg","x_src","y_src")),
      tidyr::crossing(src = tmp$new_name, trg = tmp$new_name) %>% full_join(tmp, by = c("trg" = "new_name"))  %>% select(-src,-trg) %>% set_names(c("x_trg","y_trg"))
    )


  x_edges_1 <- x %>% get_edge_names() %>% as_tibble()  
  x_edges <- map2(x_edges_1$from_name,x_edges_1$to_name, ~ list(.x,.y))

  y_edges_1 <- y %>% get_edge_names() %>% as_tibble()   
  y_edges <- map2(y_edges_1$from_name,y_edges_1$to_name, ~ list(.x,.y))

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

 nodes_df <-  
  combo_filtered %>% 
  select(src,trg, x_src, y_src) %>% 
  as_tbl_graph()  %>%  
  mutate(x_src = map_chr(row_number(),possibly(~ .E()%>% filter(from == .x) %>% pull(x_src)  %>% .[[1]],NA_character_))) %>%
  mutate(y_src = map_chr(row_number(),possibly(~ .E()%>% filter(from == .x) %>% pull(y_src)  %>% .[[1]],NA_character_))) %>%
  as_tibble() %>% 
  left_join(x, by = c("x_src" = "name"), copy = T,  suffix = c("",".x"))  %>% 
  left_join(y, by = c("y_src" = "name"), copy = T,  suffix = c("",".y")) 

x_edges <- x %>% activate("edges") %>% get_edge_names() %>% as_tibble()
y_edges <- y %>% activate("edges") %>% get_edge_names() %>% as_tibble()

edges_df <-
 combo_filtered %>% 
   select(src,trg, x_src,x_trg,y_src,y_trg) %>% 
   as_tbl_graph() %>%
   activate("edges") %>%
   left_join(as_tibble(x_edges), by = c("x_src" = "from_name", "x_trg" = "to_name"),
    copy = T,  suffix = c("",".x"))  %>% 
   left_join(as_tibble(y_edges), by = c("y_src" = "from_name", "y_trg" = "to_name"),
    copy = T,  suffix = c("",".y")) %>%
    select(-matches("from|to|src|trg|new"))

  return_df <- edges_df %>% activate("nodes") %>% left_join(nodes_df)

  return_df

  }
