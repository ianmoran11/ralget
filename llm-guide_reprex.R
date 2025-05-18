#' ---
#' output: reprex::reprex_document
#' ---

library(ralget)

ralget::load_package_silent("devtools")
ralget::load_package_silent("tidyverse")
ralget::load_package_silent("igraph")
ralget::load_package_silent("tidygraph")
ralget::load_package_silent("DiagrammeR")


ralget::load_package_silent("reprex")
ralget::load_package_silent("d3r")
ralget::load_package_silent("jsonlite")
ralget::load_package_silent("Hmisc")


make_lemon_filling  <- v(name = "Make lemon filling")


print(make_lemon_filling)

ralget::to_json(make_lemon_filling)

make_lemon_filling  <- v(name = "Make lemon filling")
separate_egg  <- v(name = "Separate egg")
make_meringue  <- v(name = "Make meringue")
fill_crust  <- v(name = "Fill crust")
add_meringue  <- v(name = "Add meringue")
