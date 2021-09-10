
#' Add two ralget graphs
#'
#' @param g a ralget graph
#' @export
#' @S3method  "plot" ralget

plot.ralget <- function(g,loops = FALSE,...){

  coords  = tribble(~x, ~y, 1,1,1,2,2,3,2,4) %>% as.data.frame


if(loops == T){

p <-   g  %>%
    ggraph(...)  +
    geom_edge_link(
      aes(end_cap = circle(10, "pt"),
          start_cap = circle(10, "pt")),

      edge_colour = "black",
      arrow = arrow(
        angle = 15,
        length = unit(0.15, "inches"),
        ends = "last",
        type = "closed"
      )
    ) +
    geom_edge_loop(end_cap = circle(10, "pt"),start_cap = circle(10, "pt"),arrow = arrow(
      angle = 15,
      length = unit(0.15, "inches"),
      ends = "last",
      type = "closed"
    ) ) +

    geom_node_point(col = "grey66", size = 10, show.legend = FALSE) +
    geom_node_text(aes(label = name)) +
    theme_graph()

# ?geom_edge_loop

return(p)
}

  p <-   g  %>%
    ggraph(...)  +
    geom_edge_link(
      aes(end_cap = circle(10, "pt"),
          start_cap = circle(10, "pt")),

      edge_colour = "black",
      arrow = arrow(
        angle = 15,
        length = unit(0.15, "inches"),
        ends = "last",
        type = "closed"
      )
    ) +
    geom_node_point(col = "grey66", size = 10, show.legend = FALSE) +
    geom_node_text(aes(label = name)) +
    # geom_edge_loop(end_cap = circle(10, "pt")) +
    theme_graph()

  return(p)



}
