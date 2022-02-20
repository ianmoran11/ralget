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



diagram(graph)




