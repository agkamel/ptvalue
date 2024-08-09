# Constructor function ----------------------------------------------------

new_ptvalue <- function(x = double()) {

  if (!rlang::is_double(x)) {
    rlang::abort("`x` must be a double vector.")
  }

  if (any(x < 0)) {
    rlang::abort("`x` must be greater or equal than 0.")
  }

  vctrs::new_vctr(x, class = "ptvalue")
}


# Helper function ---------------------------------------------------------

#' ptvalue: Working with precision teaching values
#'
#' This class allow to print precision teaching mesures with the
#' times or the division symbols like \eqn{\times 2} or \eqn{\div 1.4} by
#' converting numeric values to precision teaching values. More specifically,
#' input values between \eqn{ ] 0, 1 [ } will return output values greater or
#' equal than \eqn{1} prefixed with \eqn{\div}; input values between \eqn{[ 1,
#' \infty [} will return output values greater or equal than \eqn{1} prefixed
#' with \eqn{\times}.
#'
#' A few arithmetic operations will be allowed in the futur. It is currently
#' under development.
#'
#' @param x A numeric vector. Values must be greater than 0.
#' @param ... Other values passed to method.
#'
#' @return A numeric vector of class **ptvalue** that represent precision teaching mesures.
#' @export
#'
#' @rdname ptvalue
#' @examples
#' x <- c(0.5, 0.8, 1, 1.25, 2)
#' ptvalue(x)
ptvalue <- function(x = double()) {
  x <- vctrs::vec_cast(x, double())
  new_ptvalue(x)
}


# Convenience function
#' @export
#' @rdname ptvalue
is_ptvalue <- function(x) {
  inherits(x, "ptvalue")
}



# Format methods ----------------------------------------------------------

# format() method
#' @export
format.ptvalue <- function(x, ...) {

  times <- vctrs::vec_data(x) >= 1
  divs <- vctrs::vec_data(x) < 1
  nas <- is.na(vctrs::vec_data(x))

  out <- vctrs::vec_data(x)
  out[divs] <- 1 / out[divs]
  out[nas] <- NA

  out <- format(formatC(out, format = "g"))

  out[times] <- paste0("\u00d7", out[times])
  out[divs] <- paste0("\u00f7", out[divs])

  out
}



# Abbreviations
#' @export
vec_ptype_abbr.ptvalue <- function(x, ...) {
  "ptval"
}




# Coercion and casting ----------------------------------------------------

## Coercion  -------------------------------------------

# Coercion
#' @export
vec_ptype2.ptvalue.ptvalue <- function(x, y, ...) new_ptvalue()
#' @export
vec_ptype2.ptvalue.double <- function(x, y, ...) double()
#' @export
vec_ptype2.double.ptvalue <- function(x, y, ...) double()

#' @export
vec_ptype2.ptvalue.character <- function(x, y, ...) character()
#' @export
vec_ptype2.character.ptvalue <- function(x, y, ...) character()

# For testing purposes only
#vctrs::vec_ptype_show(ptvalue(), double(), ptvalue()) # Keep commented

## Casting  -------------------------------------------

#' @export
vec_cast.ptvalue.ptvalue <- function(x, to, ...) x
#' @export
vec_cast.ptvalue.double <- function(x, to, ...) ptvalue(x)
#' @export
vec_cast.double.ptvalue <- function(x, to, ...) vctrs::vec_data(x)

#' @export
vec_cast.character.ptvalue <- function(x, to, ...) {
  times <- vctrs::vec_data(x) >= 1
  divs <- vctrs::vec_data(x) < 1
  nas <- is.na(vctrs::vec_data(x))

  out <- vctrs::vec_data(x)
  out[divs] <- 1 / out[divs]
  out[nas] <- NA

  out <- format(formatC(out, format = "g"))

  out[times] <- paste0("\u00d7", out[times])
  out[divs] <- paste0("\u00f7", out[divs])

  out
  }


# For testing purposes only
#vctrs::vec_cast(0.5, ptvalue())  # Keep commented
#vctrs::vec_cast(ptvalue(0.5), double())  # Keep commented
#vctrs::vec_cast("allo", ptvalue()) # Keep commented # Devrait soulever une erreur
#vctrs::vec_cast(ptvalue(2), character()) # Keep commented

# Casting helper

#' @export
#' @rdname ptvalue
#' @examples
#' x <- c(0.5, 1, 2)
#' as_ptvalue(x)
as_ptvalue <- function(x, ...) {
  UseMethod("as_ptvalue")
}

#' @export
#' @rdname ptvalue
as_ptvalue.default <- function(x, ...) {
  vctrs::vec_cast(x, new_ptvalue())
}

# Arithmetics -------------------------------------------------------------

#' @import vctrs
#' @export
#' @method vec_arith ptvalue
vec_arith.ptvalue <- function(op, x, y, ...) {
  UseMethod("vec_arith.ptvalue", y)
}

#' @export
#' @method vec_arith.ptvalue default
vec_arith.ptvalue.default <- function(op, x, y, ...) {
  vctrs::stop_incompatible_op(op, x, y)
}

#' @export
#' @method vec_arith.ptvalue ptvalue
vec_arith.ptvalue.ptvalue <- function(op, x, y, ...) {

  cli::cli_warn("Operations between vectors of class
                ptvalue are in active development and are not reliable yet. Use with care.",
                .frequency = "once",
                .frequency_id = "operation")

  switch(
    op,
    "*" = new_ptvalue(vctrs::vec_arith_base(op, x, y)),
    "/" = new_ptvalue(vctrs::vec_arith_base(op, x, y)),
    vctrs::stop_incompatible_op(op, x, y)
  )
}


# Other useful functions --------------------------------------------------

#' Invert ptvalue sign
#'
#' @param x A vector of class `ptvalue`
#'
#' @return A vector of class `ptvalue` with inverted sign
#' @export
#'
#' @examples
#' x <- c(0.5, 1.4, 2)
#' invert_sign(x)
invert_sign <- function(x = double()) {
  new_ptvalue(1 / vctrs::vec_cast(x, double()))
}

#' Find 'absolute' ptvalue
#'
#' @param x A vector of class `ptvalue`
#' @param sign Either 'times' or 'div'. Default to 'times'.
#'
#' @return A vector of class `ptvalue` with absolute ptvalue
#' @export
#'
#' @examples
#' x <- c(0.5, 1.4, 2)
#' abs_sign(x)
abs_sign <- function(x = double(), sign = "times") {

  stopifnot("Arg `sign` must be either 'times' or 'div'." = sign %in% c("times", "div"))

  if (sign == "times") {
    ifelse(vctrs::vec_cast(x, double()) >= 1,
           new_ptvalue(vctrs::vec_cast(x, double())),
           invert_sign(x))

  } else if (sign == "div") {
    ifelse(vctrs::vec_cast(x, double()) >= 1,
           invert_sign(x),
           new_ptvalue(vctrs::vec_cast(x, double())))
  }
}
