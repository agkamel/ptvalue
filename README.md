
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ptvalue

<!-- badges: start -->

<!-- badges: end -->

The goal of **ptvalue** is to provide a S3 class for printing and for
small manipulation of Precision Teaching (PT) values (ex., values of
celeration, bounce) inside a vector or a dataframe. These values, are
usually written on a Standard Celeration Chart (Calkin, 2005;
Pennypacker et al., 2003), can be used for further calculations and to
print a nice table for report or paper. Some basic helper functions
directly related to the manipulation of PT values are also provided.

As this package is could be imported inside other packages (ex.,
**ptchart**), it will stay small and simple. The dependency from other
packages will also be kept minimal.

## Installation

You can install **ptvalue** with the following code

``` r
install.packages("ptvalue")
```

or you can install the development version as follow:

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
$\times$ symbol is added. For all original values that are greater than
$0$ and smaller than $1$, these values are also converted to values
greater than $1$, but a prefixed $\div$ symbol is added:

``` r
ptvalue(c(5, 2, 1.25))
#> <ptvalue[3]>
#> [1] ×5   ×2   ×1.2
ptvalue(c(0.2, 0.5, 0.8))
#> <ptvalue[3]>
#> [1] ÷5   ÷2   ÷1.2
```

Negative values always raises an error.

``` r
ptvalue(-1) # Raises an error
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
#> 1     1       ÷2  
#> 2     2       ×1.4
#> 3     3       ×2
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

Finaly, PT values can be created with `times()` or `div()`. In
particular, the function `div()` is convenient for creating decaying PT
values without having to find the decimal format before. These following
three examples return the same PT values:

``` r
ptvalue(c(0.5, 0.25, 0.125, 0.0625))
#> <ptvalue[4]>
#> [1] ÷2  ÷4  ÷8  ÷16
ptvalue(c(1/2, 1/4, 1/8, 1/16))
#> <ptvalue[4]>
#> [1] ÷2  ÷4  ÷8  ÷16
div(c(2, 4, 8, 16))
#> <ptvalue[4]>
#> [1] ÷2  ÷4  ÷8  ÷16
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
#> [1] ÷4   ÷1.4 ×1
ptvalue(2) / ptvalue(x)
#> <ptvalue[3]>
#> [1] ×4   ×1.4 ×1
```

PT values can be multipled by a numeric values…

``` r
ptvalue(x) * 2
#> <ptvalue[3]>
#> [1] ×1   ×2.8 ×4
```

…or divided:

``` r
# Division is not commutative
ptvalue(x) / 2
#> <ptvalue[3]>
#> [1] ÷4   ÷1.4 ×1
2 / ptvalue(x)
#> <ptvalue[3]>
#> [1] ×4   ×1.4 ×1
```

PT values can be used with comparison operators as well:

``` r
x < ptvalue(1.8)
#> [1]  TRUE  TRUE FALSE
x == ptvalue(1.4)
#> [1] FALSE  TRUE FALSE
```

## Basic helper functions

You can invert signs of PT values with `invert_sign()`:

``` r
x
#> <ptvalue[3]>
#> [1] ÷2   ×1.4 ×2
invert_sign(x)
#> <ptvalue[3]>
#> [1] ×2   ÷1.4 ÷2
```

You can convert values to absolute multiplicative values with
`abs_sign()` (times or div):

``` r
abs_sign(x)
#> <ptvalue[3]>
#> [1] ×2   ×1.4 ×2
abs_sign(x, sign = "div")
#> <ptvalue[3]>
#> [1] ÷2   ÷1.4 ÷2
```

Alternatively, `as_times()` and `as_div()` are wrappers of `abs_sign()`:

``` r
as_times(x)
#> <ptvalue[3]>
#> [1] ×2   ×1.4 ×2
as_div(x)
#> <ptvalue[3]>
#> [1] ÷2   ÷1.4 ÷2
```

## Report PT values

Because PT values can be stored in dataframes, it helps us to generate
beautiful tables for journal articles or for reports.

``` r
pt_df |> 
  knitr::kable(col.names = c("Phase", "Celeration"))
```

| Phase | Celeration |
|------:|-----------:|
|     1 |         ÷2 |
|     2 |       ×1.4 |
|     3 |         ×2 |
