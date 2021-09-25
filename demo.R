library(devtools)
document()
install()


# Test ----------------------------------------------------
circle <- v("a") * v("b") * v("c")
line <- v("1")*v("2")*v("3")

as_tibble(circle %x% line) %>% pull(name)
as_tibble(activate(circle %x% line,"edges")) 

l <- tribble(
    ~name,~x,~y,
   "a", 1,2,
   "b", 2,2,
   "c", 1,1,
   "d", 2,1)
 
layout_df <- as_tibble(graph) %>% left_join(l) %>% select(x,y)

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
