``` r
library(ralget)
#> 
#> Attaching package: 'ralget'
#> The following object is masked from 'package:base':
#> 
#>     %x%

ralget::load_package_silent("devtools")
#> [1] TRUE
ralget::load_package_silent("tidyverse")
#> [1] TRUE
ralget::load_package_silent("igraph")
#> 
#> Attaching package: 'igraph'
#> The following objects are masked from 'package:lubridate':
#> 
#>     %--%, union
#> The following objects are masked from 'package:dplyr':
#> 
#>     as_data_frame, groups, union
#> The following objects are masked from 'package:purrr':
#> 
#>     compose, simplify
#> The following object is masked from 'package:tidyr':
#> 
#>     crossing
#> The following object is masked from 'package:tibble':
#> 
#>     as_data_frame
#> The following objects are masked from 'package:stats':
#> 
#>     decompose, spectrum
#> The following object is masked from 'package:base':
#> 
#>     union
#> [1] TRUE
ralget::load_package_silent("tidygraph")
#> 
#> Attaching package: 'tidygraph'
#> The following object is masked from 'package:igraph':
#> 
#>     groups
#> The following object is masked from 'package:stats':
#> 
#>     filter
#> [1] TRUE
ralget::load_package_silent("DiagrammeR")
#> 
#> Attaching package: 'DiagrammeR'
#> The following object is masked from 'package:igraph':
#> 
#>     count_automorphisms
#> [1] TRUE


ralget::load_package_silent("reprex")
#> [1] TRUE
ralget::load_package_silent("d3r")
#> [1] TRUE
ralget::load_package_silent("jsonlite")
#> 
#> Attaching package: 'jsonlite'
#> The following object is masked from 'package:purrr':
#> 
#>     flatten
#> [1] TRUE
ralget::load_package_silent("Hmisc")
#> 
#> Attaching package: 'Hmisc'
#> The following objects are masked from 'package:dplyr':
#> 
#>     src, summarize
#> The following objects are masked from 'package:base':
#> 
#>     format.pval, units
#> [1] TRUE


make_lemon_filling  <- v(name = "Make lemon filling")


print(make_lemon_filling)
#> # A tbl_graph: 1 nodes and 0 edges
#> #
#> # An unrooted tree
#> #
#> # A tibble: 1 × 2
#>   name               .attrs
#>   <chr>              <list>
#> 1 Make lemon filling <NULL>
#> #
#> # A tibble: 0 × 2
#> # ℹ 2 variables: from <int>, to <int>

ralget::to_json(make_lemon_filling)
#> Joining with `by = join_by(from)`
#> Joining with `by = join_by(to)`
#> {"edges":[],"vertices":[{"name":"Make lemon filling",".attrs":[{}],".waiting_edge_left":[{}],".waiting_edge_right":[{}]}],"directed":[true]}

make_lemon_filling  <- v(name = "Make lemon filling")
separate_egg  <- v(name = "Separate egg")
make_meringue  <- v(name = "Make meringue")
fill_crust  <- v(name = "Fill crust")
add_meringue  <- v(name = "Add meringue")
```

<sup>Created on 2025-03-25 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
