
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ralget

Ralget creates algebraic graphs in R.

## Installation

You can install the evelopment version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ianmoran11/ralget")
```

## Example

This is a basic example which shows you how to solve a common problem:

# The building blocks of charts

### Vertices

Vertices are created with the `v()` function, which takes a name and
list of attributes associated with the vertex. This creates a
ralget/tidygraph object:

``` r
v("x", Latitude=  78.26077, Longitude=  -94.11077)
#> # A tbl_graph: 1 nodes and 0 edges
#> #
#> # A rooted tree
#> #
#> # Node Data: 1 × 2 (active)
#>   name  .attrs          
#>   <chr> <list>          
#> 1 x     <named list [2]>
#> #
#> # Edge Data: 0 × 2
#> # … with 2 variables: from <int>, to <int>
```

### Combining Vertices

The `+` operator overlays graphs.

The `*` operator creates a link from each vertex on the right to each
vertex on the left.

    #> Joining, by = c("name", ".attrs")
    #> Joining, by = c("from", "to")
    #> Joining, by = c("name", ".attrs")
    #> # A tbl_graph: 3 nodes and 1 edges
    #> #
    #> # A rooted forest with 2 trees
    #> #
    #> # Node Data: 3 × 2 (active)
    #>   name  .attrs
    #>   <chr> <list>
    #> 1 p     <NULL>
    #> 2 q     <NULL>
    #> 3 s     <NULL>
    #> #
    #> # Edge Data: 1 × 3
    #>    from    to new  
    #>   <int> <int> <lgl>
    #> 1     1     2 TRUE

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

``` r
g2 <- q*s+q*r
#> Joining, by = c("name", ".attrs")
#> Joining, by = c("from", "to")
#> Joining, by = c("name", ".attrs")
#> Joining, by = c("from", "to")
#> Joining, by = c("name", ".attrs")
g1 <- p*q+s
#> Joining, by = c("name", ".attrs")
#> Joining, by = c("from", "to")
#> Joining, by = c("name", ".attrs")
gg <- (g1+g2)
#> Joining, by = c("name", ".attrs")
gg %>% plot()
#> Using `tree` as default layout
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

``` r
g3 <- s*r
#> Joining, by = c("name", ".attrs")
#> Joining, by = c("from", "to")
(g1*g3) %>% plot(loops = T) 
#> Joining, by = c("name", ".attrs")
#> Joining, by = c("from", "to")
#> Using `stress` as default layout
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />
