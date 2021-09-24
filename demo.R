library(devtools)
document()
install()
usethis::use_testthat()
usethis::use_test(name = "commutative-addition")
usethis::use_test(name = "distributive-multiplication")
usethis::use_pkgdown()

usethis::use_coverage()


#rm(print.ralget)
plotter <- function(graph){

#graph <- (v("a")+ v("b"))

l <- tribble(
    ~name,~x,~y,
   "a", 1,2,
   "b", 2,2,
   "c", 1,1,
   "d", 2,1)
 
layout_df <- as_tibble(graph) %>% left_join(l) %>% select(x,y)

if(nrow( as_tibble(activate(graph,"edges"))) == 0){
p <- 
  graph %>% 
      ggraph(layout_df)  +
      geom_node_point(col = "grey66", size = 20, show.legend = FALSE) +
      geom_node_text(aes(label = name), size =15) +
      theme_graph() + xlim(.5,2.5) + ylim(.5,2.5)

return(p)
}

  graph %>% 
      ggraph(layout_df)  +
      geom_edge_link(
        aes(end_cap =   circle(25, "pt"),
            start_cap = circle(25, "pt")),
        edge_colour = "black",
        arrow = arrow(
          angle = 15,
          length = unit(0.15, "inches"),
          ends = "last",
          type = "closed"
        ),
        width = 1.2
      ) +
      geom_node_point(col = "grey66", size = 20, show.legend = FALSE) +
      geom_node_text(aes(label = name), size = 15) +
      theme_graph() + xlim(.5,2.5) + ylim(.5,2.5)
}

v("a") + v("b") * (v("c") + v("d")) 


a <- v("a")
b <- v("b")
c <- v("c")
d <- v("d")

a + b * (c + d)
































g <- (v("a") + v("b")) * (v("c") + v("d")))
plotter(g)
g
plotter(v("a"))
plotter(v("a") + v("b"))


print.ralget <- function(g){
   print(plotter(g))
   class(g) <- class(g)[-1] 
   print(g)
    }
print.ralget <- function(g){g}
rm(print.ralget)
plotter(g,l)
