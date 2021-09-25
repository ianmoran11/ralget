library(devtools)
document()
install()

# Test ----------------------------------------------------
circle <- v("a") * v("b") * v("c")
line <- v("1")*v("2")*v("3")

as_tibble(circle %x% line) %>% pull(name)
as_tibble(activate(circle %x% line,"edges")) 

a <- v("a")
b <- v("b")
c <- v("c")
d <- v("d")

g <-
  (a * b(9) + m * b(1)) * x +
  (c * b(2) + m * b(5)) * y +
  (a * b(3) + c * b(5)) * m

g %>% evaluate_prepare() %>% evaluate_execute()


h <- (m * b(2) + x * b(1)) * y
h %>% evaluate_prepare() %>% evaluate_execute()


q <- (m * b(2) + x * b(1)) * y  +  ( y * b(2)*c)
q %>% evaluate_prepare() %>% filter(row_number() == 1) %>% evaluate_execute()
q %>% evaluate_prepare() %>% filter(row_number() <= 2) %>% evaluate_execute()
q %>% evaluate_prepare() %>% evaluate_execute()
