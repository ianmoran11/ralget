#' Create ralget edge
#'
#' @param ...  objects stored as vertex attributes.
#' @export

load_package_silent <- function(package_name, verbose_error = FALSE) {
  success <- suppressWarnings(suppressMessages(
    requireNamespace(package_name, quietly = TRUE) # Use requireNamespace for silent check
  ))
  if (success) {
    # Construct the library() call as a string and evaluate it
    library_call <- paste0("library(", package_name, ", quietly = TRUE)")
    eval(parse(text = library_call))
    return(TRUE)
  } else {
    if (verbose_error) {
      cat(paste0("Error: Package '", package_name, "' could not be loaded.\n"))
    }
    return(FALSE)
  }
}