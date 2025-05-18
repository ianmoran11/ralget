rm(list = ls())

library(devtools)
devtools::document()
devtools::install(".")
library(ralget)

library(jsonlite)
library(tidyverse)
library(igraph)
library(tidygraph)
library(DiagrammeR)

library(reprex)
library(d3r)
library(Hmisc)

load_all()

load_package_silent("ralget")

file.remove("llm-guide_reprex.R")
file.remove("llm-guide_reprex.md")
reprex(input = "llm-guide.R")

.libPaths()
remove.packages("ralget", lib="/usr/local/lib/R/site-library")
remove.packages("ralget", lib="/usr/local/lib/R/library")


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


t <- 
(e("we1")*v("L")*e("e")*v("R")) +
(v("L")*e("e")*v("R") *e("we2"))

t %>% diagram()

t %>% as_tibble() %>% pull(.waiting_edge_right)

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
ralget::compact()
meringue_recipe %>% ralget::compact() %>% diagram()

#as.igraph() %>% 
meringue_recipe %>% to_json()


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


library("Hmisc")
print.list <- function(x){ list.tree(x)}
list.print <- function(x){ list.tree(x)}

g1 %>% pull(.waiting_edge_right) %>% list.tree()
g2 %>% pull(.waiting_edge_left) %>% list.tree()

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

(assembly + components) %>% diagram()

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

# load_all()

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

recipe <- 
(egg * separate_egg)  +
(separate_egg * (yolk + white)) +
((yolk + sugar + butter + lemon) * make_lemon_filling)  +
((sugar + white) * make_meringue) +
(make_lemon_filling * lemon_filling) +
(make_meringue * meringue) +
(lemon_filling * fill_crust) +
(fill_crust * unbaked_lemon_pie) +
((unbaked_lemon_pie + meringue) * add_meringue * unbaked_lemon_pie) 


recipe %>% compact()

( e("one") + e("two") ) + (e("three") + e("four"))


## Petri net 
### States
S <- v("S")
I <- v("I")
R <- v("R")

### Transitions
i <- v("infection")
r <- v("recovery")

rn <- \(x) paste0(sample(letters, 5, replace = TRUE), collapse = "")

SIR <-
 S * e("Si") * i  +
 i * e("iI") * I + 
 I * e("Ii(1)") * i +
 I * e("Ir") * r  +
 r * e("rR") * R  + 
 i * e("iI(2)") * I

D <- v("D")
d <- v("death")

D <- 
 I * e("Id") * d +
 d * e("dD") * D

plot(D)
diagram(D)

SIRD <- SIR + D

POP <- v("I") + v("NI") 


SIR + SIR


 (POP %x% SIR)


plot(SIRD)
diagram(SIRD)








ID <- 

 I * e("Ii(1)") * i +




plot(SIR)
diagram(SIR)
 
SIR %>% print(n = Inf)




 * I) + (I * e("recover") * R)

plot(SIR)

diagram(SIR %x% SIR)


ralget::cartesian_product()




POP <- v("POP", species = "place", type = "blue") 
S   <- v("S",   species = "place", type = "blue") 
I   <- v("I",   species = "place", type = "blue") 
R   <- v("R",   species = "place", type = "blue") 

S_id <- v("S_id", species = "transition", type = "green") 
I_id <- v("I_id", species = "transition", type = "green") 
R_id <- v("R_id", species = "transition", type = "green") 

infecting  <- v("infecting",  species = "transition", type = "purple") 
recovering <- v("recovering", species = "transition", type = "yellow") 

ids <- 
S * e() * S_id +
I * e() * I_id +
R * e() * R_id + 
S_id * e() * S +
I_id * e() * I +
R_id * e() * R 

# Infectiono 
infection_gph <- 
S * e() * infecting +
I * e() * infecting +
infecting * (e() + e()) * I 

# Reconvery
recovery_gph <- 
(I * e() * recovering) +  (recovering * e() * R)


ll <- ids + infection_gph + recovery_gph

ll %>%  
mutate(colors = map_chr(.attrs, "type")) %>%
ggraph() + 
  geom_edge_link(arrow = arrow(length = unit(5, 'mm')), 
                 end_cap = circle(12, 'mm')) + 
  geom_node_label(aes(label = name, fill = colors),size = 10) +
  NULL





Q        <- v("Q",        species = "place",      type = "blue") 
nQ       <- v("nQ",       species = "place",      type = "blue") 

Q_id     <- v("Q_id",     species = "transition", type = "yellow") 
nQ_id    <- v("nQ_id",    species = "transition", type = "yellow") 


move_qnq <- v("move_qnq", species = "transition", type = "green")
move_nqq <- v("move_nqq", species = "transition", type = "green")


infect_nq <- v("infect_nq", species = "transition", type = "purple")

quarantine <- 
Q * e() * Q_id +
Q_id * e() * Q +
nQ * e() * nQ_id +
nQ_id * e() * nQ

tranisitions <- 
Q * e() * move_qnq +
move_qnq * e() * nQ +
nQ * e() * move_nqq +  
move_nqq * e() * Q +
nQ * (e() + e()) * infect_nq +
infect_nq *(e() + e()) * nQ


diagram(quarantine + tranisitions)

ur <-  quarantine + tranisitions

ur %>%  
mutate(colors = map_chr(.attrs, "type")) %>%
ggraph() + 
  geom_edge_link(arrow = arrow(length = unit(5, 'mm')), 
                 end_cap = circle(12, 'mm')) + 
  geom_node_label(aes(label = name, fill = colors),size = 10) +
  NULL






ur_df <- 
tibble(
ur_name = pull(as_tibble(ur),name),
ur_type = map_chr(pull(as_tibble(ur),.attrs),"type"),
ur_species = map_chr(pull(as_tibble(ur),.attrs),"species"),
joiner = 1
 )





ll_df <- 
tibble(
ll_name = pull(as_tibble(ll),name),
ll_type = map_chr(pull(as_tibble(ll),.attrs),"type"),
ll_species = map_chr(pull(as_tibble(ll),.attrs),"species"),
joiner = 1
)


j_df <- full_join(ur_df,ll_df, by = "joiner") 


ll_edges_df = activate(ll, "edges") %>% ralget::get_edge_names() %>% as_tibble() %>% select(ll_from = from_name, ll_to = to_name) %>% mutate(ll_edge = 1)
ur_edges_df = activate(ur, "edges") %>% ralget::get_edge_names() %>% as_tibble() %>% select(ur_from = from_name, ur_to = to_name) %>% mutate(ur_edge = 1)

ll_edges_df
ur_edges_df 

ul_nodes = j_df %>% filter(ur_type == ll_type)  %>% mutate(ul_name = paste(ur_name, ll_name, sep = "|"))

edge_candidates =
  tidyr::crossing(from = pull(ul_nodes, ul_name),  to = pull(ul_nodes, ul_name)) %>% 
  mutate(ur_from = str_extract(from,"^.+\\|") %>% str_remove("\\|")) %>%
  mutate(ur_to = str_extract(to,"^.+\\|") %>% str_remove("\\|")) %>%
  mutate(ll_from = str_extract(from,"\\|.+$") %>% str_remove("\\|")) %>%
  mutate(ll_to = str_extract(to,"\\|.+$") %>% str_remove("\\|"))

ul_edges <-      
  edge_candidates %>%
  left_join(ll_edges_df, by = c("ll_from", "ll_to"))  %>%
  left_join(ur_edges_df, by = c("ur_from", "ur_to"))  %>%
  filter(!is.na(ll_edge) & !is.na(ur_edge))


library(ggraph)

ul_gph <- 
tidygraph::as_tbl_graph(ul_edges %>% select(from,to), directed = T) 

install.packages("patchwork")
library(patchwork)

ul_plot <- 
ul_gph %>%
left_join(ul_nodes %>% select(name = ul_name, type = ur_type)) %>%
mutate(name = "") %>%
#mutate(colors = map_chr(.attrs, "type")) %>%
ggraph() + 
  geom_edge_link(arrow = arrow(length = unit(5, 'mm')), 
                 end_cap = circle(5, 'mm')) + 
  geom_node_label(aes(label = name , fill = type),size = 10) +
  NULL




pull(as_tibble(ll),name)

