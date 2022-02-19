pack <- function(graph, name){
  
# # browser()
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
 
  
left_edge_list <- graph %>% pull(.waiting_edge_left) %>% keep(~ !is.null(.x)) %>% reduce(`+`)
right_edge_list <- graph %>% pull(.waiting_edge_right) %>% keep(~ !is.null(.x)) %>% reduce(`+`)
 

output_graph <- (left_edge_list * v(name = name,.graph =  graph ) * right_edge_list) 

# output_graph %>% diagram()
output_graph
  
}








