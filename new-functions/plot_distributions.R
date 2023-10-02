#' Simulate data from a dag
#'
#' @param df plot joint distributions of a simulated df 
#' @export
#' 
plot_distributions <- function(df){

df %>%
ggplot(aes(x = value, color = label, fill = label)) + 
geom_density(alpha = .65) + 
facet_wrap(~var, scales = "free") +
 theme_bw() +
  theme(legend.position="bottom") +
  scale_fill_manual(name = NULL, values = c("red","blue","grey" )) +
  scale_color_manual(name = NULL,values = c("red","blue","grey" )) 

}