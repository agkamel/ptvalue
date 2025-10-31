# ptvalue (development version)

# ptvalue 0.2.0

* Multiplication and division between a `ptvalue()` and a double/integer value is now allowed. 
  - The output is kept as a `ptvalue()` for now.
  - Multiplication and division of a `ptvalue()` with a negative value are still not allowed and will raises an error.
  - If multiplication and division with a negative value is needed, `ptvalue()` can be converted back to double values with `unclass()` or `as.double()`.
  - Test unit have been added.

* Other helper functions have been added in addition to `invert_sign()`:
  - `abs_sign()` converts values to values with an 'absolute' sign (times or div)
  - `as_times()` converts values to times only
  - `as_div()` converts values to div only
  - Documentation for these four functions have been added and grouped into a single page.
  - Test units have been added.

* More details were added in README:
  - About `div()` and `times()`, for creating directly PT values.
  - About `abs_sign()`, `as_times()`, and `as_div()`

# ptvalue 0.1.0

# ptvalue 0.0.0.9000

* Initial CRAN submission.
