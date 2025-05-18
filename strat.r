
library(ggraph)
install.packages("patchwork")
library(patchwork)


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



ul_gph <- 
tidygraph::as_tbl_graph(ul_edges %>% select(from,to), directed = T) 


ul_plot <- 
ul_gph %>%
left_join(ul_nodes %>% select(name = ul_name, type = ur_type, species =ur_species )) %>%
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
    alpha = ifelse(species  == "place", 1, 0)),size = 10) +
  geom_node_text(aes(
    label = ifelse(species  == "place", name, "")), color = "white",size = 3.5) +
  guides(fill = "none", alpha = "none", size = "none") +
  NULL

ll_plot_data <- 
ll %>%  
mutate(type = map_chr(.attrs, "type")) %>%
mutate(species = map_chr(.attrs, "species")) 

ll_plot <-
ll_plot_data %>% 
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
    alpha = ifelse(species  == "place", 1, 0)),size = 10) +
  geom_node_text(aes(
    label = ifelse(species  == "place", name, "")), color = "white",size = 3.5) +
  guides(fill = "none", alpha = "none", size = "none") +
  NULL


ur_plot <- 
ur %>%  
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
    alpha = ifelse(species  == "place", 1, 0)),size = 10) +
  geom_node_text(aes(
    label = ifelse(species  == "place", name, "")), color = "white",size = 3.5) +
  guides(fill = "none", alpha = "none", size = "none") +
  NULL 



(ul_plot + ur_plot) / 
(ll_plot + ggplot())
