library(rlang)
sumv <- function(...){ list(...) %>% reduce(`+`)}

z1 %>% pull(.attrs)

z1 <- v("z1", form = quo(rnorm(1,100,15))
x1 <- v("x1", form = quo(rnorm(1,100,15)))
x2 <- v("x2", form = quo(rnorm(1,100,15)))
y <- v("y", form = quo(rnorm(1,0,15)))

myquo <- as_tibble(x1) %>% pull(.attrs) %>% .[[1]]
rlang::eval_tidy(myquo[[1]])

reg <-   (sumv(x1*e(.5), x2*e(.3))*y) + ((z1*sumv(e(.4)*x1, e(.3)*y))) 
 
reg %>% plot() +
    geom_edge_link(aes(label = .attrs), 
                   angle_calc = 'along',
                   label_dodge = unit(2.5, 'mm'),
                   arrow = arrow(length = unit(4, 'mm')), 
                   end_cap = circle(3, 'mm')) 

ggraph(reg, layout = 'graphopt') + 
    geom_edge_link(aes(label = .attrs), 
                   angle_calc = 'along',
                   label_dodge = unit(2.5, 'mm'),
                   arrow = arrow(length = unit(4, 'mm')), 
                   end_cap = circle(3, 'mm')) + 
    geom_node_point(size = 5)
print("---------------------------------------------------")
t1 <- Sys.time()

for(i in 1:100){

reg %>% 
  mutate(value = map_dbl(.attrs, ~ .x[[1]] %>%  eval_tidy)) %>% 
  mutate(order = node_topo_order()) %>% 
  mutate(starter = name == "z1") %>% 
  mutate(env = map_local_dbl(order = 1, .f = function(graph,node,neighborhood,...){
    node_df = as_tibble(graph) %>% filter(row_number()== node)

    neibours = neighborhood  %>% activate("edges") %>% get_edge_names() %>%
    filter(to_name == node_df$name) %>%
    mutate(value = map_dbl(from_name, ~ neighborhood %>% filter(name == .x) %>% pull(value))) %>%
    as_tibble() %>% unnest(.attrs) 

    value = sum(neibours$.attrs * neibours$value) + node_df$value

 #    list(node_df, neibours, value)
value
   })) 

}
t2 <- Sys.time()

t2 - t1


al <- list(a = 0)
a = 0 

t1 <- Sys.time()
for(i in 1:10^7){

al$a <-  al$a + 1

}
t2 <- Sys.time()
t2 - t1

reg %>% pull(.attrs) %>% .[[1]]  %>% as.character() %>%  str_remove("~")

render <- function(x,y){
   t1 = x %>%  paste(collapse = ",\n ")  %>% paste0("df2 <- tibble(",.,")") 
   t2 = y %>% paste(collapse = ",\n ")  %>% paste0("df2 %>% mutate(",.,")") %>% 
 str_replace_all("rnorm\\(1", "rnorm(10^7")
   list(t1,t2)
   }

df1 <- tibble(x2 = rep(NA,10^7),z1= rep(NA,10^7), x1=rep(NA,10^7),y=rep(NA,10^7))

library(magrittr)
res <- 
reg  %>% mutate(form = map_chr(row_number(), 
~ filter(.E(), to == .x) %>% as_tibble() %>% mutate(out = paste(.attrs, from_name, sep = "*"))  %>% 
pull(out) %>% paste(collapse = " + ")
 # mutate(form = map2(from_name, .attr, ~paste(.x,.y[[1]],sep ="*"))
 )) %>%
 mutate(init = map_chr(.attrs, ~ .x %>% as.character() %>%  str_remove("~"))) %>%
 mutate(expr = paste(init, form, sep = "+") %>% str_remove("\\+$")) %>%
 mutate(mu = paste0(name," = ", expr)) %>%
 mutate(mu2= paste0(name," = ", "rep(NA,10^7)")) %>%
 mutate(order = node_topo_order())  %>%
 as_tibble() %>%
 arrange(order) %$% 
  render(mu2,mu) %>% paste(collapse = "\n") %>% parse(text = .) %>% eval()
  j
library(broom)

res %>% lm(y ~ x1 + x2 + z1, data =. ) %>% tidy

graph_is_dag()
 pull(mu) %>% paste(collapse = ",\n ")  %>% paste0("df1 %>% mutate(",.,")") %>% 
 str_replace_all("rnorm\\(1", "rnorm(10^7")  %>% 
 parse(text = .)   %>% eval()


with_graph(reg, graph_is_dag())
