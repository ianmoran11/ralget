#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

cycle_period <- function(p_list, time_tracker) {

  # browser()
  # Extract elements of p list
  plan <- p_list[[1]]
  resource_pool <- p_list[[2]]

  # Re-evaluate executability
  executable_plan <- plan %>%
    update_status() %>%
    filter(!outstanding_deps & (executed == FALSE)) %>%
    arrange(desc(priority))
  
  executable_tasks <- pull(executable_plan, name)

  # Prepare for tasks accumulator
  plan_resource <- list(executable_plan, resource_pool, time_tracker)

  # apply for tasks accumulator
  executed_tasks <- append(list(plan_resource), executable_tasks) %>%
    reduce(try_task) %>%
    .[[1]]

  # Join newly executed tasks with non-executed tasks
  all_tasks_updated <-
    plan %>%
    as_tibble() %>%
    filter(!name %in% executable_tasks) %>%
    bind_rows(as_tibble(executed_tasks))

  # Join to tidygraph object
  plan <- suppressMessages(plan %>% select(name) %>% left_join(all_tasks_updated))

  # Add time record
  plan <- plan %>% mutate(start_time = time_tracker$start_time)

  # Return as list
  list(plan, resource_pool)
}
