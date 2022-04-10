#' Get edge names
#'
#' @param gph_tbl ralget
#' @export

get_edge_names <- function(gph_tbl){

  gph_tbl %>%
    activate("edges") %>%
    mutate(from_name = map_chr(from, ~ .N() %>% filter(row_number() == .x) %>% pull(name))) %>%
    mutate(to_name = map_chr(to, ~ .N() %>% filter(row_number() == .x) %>% pull(name)))

}
