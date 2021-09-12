
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ralget

Ralget creates and combines graphs with algebraic operations.

### Combining Vertices

Take the following vertices:

``` r
p <- v("p") 
q <- v("q") 
s <- v("s") 
r <- v("r") 
```

The `+` operator places vertices in the same graph.  
The `*` operator joins one vertex to another.

``` r
g1 <- p * q + s
g2 <- q * s + q* r
g3 <- s * r
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

### Combining graphs

#### Overlaying graphs ( + )

The `+` operator overlays graphs.

``` r
g1 + g2
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

#### Connecting graphs ( \* )

The `*` operator creates a link from each vertex in the first graph to
each vertex in the second graph.

``` r
g1 * g3
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

#### The Cartesian product ( %x% )

The `%x%` operator creates the graph product.

``` r
x %x% y
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

### Some more on vertices

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

### Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ianmoran11/ralget")
```

## Algegraic laws

### Addition is commutative

*V*<sub>1</sub> + *V*<sub>2</sub> = *V*<sub>2</sub> + *V*<sub>1</sub>

``` r
(v1+v2)==(v2+v1)
#> [1] TRUE
```

*V*<sub>1</sub> × *V*<sub>2</sub> ≠ *V*<sub>2</sub> × *V*<sub>1</sub>

``` r
(v1*v2)==(v2*v1)
#> [1] FALSE
```

### Multiplication is distributive

``` r
(v1*(v2+v3))==((v1*v2)+(v1*v3))
#> [1] TRUE
```

*V*<sub>1</sub> × (*V*<sub>2</sub>+*V*<sub>3</sub>) = *V*<sub>1</sub> × *V*<sub>2</sub> + *V*<sub>1</sub> × *V*<sub>3</sub>

``` r
((v2+v3)*v1)==((v2*v1)+(v3*v1))
#> [1] TRUE
```

### Edges

Edge attributes are added by interleaving e() between graph
multiplication.

Here’s a simple example:

``` r
v("X1") * e("E:X1.X2") * v("X2")
```

<img src="man/figures/README-unnamed-chunk-20-1.png" width="100%" />

This provides a framework for constructing and simulating data from
DAGs.

``` r
z1 <- v("z1", form = quo(rnorm(1,100,15)))
x1 <- v("x1", form = quo(rnorm(1,100,15)))
x2 <- v("x2", form = quo(rnorm(1,100,15)))
 y <- v("y", form = quo(rnorm(1,0,15)))

reg <-   (sumv(x1*e(.5), x2*e(.3))*y) + ((z1*sumv(e(.4)*x1, e(.3)*y))) 

plot(reg)
```

<img src="man/figures/README-unnamed-chunk-21-1.png" width="100%" />

``` r
ralget_sim(reg, 1000)
#> # A tibble: 1,000 x 4
#>       x2    z1    x1     y
#>    <dbl> <dbl> <dbl> <dbl>
#>  1 104.  113.   147.  131.
#>  2 106.  106.   121.  157.
#>  3 106.   88.5  127.  134.
#>  4 113.  127.   160.  183.
#>  5  90.9  97.3  154.  122.
#>  6 101.  102.   162.  161.
#>  7 119.   94.8  155.  126.
#>  8  80.9 122.   144.  141.
#>  9  94.6  92.3  154.  118.
#> 10  92.3  91.2  143.  118.
#> # … with 990 more rows
```
