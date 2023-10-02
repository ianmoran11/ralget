
#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

try_task <- function(plan_resource, task) {
  #   browser()
  # Extract elements from list
  plan <- plan_resource[[1]]
  resources <- plan_resource[[2]]
  time_tracker <- plan_resource[[3]]

  # Identify resources relevant to tasks
  used_resources <- plan %>%
    filter(name == task) %>%
    pull(resources) %>%
    .[[1]]

  # Update available resources based on task requirements
  new_resources <-
    map2(names(used_resources), used_resources, function(.n, .r) {
      resources[[.n]] <- resources[[.n]] - .r
      resources
    })

  # Update available resources based on task requirements
  result <- map_lgl(new_resources, ~ all(.x >= 0))

  # Update time and execution status of task
  plan1 <-
    plan %>%
    mutate(time = pmap(list(name, time, task), function(name, time, task) {
      time - ifelse((name == task) & result, time_tracker$interval, duration("0 min"))
    })) %>%
    mutate(executed = ifelse(time <= 0, TRUE, executed))

  # Update resources
  resources1 <- ifelse(result, new_resources, list(resources))

  # Return list
  list(plan1, resources1[[1]], time_tracker)
}
