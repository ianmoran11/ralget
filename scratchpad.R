library(ralget)
library(tidyverse)
library(tidygraph)
library(devtools)
library(Hmisc)
load_all()

l <- list(list("one", "two"), list("three 1", "three 2", list("three - 3 1", "three - 3 2 ")))

list.tree(l,depth = Inf)


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

class(meringue_recipe)
meringue_recipe %>% print()
meringue_recipe %>% print.ralget()

meringue_recipe <- 
(
  (egg * separate_egg)  +
  (separate_egg * (yolk + white)) +
  ((yolk + sugar + butter + lemon) * make_lemon_filling)  +
  ((sugar + white) * make_meringue) +
  (make_lemon_filling * lemon_filling) +
  (make_meringue * meringue) +
  (lemon_filling * fill_crust) +
  (fill_crust * unbaked_lemon_pie) +
  ((unbaked_lemon_pie + meringue) * add_meringue * unbaked_lemon_pie) 
) 
meringue_recipe %>% diagram

g1 <- 
  (egg * separate_egg) +
  (separate_egg * (yolk + white)) +
  ((yolk + sugar + butter + lemon) * make_lemon_filling)  +
  ((sugar + white) * make_meringue) +
  (make_lemon_filling * lemon_filling)  +
  (make_meringue * meringue) 
  
  
 g2 <-  
  (lemon_filling * fill_crust) 

g1 %>% diagram 
g2 %>% diagram  
(g1 + g2) %>% diagram

print.list <- function(x){ list.tree(x)}
list.print <- function(x){ list.tree(x)}

g1 %>% pull(.waiting_edge_right) %>% list.tree()
g2 %>% pull(.waiting_edge_left) %>% list.tree()



install.packages("Hmisc")













egg_step <-  (egg * separate_egg * (yolk +  white))

components <-
     ((sugar + butter + yolk + lemon)  *  make_lemon_filling * lemon_filling) +
     (white * make_meringue * meringue)

assembly <- 
  ((meringue + unbaked_lemon_pie)* add_meringue * unbaked_pie) +
   ((lemon_filling + prepared_crust) * fill_crust * unbaked_lemon_pie)  



a1 <-   ((meringue + unbaked_lemon_pie)* add_meringue * unbaked_pie) 
a2 <- ((lemon_filling + prepared_crust) * fill_crust * unbaked_lemon_pie)  


diagram(a1 + a2)

 
egg_step %>% diagram()
assembly %>% diagram() 
components %>% diagram()

# Ubaked pie is turning into a character- fix
(assembly + components) %>% diagram()

(components + assembly + egg_step) %>% diagram()
(egg_step + components + assembly) %>% diagram()
s1 <- (egg_step + components) 

(s1 + assembly)  %>% diagram

+ assembly) %>% diagram()

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

rvreo1        <- e(name = "rvreo1")       
rvreo2        <- e(name = "rvreo2")       
lvles1rvres1 <- e(name = "lvles1rvres1") 
lvles2rvres2 <- e(name = "lvles2rvres2") 
rvleo1        <- e(name = "rvleo1")       
rvleo2        <- e(name = "rvleo2")       
lvres1rvles1  <- e(name = "lvres1rvles1") 
lvres2rvles2  <- e(name = "lvres2rvles2") 
lvreo1        <- e(name = "lvreo1")       
lvreo2        <- e(name = "lvreo2")       
lvleo1        <- e(name = "lvleo1")       
lvleo2        <- e(name = "lvleo2")       


vl <- v(name = "vl")
vr <- v(name = "vr")

vl_e <- (lvleo1 + lvleo2 + lvles1rvres1 + lvles2rvres2) * vl * (lvreo1 + lvreo2 + lvres1rvles1 + lvres2rvles2)
vr_e <- (rvleo1 + rvleo2 + lvres1rvles1 + lvres2rvles2) * vr * (rvreo1 + rvreo2 + lvles1rvres1 + lvles2rvres2)

diagram(vl_e + vr_e)

vl_e + vr_e

oil            <- e(name = "oil")
onion          <- e(name = "onion")
garlic         <- e(name = "garlic")
mince          <- e(name = "mince")
tomato         <- e(name = "tomato") 
wine           <- e(name = "wine") 
tomato_paste   <- e(name = "tomato_paste")
salt           <- e(name = "salt")
pepper         <- e(name = "pepper")
milk           <- e(name = "milk")
onion          <- e(name = "onion")
parsely_stalks <- e(name = "parsely_stalks")
peppercorns    <- e(name = "peppercorns")
cloves         <- e(name = "cloves") 
bay_leaves     <- e(name = "bay_leaves")
butter         <- e(name = "butter")
flour          <- e(name = "flour")
permesan       <- e(name = "permesan")
nutmeg         <- e(name = "nutmeg") 
salt           <- e(name = "salt")
pepper         <- e(name = "pepper")
mozzarlla      <- e(name = "mozzarlla")

onion_mix <- e(name = "onion_mix")
tomato_sauce <- e(name= "tomato_sauce")


(
((oil + onion + garlic) * v("cook") * onion_mix) +
((e("onion_mix") + tomato + wine + tomato_paste) * v("stir") * tomato_sauce) +
((salt + pepper + tomato_sauce) * v("add") * e("seasoned_tomato_sauce"))
) %>% diagram




make_white_sauce <- 
(((milk + onion + parsely_stalks + peppercorns + cloves + bay_leaves) * v("combine and simmine") * e("white suauce prem")) +
  (e("white suauce prem") + butter + flour + milk) * v("combine") * e("white sauce")) 

layer_combonents <- 
  ((e("white sauce") + e("seasoned tomato sauce")) * v("layer") * e("unbaked lasange"))

(make_tomato_sauce + (make_white_sauce + layer_combonents)) %>% diagram
