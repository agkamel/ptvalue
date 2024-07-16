
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ptvalue

<!-- badges: start -->
<!-- badges: end -->

The goal of ptvalue is to provide a simple class for manipulating and
printing measures related to precision teaching (celeration, bounce,
etc.).

## Installation

You can install the development version of ptvalue like so:

``` r
remotes::install_github("agkamel/ptvalue")
```

## Create a ptvalue

We can create precision teaching values with `ptvalue()`:

``` r
library(ptvalue)
ptvalue(c(0.5, 1.4, 2))
#> <ptvalue[3]>
#> [1] ÷2   ×1.4 ×2
```

For all original values that are greater or equal than $1$, a prefixed
$\times$ symbol is added. For all original values that are greater than
$0$ and smaller than $1$, these value are converted to a value greater
than $1$ and a prefixed $\div$ symbol is added:

``` r
ptvalue(c(5, 2, 1.25))
#> <ptvalue[3]>
#> [1] ×5    ×2    ×1.25
ptvalue(c(0.2, 0.5, 0.8))
#> <ptvalue[3]>
#> [1] ÷5    ÷2    ÷1.25
```

While ptvalue are printed, the original values are always conserved:

``` r
x <- ptvalue(c(0.5, 1.4, 2))
x
#> <ptvalue[3]>
#> [1] ÷2   ×1.4 ×2
unclass(x)
#> [1] 0.5 1.4 2.0
```

## Multiplications and divisions

Because original values are always conserved under the hood, this allows
us to multiply and divide ptvalues:

``` r
ptvalue(1.4) * ptvalue(2)
#> Warning: Operations between vectors of class ptvalue are in active development and are
#> not reliable yet.
#> This warning is displayed once per session.
#> <ptvalue[1]>
#> [1] ×2.8
ptvalue(2) * ptvalue(1.4)
#> <ptvalue[1]>
#> [1] ×2.8

ptvalue(0.5) / ptvalue(2)
#> <ptvalue[1]>
#> [1] ÷4
ptvalue(2) / ptvalue(0.5)
#> <ptvalue[1]>
#> [1] ×4
```
