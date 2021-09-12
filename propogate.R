
product <- function(...){list(...) %>% reduce(`*`)}

const <- function(x){function(...){x}}

S01 <-   v("S01",   .func = const(10000))
I01 <-   v("I01",   .func = const(10))
BIS01 <- v("BIS01", .func = product)

S02 <-   v("S02",   .func = sum)
I02 <-   v("I02",   .func = sum)

SIR <- 
S01    * ( e(.func = function(.value){.value * .5} ) * BIS01  + 
           e(.func = function(.value){.value * 1} )  * S02 ) +

I01    * ( e(.func = function(.value){.value * .5} ) * BIS01  +
           e(.func = function(.value){.value * 1}) * I02 ) 

BIS01  *  (e(.func = function(.value){.value * 1} ) * S02  +
           e(.func = function(.value){.value * -1}) *  I01 ) 

wk <- 
SIR %>% 
mutate(order = node_topo_order())  %>%
 arrange(order) %>% 
 mutate(edge_funcs = map(row_number(), ~ .E()[.E() %>% pull(to) == .x,] %>% pull(.attrs) )) %>% 
 mutate(edge_args = map(row_number(), ~ .E()[.E() %>% pull(to) == .x,] %>% pull(from_name) )) %>%
 mutate(eval_statement = pmap_dbl(  
    list(name = name,.attrs = .attrs, edge_funcs= edge_funcs,edge_args= edge_args), 
     .f = function(...){
        wk <- list(...)
        do.call(
            wk$.attrs$.func, 
            map2(wk$edge_funcs,wk$edge_args, ~ do.call(.x[[1]], list(sym(.y))))
            )
            }
    )
) 





assign(wk[[1]]$name, do.call(wk[[1]]$.attrs$.func, wk[[1]]))
S01
assign(wk[[2]]$name, do.call(wk[[2]]$.attrs$.func, wk[[2]]))
I01
assign(wk[[2]]$name, 
do.call(wk[[3]]$.attrs$.func, 
    do.call(wk[[3]]$edge_funcs[[1]][[1]], list(sym(wk[[3]]$edge_args[1])))
    )


do.call(wk[[4]]$.attrs$.func, 
    do.call(wk[[4]]$edge_funcs[[1]][[1]], list(sym(wk[[4]]$edge_args[1])))
    ,
    do.call(wk[[4]]$edge_funcs[[2]][[1]], list(sym(wk[[4]]$edge_args[2])))
    )
# Calc edge values 

do.call(
  wk[[4]]$.attrs$.func, 
  map2(wk[[4]]$edge_funcs,wk[[4]]$edge_args, ~ do.call(.x[[1]], list(sym(.y))))
  )

wk %>% map(function(wk){
do.call(
  wk$.attrs$.func, 
  map2(wk$edge_funcs,wk$edge_args, ~ do.call(.x[[1]], list(sym(.y))))
  )
})

?do.call
)

SIR %>% 
 mutate(order = node_topo_order())  %>%
 arrange(order) %>% 
 activate("edges") %>%
 mutate(.src_args = map(from, ~ .N()[.x,".attrs"][[1]] ) ) %>%
 mutate(.edge_exprs  = 
    map2(.attrs,.src_args, 
    ~ paste("do.call(",.x[1],",",.y[[1]],")") %>% str_remove_all("\n") %>%
      parse(text = .x)
    ))  %>%
 activate("nodes") %>%
 mutate(.evaluation = 
  map_local(order = 1, mode = "in", 
  .f = function(node, neighborhood,graph,...){
      .edge_exprs = neighborhood %>% activate("edges") %>% pull(.edge_exprs)
      .func =  graph %>% filter(row_number()== node) %>% pull(.attrs) 
     list(node_func = .func,node_func_args = .edge_exprs) 
  })) %>% 
 pull(.evaluation)
 
 map(eval)jii

?map_local
do.call(sum,list(1,1))

plot(SIR)

SIR

plot(SIR)


BIS01  * ( e(-1) * S02    + e(1) * I02                  ) +
