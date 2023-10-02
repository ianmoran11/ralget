#' Simulate data from a dag
#'
#' @param df plot joint distributions of a simulated df 
#' @export
#' 
plot_joint_distributions <- function(df){

df %>%
select(-sim_id) %>% 
ggplot(., aes(x = .panel_x, y = .panel_y, fill = label, colour = label)) + 
  geom_point(shape = 16, size = 0.5,  alpha= .3) + 
  geom_autodensity(alpha = 0.7, colour = NA, position = 'identity') + 
  facet_matrix(vars(-label), layer.diag = 2) +
  scale_fill_manual(name = NULL, values = c("red","blue","grey" )) +
  scale_color_manual(name = NULL,values = c("red","blue","grey" )) +
  theme_bw() +
  theme(legend.position="bottom") +
  theme(text=element_text(size=15))
}