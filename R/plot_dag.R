
#' Plot DAG.
#'
#' @param g DAG 
#' @export
 
dag_plot <- function(g){
    coord_df <- 
tribble(
   ~x, ~y, ~name ,
  0.5,  3,    "a",    
  1.0,  2,    "m",    
  0.5,  1,    "x",    
  1.5,  3,    "c",    
  1.5,  1,    "y",    
  )
coord_df01 <- as_tibble(g) %>% left_join(coord_df) %>% select(x,y)

g %>% 
activate("edges") %>%
mutate(coeff = map(.attrs, ".func") %>% 
               map_dbl(possibly(~ do.call(.x, list(1)),NA_real_)) %>%
               map_chr(~ ifelse(is.na(.x),"", as.character(.x)))) %>% 
ggraph(
 # layout = coord_df01
  ) + 
 geom_edge_link(
        aes(end_cap = circle(30, "pt"),
            start_cap = circle(30, "pt"),
           # label = coeff
            ),
            label_size = 5,
     label_dodge = unit(10.5, 'mm'),
        edge_colour = "black",
        arrow = arrow(
          angle = 15,
          length = unit(0.15, "inches"),
          ends = "last",
          type = "closed"
        ), edge_width = 1.2, 
      ) +
      geom_node_point(col = "grey66", size = 25, show.legend = FALSE) +
      geom_node_text(aes(label = name), size = 10) +
      theme_graph() + 
         xlim(c(.25,1.75)) + ylim(c(0.5,3.5)) +
NULL
}

