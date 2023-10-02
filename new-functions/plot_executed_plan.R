#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export
 
plot_executed_plan <- function(comined){
  
  comined %>%
   mutate(resources = resources %>% map(names)) %>%
    unnest(resources) %>%
    mutate(resources = resources %>% str_replace_all("_"," ") %>% str_to_sentence()) %>%
    ggplot(aes(x = start_time, y = name, color = resources)) + 
    geom_line(size = 5,alpha = .75) +
    labs(y = NULL, x = "Time") + 
    # theme_ipsum() +
    ggtitle("Gantt Chart", "Weekend Plan") + 
    theme(panel.grid.minor = element_line(colour="grey", size=0.5)) +
    theme(
          strip.text.x = element_blank(),
          strip.background = element_rect(colour="white", fill="white"),
          legend.position=c(.87,.87),
          legend.background = element_rect(fill = "white", color = "grey")) + 
    theme(text = element_text(colour = "black"), axis.text =  element_text(colour = "black"))
}