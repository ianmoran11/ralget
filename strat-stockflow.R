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
library(ggraph)
library(patchwork)


# Places 
S   <- v("S",   species = "place", type = "pink") 
I   <- v("I",   species = "place", type = "pink") 

# Variables 
N <-  v("N",   species = "sum_var", type = "blue")
NS <-  v("NS",   species = "var", type = "cyan")
NI <-  v("NI",   species = "var", type = "cyan")

# Flows 
newInfectious  <- v("newInfectious", species = "flow", type = "grey")
newRecovery  <-   v("newRecovery", species = "flow", type = "grey")
birth  <-         v("birth", species = "flow", type = "grey")
deathS  <-        v("deathS", species = "flow", type = "grey")
deathI  <-        v("deathI", species = "flow", type = "grey")
id_S  <-          v("id_S", species = "flow", type = "grey")
id_I  <-          v("id_I", species = "flow", type = "grey")


diagram(SIS)

SIS <- 
# Vars 
(N * e(t="v") * birth) + 
(birth * e(t="v") * S) +
(NS * e(t="v") * newInfectious) +
(NI * e(t="v") * newInfectious) +

# S -------------------------------
## Flows 
(S * deathS) +
(S * newInfectious) + (newInfectious * I) +
(S * id_S) + (id_S * S) +

## Vars 
(S * e(t="v") * deathS) +
(S * e(t="v") * newInfectious     )  +
(S * e(t="v") * id_S              ) +
(S * e(t="v") * N           ) + 
(S * e(t="v") * NS) +

# I -------------------------------
## Flows 
(I * id_I              ) + (id_I * I              ) +
(I * newRecovery       ) + (newRecovery * S       ) +
(I * deathI            ) +

## Vars 
(I * e(t="v") * NS) +
(I * e(t="v") * N) + 
(I * e(t="v") * NI)  +
(I * e(t="v") * deathI            ) +
(I * e(t="v") * id_I              ) +
(I * e(t="v") * newRecovery       ) +
NULL

#SIS %>% as_tibble() %>% print(n = Inf)
#SIS %>% ralget::get_edge_names() %>% as_tibble() %>% print(n = Inf)

SIS %>%  
mutate(type = map_chr(.attrs, "type")) %>%
mutate(species = map_chr(.attrs, "species")) %>%
ggraph() + 
  geom_edge_arc(arrow = arrow(length = unit(2, 'mm')), 
                 end_cap = circle(7, 'mm'), strength = 0.05) + 
  geom_node_label(aes(
    label = ifelse(species  == "transition", "   ",""),  
    fill = type,
    alpha = ifelse(species  == "transition", 1,0)
    ),
    size = 10) +
  geom_node_point(aes(
    alpha = ifelse(species  == "place", 1, 0)),size = 10, color = "grey") +
  geom_node_text(aes(
    label = ifelse(species  == "place", name, name)), color = "black",size = 3.5) +
  guides(fill = "none", alpha = "none", size = "none") +
  NULL 




# Places 
M   <- v("M",   species = "place", type = "pink") 
F   <- v("F",   species = "place", type = "pink") 

# Variables 
N <-  v( "N",   species = "sum_var", type = "blue")

NS_F <-  v("NS_F",   species = "var", type = "green")
NI_F <-  v("NI_F",   species = "var", type = "cyan")

NS_M <-  v("NS_M",   species = "var", type = "green")
NI_M <-  v("NI_M",   species = "var", type = "cyan")

# Flows 
newInfectiousM  <- v("newInfectiousM", species = "flow", type = "grey")
birthM  <-         v("birthM", species = "flow", type = "grey")
deathsM  <-        v("deathsM", species = "flow", type = "grey")
id_M  <-          v("id_M", species = "flow", type = "grey")

newInfectiousF  <- v("newInfectiousF", species = "flow", type = "grey")
birthF  <-         v("birthF", species = "flow", type = "grey")
deathsF  <-        v("deathsF", species = "flow", type = "grey")
id_F  <-          v("id_F", species = "flow", type = "grey")


MF <- 
## Flows 
(M * deathsM) +
(M * newInfectiousM) + (newInfectiousM * M) +
(M * id_M) + (id_M * M) +

## Vars 
(M * e("v")  * N) +
(M * e("v")  * NI_M) +
(M * e("v")  * NS_M) +

(M * e("v") * deathsM) +
(M * e("v") * newInfectiousM) +
(M * e("v") * id_M) +

# F -------------------------------
## Flows 
(F * deathsF) +
(F * newInfectiousF) + ( newInfectiousF * F) +
(F * id_F) + (id_F * F) +
## Vars 
(F * e("v") * N) +
(F * e("v") * NI_F) +
(F * e("v") * NS_F) +

(F * e("v") * deathsF) +
(F * e("v") * newInfectiousF) +
(F * e("v") * id_F) +

# Vars ------------------------------
## N
(N * e("v") * birthM) +
(N * e("v") *  birthF) +
##NI_M +
(NI_M * e("v") * newInfectiousM) +
(NI_M * e("v") * newInfectiousF) +
##NS_M +
(NS_M * e("v") * newInfectiousM) +
(NS_M * e("v") * newInfectiousF) +
##NI_F +
(NI_F * e("v") * newInfectiousM) +
(NI_F * e("v") * newInfectiousF) +
##NS_F +
(NS_F * e("v") * newInfectiousM) +
(NS_F * e("v") * newInfectiousF) 


MF %>% 
mutate(type = map_chr(.attrs, "type")) %>%
mutate(species = map_chr(.attrs, "species")) %>%
ggraph() + 
  geom_edge_arc(arrow = arrow(length = unit(2, 'mm')), 
                 end_cap = circle(7, 'mm'), strength = 0.05) + 
  geom_node_label(aes(
    label = ifelse(species  == "transition", "   ",""),  
    fill = type,
    alpha = ifelse(species  == "transition", 1,0)
    ),
    size = 10) +
  geom_node_point(aes(
    alpha = ifelse(species  == "place", 1, 0)),size = 10, color = "grey") +
  geom_node_text(aes(
    label = ifelse(species  == "place", name, name)), color = "black",size = 3.5) +
  guides(fill = "none", alpha = "none", size = "none") +
  NULL 

id <- \(x)x

MF_nodes <- 
  MF %>% 
    mutate(type = map_chr(.attrs, "type")) %>%
    mutate(species = map_chr(.attrs, "species")) %>%
    as_tibble() %>% 
    select(name, type, species) %>%
    id

SIS_nodes <- 
  SIS %>%
    mutate(type = map_chr(.attrs, "type")) %>%
    mutate(species = map_chr(.attrs, "species")) %>%
    as_tibble() %>% 
    select(name, type, species) %>%
    id


places <- 
full_join(
  MF_nodes %>% filter(species == "place") %>% mutate(joiner = 1),
  SIS_nodes  %>% filter(species == "place")  %>% mutate(joiner = 1),
  by = "joiner",
  suffix = c("MF","SIS")
) %>% 
mutate(names = paste0(nameMF, " || ", nameSIS)) %>% pull(names)

EDGES_MF <- 
MF %>% 
  mutate(type = map_chr(.attrs, "type")) %>%
  mutate(species = map_chr(.attrs, "species")) %>%
  mutate(parent_nodes = local_members(order = 1, mode = "in", mindist = 1)) %>%
  mutate(parent_nodes = map(parent_nodes,~ .N() %>% filter(row_number() %in% .x) %>% select(name,type,species) %>% set_names(paste0(names(.),"_p")))) %>%
  mutate(child_nodes = local_members(order = 1, mode = "out", mindist = 1)) %>%
  mutate(child_nodes = map(child_nodes,~ .N() %>% filter(row_number() %in% .x) %>% select(name,type,species) %>% set_names(paste0(names(.),"_c")))) %>%
  select(name,type, species, parent_nodes, child_nodes) %>%
  as_tibble() %>%
  unnest(parent_nodes) %>%
  unnest(child_nodes) %>%
  mutate(name_b = paste(name_p,name,name_c, sep = "|->|")) %>%
  mutate(type_b = paste(type_p,type,type_c, sep = "|->|")) %>%
  mutate(species_b = paste(species_p,species,species_c, sep = "|->|")) %>%
  set_names(paste0(names(.),"_mf"))

EDGES_SIS <- 
SIS %>% 
  mutate(type = map_chr(.attrs, "type")) %>%
  mutate(species = map_chr(.attrs, "species")) %>%
  mutate(parent_nodes = local_members(order = 1, mode = "in", mindist = 1)) %>%
  mutate(parent_nodes = map(parent_nodes,~ .N() %>% filter(row_number() %in% .x) %>% select(name,type,species) %>% set_names(paste0(names(.),"_p")))) %>%
  mutate(child_nodes = local_members(order = 1, mode = "out", mindist = 1)) %>%
  mutate(child_nodes = map(child_nodes,~ .N() %>% filter(row_number() %in% .x) %>% select(name,type,species) %>% set_names(paste0(names(.),"_c")))) %>%
  select(name,type, species, parent_nodes, child_nodes) %>%
  as_tibble() %>%
  unnest(parent_nodes) %>%
  unnest(child_nodes) %>%
  mutate(name_b = paste(name_p,name,name_c, sep = "|->|")) %>%
  mutate(type_b = paste(type_p,type,type_c, sep = "|->|")) %>%
  mutate(species_b = paste(species_p,species,species_c, sep = "|->|")) %>%
  set_names(paste0(names(.),"_mf"))
  unique()

NODE_PRODUCT <- 
full_join(
  MF_nodes %>% mutate(joiner = 1),
  SIS_nodes %>% mutate(joiner = 1),
  by = "joiner",
  suffix = c("L","R")
) %>% 
mutate(name = paste0(nameL, "|X|", nameR)) %>% 
mutate(type = paste0(typeL, "|X|",typeR)) %>% 
mutate(species = paste0(speciesL, "|X|",speciesR)) %>%
select(-joiner) %>%
select(name, type, species, matches("L"), matches("R")) 

EDGE_PRODUCT <-
full_join(
  EDGES_MF %>% mutate(joiner = 1),
  EDGES_SIS %>% mutate(joiner = 1),
  by = "joiner",
  suffix = c("L","R")
)

EDGE_PRODUCT %>%
filter(species_b_mfL == "flow" & species_b_mfR == "flow") %>%
