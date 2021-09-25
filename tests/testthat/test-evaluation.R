test_that("multiplication works", {

a <- v("a", .f = rlang::as_function(~ 1))
b <- v("b", .f = rlang::as_function(~ 2))
c <- v("c", .f = rlang::as_function(~ rsum(.x)))

e1 <- e(.func = function(.value){.value})

d <- (a*e1 + b*e1)*c

result <- d %>% evaluate() %>% pull(eval_statement) %>% unlist()

expect_true(all(result == c(1,2,1)))
})
