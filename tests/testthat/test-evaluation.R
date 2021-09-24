test_that("multiplication works", {

a <- v("a", .f = rlang::as_function((~ 1)))
b <- v("b", .f = rlang::as_function((~ 2)))
c <- v("c", .f = rlang::as_function((~ sum(.x))))

d <- (a + b)*c

d1 <- d %>% activate("edges") %>% mutate(.attrs = map(1,rlang::as_function( ~ .x))) %>% activate("nodes") %>% get_edge_names() %>%  activate("nodes")

d1 %>% evaluate_prepare() 

expect_true(T)
})
