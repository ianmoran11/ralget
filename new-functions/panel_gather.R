#' Set value for variable in DAG
#'
#' @param df simulated panel df.
#' @export

panel_gather <- function(df){
var_names <- names(df)
years <- var_names %>% str_extract_all("[0-9]+") %>% unlist() %>% unique() %>% sort
const_vars <- setdiff(var_names, c("sim_id","label")) %>% keep(!str_detect(.,"[0-9]"))  %>% as.list
new_vars <- map(const_vars,~ .x %>% paste(.,years,sep = "_t"))

const_df <- 
    map2(const_vars, new_vars,
    function(const,new){
        map(new,function(each_new){
            tibble(!!sym(each_new):= df[[const]])
        })
    }
    ) %>% 
    bind_cols()

df %>% 
    select(-unlist(const_vars)) %>% 
    bind_cols(const_df) %>% 
    mutate(sim_id = paste0(sim_id,":",label)) %>%
    gather(Variable,Value, -sim_id, -label)  %>%
    separate(Variable, c("Variable", "Period"), sep = "_") %>%
    mutate(Period  = Period %>% str_remove("t") %>% as.numeric()) 


}