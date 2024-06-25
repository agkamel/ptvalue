# Constuctor
new_ptvalue <- function(x = double()) {
  stopifnot(is.double(x))
  x <- structure(x, class = "ptvalue")
  x
}


# Validator
# validate_ptvalue <- function(x) {
#   values <- unclass(x)
#   if (any(sign(values) == -1)) {
#     stop(
#       "All `x` value must be positive."
#     )
#   }
# }


# Helper
ptvalue <- function(x) {
  x <- as.double(x)
  #validate_ptvalue(x)
  new_ptvalue(x)
}


# print.ptvalue
print.ptvalue <- function(x, ...) {
  to_be_printed <- ifelse(x >= 1, paste0("×", x), paste0("÷", 1 / x))
  cat(to_be_printed)
}





