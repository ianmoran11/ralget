library(ralget)
library(tidyverse)
library(tidygraph)


make_lemon_filling  <- v(name = "Make lemon filling")
separate_egg  <- v(name = "Separate egg")
make_meringue  <- v(name = "Make meringue")
fill_crust  <- v(name = "Fill crust")
add_meringue  <- v(name = "Add meringue")

prepared_crust <- e(name = "Prepared crust")
lemon <- e(name = "Lemon")
butter <- e(name = "Butter")
sugar <- e(name = "Sugar")
egg <- e(name = "Egg")
yolk <- e(name = "Yolk")
white <- e(name = "White")
lemon_filling <- e(name = "Lemon filling")
meringue <- e(name = "Meringue")
unbaked_lemon_pie <- e(name = "Unbaked lemon pie")
unbaked_pie <- e(name = "Unbaked pie")

egg_step <-
  (egg * separate_egg * (yolk +  white))

components <-
     ((sugar + butter + yolk + lemon)  *  make_lemon_filling * lemon_filling) +
     (white * make_meringue * meringue)

  a1 <- ((meringue + unbaked_lemon_pie)* add_meringue * unbaked_pie) 
  a2 <- ((lemon_filling + prepared_crust) * fill_crust * unbaked_lemon_pie)  

assembly <-   a1 + a2
  
assembly %>% diagram()
egg_step %>% diagram()
components %>% diagram()

(egg_step + components)  %>% diagram()
(assembly + components) %>% diagram()
(components + assembly) %>% diagram()


(assembly + components + egg_step) %>% diagram()

(components + assembly) %>% diagram()

(assembly + components) %>% diagram()
diagram(graph)


g2 <- 
tidygraph::graph_join((e(name= "g1_to_g2") * v("g21") * e(name ="g2_to_g1")),(e(name= "gX_to_g2") * v("g22") * e(name= "g2_to_gX")))
g2 %>% diagram() 
 
g1 <- 
tidygraph::graph_join((e(name= "g2_to_g1") * v("g11") * e(name= "g1_to_g2")),(e(name= "gX_to_g1") * v("g12") * e(name= "g1_to_gX")))
g1 %>% diagram()
  
(g2 + g1) %>% diagram

(g1 + g2) %>% diagram








