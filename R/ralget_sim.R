
#' concat to vectors  for data sim
#'
#' @param x  vertices
#' @param y  vertices
#' @param n  vertices
 
render <- function(x,y,n){
   t1 = x %>%  paste(collapse = ",\n ")  %>% paste0("df2 <- tibble(",.,")") 
   t2 = y %>% paste(collapse = ",\n ")  %>% paste0("df2 %>% mutate(",.,")") %>% 
 str_replace_all("rnorm\\(1", paste0("rnorm(",n,""))
   list(t1,t2)
   }

#' simulate data from a ralget 
#'
#' @param graph ralget
#' @param n number of observations
#' @export

ralget_sim <- function(graph, n = 1){


intermediate <- 
graph  %>% mutate(form = map_chr(row_number(), 
~ filter(.E(), to == .x) %>% as_tibble() %>% mutate(out = paste(.attrs, from_name, sep = "*"))  %>% 
pull(out) %>% paste(collape = " * ")
 # mutate(form = map2(from_name, .attr, ~paste(.x,.y[[1]],sep ="*"))
 )) %>%
 mutate(init = map_chr(.attrs, ~ .x %>% as.character() %>%  str_remove("~"))) %>%
 mutate(expr = paste(init, form, sep = "+") %>% str_remove("\\+$")) %>%
 mutate(mu = paste0(name," = ", expr)) %>%
 mutate(mu2= paste0(name," = ", "rep(NA,",n,")")) %>%
 mutate(order = node_topo_order())  %>%
 as_tibble() %>%
 arrange(order)  

 render(intermediate$mu2,intermediate$mu,n) %>% paste(collapse = "\n") %>% parse(text = .) %>% eval()


}