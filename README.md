
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ptvalue

<!-- badges: start -->
<!-- badges: end -->

The goal of **ptvalue** is to provide a S3 class for printing and for
small manipulation of Precision Teaching (PT) values (for instance,
values of celeration, bounce) inside a vector or a dataframe. These
values, are usually written on a Standard Celeration Chart (Calkin,
2005), can be used for further calculation and to print a nice table for
report or paper.

## Installation

You can install the development version of **ptvalue** like so:

``` r
remotes::install_github("agkamel/ptvalue")
```

## Create a vector of PT values

You can create PT values with `ptvalue()`:

``` r
library(ptvalue)
ptvalue(c(0.5, 1.4, 2))
#> <ptvalue[3]>
#> [1] ÷2   ×1.4 ×2
```

For all original values that are greater or equal than $1$, a prefixed
$\times$ symbol is added. For all original values that are greater or
equal than $0$ and smaller than $1$, these value are converted to a
value greater than $1$ and a prefixed $\div$ symbol is added:

``` r
ptvalue(c(5, 2, 1.25))
#> <ptvalue[3]>
#> [1] ×5    ×2    ×1.25
ptvalue(c(0.2, 0.5, 0.8))
#> <ptvalue[3]>
#> [1] ÷5    ÷2    ÷1.25
```

Negative values always raises an error.

``` r
ptvalue(-1) # Raise an error
```

PT values created with `ptvalue()` can be stored in objects:

``` r
x <- ptvalue(c(0.5, 1.4, 2))
x
#> <ptvalue[3]>
#> [1] ÷2   ×1.4 ×2
```

…and be inserted in dataframe as well:

``` r
pt_df <- tibble::tibble(
  phase = 1:3,
  celeration = x)
pt_df
#> # A tibble: 3 × 2
#>   phase celeration
#>   <int>    <ptval>
#> 1     1         ÷2
#> 2     2       ×1.4
#> 3     3         ×2
```

The type of a `ptvalue` vector is `double`. The original values are
always conserved under the hood, it is only the printing that is
different. These can always be converted back:

``` r
unclass(x)
#> [1] 0.5 1.4 2.0
as.double(x)
#> [1] 0.5 1.4 2.0
```

## Arithmetics and comparisons

Because original values are always conserved, this allows us to multiply
PT values:

``` r
# Multiplication is commutative
ptvalue(x) * ptvalue(2)
#> Warning: Operations between vectors of class ptvalue are in active development and are
#> not reliable yet. Use with care.
#> This warning is displayed once per session.
#> <ptvalue[3]>
#> [1] ×1   ×2.8 ×4
ptvalue(2) * ptvalue(x)
#> <ptvalue[3]>
#> [1] ×1   ×2.8 ×4
```

… and divide PT values:

``` r
# Division is not commutative
ptvalue(x) / ptvalue(2)
#> <ptvalue[3]>
#> [1] ÷4    ÷1.43 ×1
ptvalue(2) / ptvalue(x)
#> <ptvalue[3]>
#> [1] ×4    ×1.43 ×1
```

PT values can be used with comparison operators as well:

``` r
x < ptvalue(1.8)
#> [1]  TRUE  TRUE FALSE
x == ptvalue(1.4)
#> [1] FALSE  TRUE FALSE
```

## Invert sign

You can invert signs of PT values with `invert_sign()`:

``` r
x
#> <ptvalue[3]>
#> [1] ÷2   ×1.4 ×2
invert_sign(x)
#> <ptvalue[3]>
#> [1] ×2   ÷1.4 ÷2
```

## Report

Because PT values can be stored in dataframes, it helps us to generate
beautiful tables for

``` r
pt_df |> 
  knitr::kable(col.names = c("Phase", "Celeration"))
```

| Phase | Celeration |
|------:|-----------:|
|     1 |         ÷2 |
|     2 |       ×1.4 |
|     3 |         ×2 |
