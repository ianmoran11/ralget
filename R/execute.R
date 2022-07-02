#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

execute <- function(plan, resource_pool, timeslots, ralget = FALSE) {
  # browser()
  # Create list of plan and resources for accumulation
  if(ralget == FALSE){
  p_list <- list(
    plan = plan %>% form() %>% order_plan() %>% update_status(),
    resources = resource_pool
  )
  }
  
  if(ralget == TRUE){
  p_list <- list(
    plan = plan %>%  order_plan() %>% update_status(),
    resources = resource_pool
  )
  }

  # Convert from dataframe to list
  time_tracker_list <- 
  map2(timeslots$start_time, timeslots$interval, ~list(start_time = .x, interval = .y))
  
  # Accumulate over time slots
  result <- append(list(p_list), time_tracker_list) %>% accumulate(cycle_period)

  # Accumulate over time slots
 comined <- result

  insert_start_time <- comined[[2]][[1]] %>% pull(start_time) %>% .[[1]]
  
  bind_rows(map(comined,1) %>% map(as_tibble)) %>%
    unnest(time) %>%
    mutate(start_time = ifelse(is.na(start_time), insert_start_time,start_time) %>% lubridate::as_datetime()) %>% 
    group_by(name) %>%
    mutate(time_diff = -(time - lag(time,n = 1,order_by = start_time) )) %>%
    filter(!is.na(time_diff) & time_diff != 0) %>%
    ungroup() %>%
    mutate(name = fct_reorder(name,start_time,.fun = reverse_min))



}
