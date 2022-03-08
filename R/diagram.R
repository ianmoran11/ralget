
#' Add two ralget graphs
#'
#' @param v1 a ralget graph
#' @param v2 a ralget graph
#' @return ralget
#' @export

diagram <- function(graph){
# library(ralget) 
# library(tidyverse)
# library(tidygraph)
#   
# make_lemon_filling  <- v(name = "Make lemon filling")
# separate_egg  <- v(name = "Separate egg")
# make_meringue  <- v(name = "Make meringue")
# fill_crust  <- v(name = "Fill crust")
# add_meringue  <- v(name = "Add meringue")
# 
# prepared_crust <- e(name = "Prepared crust")
# lemon <- e(name = "Lemon")
# butter <- e(name = "Butter")
# sugar <- e(name = "Sugar")
# egg <- e(name = "Egg")
# yolk <- e(name = "Yolk")
# white <- e(name = "White")
# lemon_filling <- e(name = "Lemon filling")
# meringue <- e(name = "meringue")
# unbaked_lemon_pie <- e(name = "Unbaked lemon pie")
# unbaked_pie <- e(name = "Unbaked pie")
# 
# graph <- 
#   (separate_egg * yolk * make_lemon_filling) + 
#   (separate_egg * white * make_meringue) + 
#   (make_lemon_filling * lemon_filling * fill_crust) + 
#   (fill_crust * unbaked_lemon_pie * add_meringue) + 
#   (make_meringue * meringue * add_meringue)   + 
#   (egg * separate_egg) + 
#   ((sugar *  make_lemon_filling) + 
#      (butter * make_lemon_filling) +
#      (sugar *  make_lemon_filling) +
#      (prepared_crust * fill_crust) +
#      (add_meringue * unbaked_pie) +
#      (lemon *  make_lemon_filling))

# Get nodes --------------------

# browser()
# nodes <- edge_df %>% pull(node_list)  %>% map(~ .x[-2]) %>% unlist() %>% unique()

internode_joins <- tibble(from = NA_character_, edge_name = NA_character_, to = NA_character_) %>% filter(F)
if(graph %>% activate("edges") %>% as_tibble() %>% nrow() %>% `>`(0)){
  edge_df <- graph %>% activate("edges") %>% get_edge_names() %>% mutate(node_list = pmap(list(from_name, .attrs, to_name), ~ list(..1,unlist(..2),..3))) 
  internode_joins <- edge_df %>% pull(node_list) %>% map( ~ .x %>% keep(~ !is.null(.x)))  %>% map(~ as.data.frame(.x)) %>% map(~ .x %>% set_names(c("from","edge_name","to"))) %>% map_df(as_tibble)
}

dot_in <- tibble(from = NA_character_, edge_name = NA_character_, to = NA_character_) %>% filter(F)
dot_out <- tibble(from = NA_character_, edge_name = NA_character_, to = NA_character_) %>% filter(F)
if(graph %>% activate("nodes") %>% as_tibble()  %>% names() %>% `%in%`(".waiting_edge_left",.)){
  dot_in <- graph %>% as_tibble() %>% mutate(left = map(.waiting_edge_left, ~ .x %>% unlist %>% as.character)) %>% unnest(left) %>% mutate(from = paste(name,left)) %>% rename(edge_name =left, to = name) %>% select(from,edge_name, to)
}
if(graph %>% activate("nodes") %>% as_tibble()  %>% names() %>% `%in%`(".waiting_edge_right",.)){
  dot_out <- graph %>% as_tibble() %>% mutate(right = map(.waiting_edge_right,~ .x %>% unlist %>% as.character)) %>% unnest(right) %>%  mutate(from =name) %>% rename(edge_name =right) %>% mutate(to = paste(from,edge_name)) %>% select(from,edge_name, to)
}

box_names <- graph %>% activate("nodes") %>% pull(name) %>% map_chr(~paste0("'",.x,"'")) %>% paste(collapse = "; ")
point_names <- unique(c(pull(dot_in,from),pull(dot_out,to))) %>% map_chr(~paste0("'",.x,"'")) %>% paste(collapse = "; ")

edge_txt <- list(internode_joins , dot_in, dot_out) %>% keep(is.data.frame) %>% bind_rows() %>% mutate_all(.funs = ~ paste0("'",.,"'"))  %>% 
  mutate(edge_txt = paste0(from, " -> ", to," [label = ",edge_name ,"]")) %>% pull(edge_txt) %>% paste0(collapse = "\n")

diagram_txt <- 
paste0("\ndigraph rmarkdown{\nrankdir = TB\nnode [ shape = box , fontname = Arial]\n",box_names,"\n\nnode [ shape = point , fontname = Arial]\n",point_names,"\n\n",edge_txt,"}")

# diagram_txt %>% cat()

diagram_txt %>% DiagrammeR::grViz()
  
  
}