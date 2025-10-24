# ptvalue (development version)

* Multiplication and division between a `ptvalue()` and a double/integer value is now allowed. 
  - The output is kept as a `ptvalue()` for now.
  - Multiplication and division of a `ptvalue()` with a negative value are still not allowed and will raises an error.
  - If multiplication and division with a negative value is needed, `ptvalue()` can be converted back to double values with `unclass()` or `as.double()`.
  - Test unit have been added.
# ptvalue 0.1.0

# ptvalue 0.0.0.9000

* Initial CRAN submission.
