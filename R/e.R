#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

e <- function(.name = "none", .type = "none", .unique = T, ...){



if(.unique){
  .id <- sample(letters,10,T) %>% paste(collapse = "")
  e_obj <- append(list(.name = .name, .type = .type, .unique = .unique, .id = .id),list(...))
}

if(!.unique){
  e_obj <- append(list(.name = .name, .type = .type, .unique = .unique),list(...))
}

  class(e_obj) <- c("ralget_edge", class(e_obj))

  e_obj

}
