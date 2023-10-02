
#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

create_work_times <- function(n, interval, start_time = "2021-10-03-9-00" ){
  map(0:n, 
      ~ list(
        start_time = lubridate::ymd_hm(start_time) + duration(paste0("~ ",interval*.x," minutes")), 
        interval = duration(paste0("~ ",interval," minutes")))) %>% 
   map(as_tibble) %>% bind_rows()
  
  }
