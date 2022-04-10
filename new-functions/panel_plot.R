#' Set value for variable in DAG
#'
#' @param df panel formated simulated DAG.
#' @export

panel_plot <- function(df){
df %>% 
    ggplot(aes(x = Period, y = Value, group = sim_id, color = label)) + 
        geom_line(alpha = .0075) + 
        scale_color_manual(name = NULL, values = c("red","blue","grey" )) +
        facet_wrap(~Variable, scales = "free") +  
        stat_summary(aes(group = label),fun=mean,geom="line", size = 1)  +
        theme_minimal() +
        theme(strip.text = element_text(face = "bold")) +
        theme(legend.position="bottom")
}