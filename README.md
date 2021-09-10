
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ralget

Ralget creates algebraic graphs in R.

### Installation

You can install the evelopment version from
[GitHub](https://github.com/) with: You can install the evelopment
version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
# install.packages("devtools")
devtools::install_github("ianmoran11/ralget")
```

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
#> # Node Data: 1 x 2 (active)
#>   name  .attrs          
#>   <chr> <list>          
#> 1 x     <named list [2]>
#> #
#> # Edge Data: 0 x 2
#> # … with 2 variables: from <int>, to <int>
```

### Combining Vertices

Take the following vertices:

``` r
p <- v("p"); q <- v("q"); s <- v("s"); r <- v("r"); 
```

The following expressions…

``` r
g1 <- p*q+s
g2 <- q*s+q*r
g3 <- s*r
```

… produce the following graphs:
<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

#### Overlaying graphs ( + )

The `+` operator overlays graphs.

``` r
g1 + g2
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

#### Connecting graphs ( \* )

The `*` operator creates a link from each vertex on the right to each
vertex on the left.

``` r
g1 * g3
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" />

#### The Cartesian product ( %x% )

``` r
x %x% y
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />
