
# Tests for ptvalue() -----------------------------------------------------
test_that("correct ptvalue are returned", {
  expect_equal(as.character(ptvalue(2)), "×2")
  expect_equal(as.character(ptvalue(0.5)), "÷2")
  expect_equal(as.character(ptvalue(1)), "×1")
})



test_that("addition and subtraction return an error", {
  expect_error(ptvalue(2) + ptvalue(0.5))
  expect_error(ptvalue(2) + ptvalue(0.5))
})



test_that("multiplication works properly", {

  # Simple test
  expect_equal(as.character(ptvalue(2) * ptvalue(3)), "×6")

  # Identity property: a x 1 = a
  expect_equal(as.character(ptvalue(2) * ptvalue(1)), "×2")
  expect_equal(as.character(ptvalue(0.5) * ptvalue(1)), "÷2")

  # Propriete mirroir: a x 1/a = 1
  expect_equal(as.character(ptvalue(0.5) * ptvalue(2)), "×1")

  # Commutative property: a x b = b x a
  expect_equal(ptvalue(0.5) * ptvalue(3),
               ptvalue(3) * ptvalue(0.5))

  # Associate property: a x (b x c) = (a x b) x c
  expect_equal(ptvalue(2) * (ptvalue(3) * ptvalue(4)),
               (ptvalue(2) * ptvalue(3)) * ptvalue(4))

  # Null property: a * 0 = -Inf
  expect_equal(as.character(ptvalue(2) * ptvalue(0)), "÷Inf")

})



test_that("division works properly", {

  # Simple test
  expect_equal(as.character(ptvalue(2) / ptvalue(3)), "÷1.5")

  # Identity property: a / 1 = a
  expect_equal(as.character(ptvalue(2) / ptvalue(1)), "×2")
  expect_equal(as.character(ptvalue(0.5) / ptvalue(1)), "÷2")

  # Propriete mirroir: 1/a / 1/a = 1
  expect_equal(as.character(ptvalue(0.5) / ptvalue(0.5)), "×1")

  # No commutative property: a / b != b / a
  # No associate property: a / (b / c) != (a / b) / c

  # Null property: a / 0 = Inf
  expect_equal(as.character(ptvalue(2) / ptvalue(0)), "×Inf")

})



test_that("NAs are handled properly", {

  expect_equal(vctrs::vec_data(ptvalue(NA)), NA_real_)

  expect_equal(vctrs::vec_data(ptvalue(c(2, NA))), c(2, NA))

})



test_that("multiplication between double and ptvalue works properly", {
  expect_equal(ptvalue(2) * 2, ptvalue(4))
  expect_equal(2 * ptvalue(2), ptvalue(4))
})



test_that("division between double and ptvalue works properly", {
  expect_equal(ptvalue(2) / 2, ptvalue(1))
  expect_equal(2 / ptvalue(2), ptvalue(1))
})



# Tests for is_ptvalue() --------------------------------------------------
test_that("is_ptvalue() works properly", {
  expect_equal(is_ptvalue(ptvalue(2)), TRUE)
  expect_equal(is_ptvalue(2), FALSE)

})


# Tests for as_ptvalue() --------------------------------------------------
test_that("conversion works properly", {
  expect_equal(as_ptvalue(1) |> as.character(), "×1")
})



# Tests for invert_sign() -------------------------------------------------
test_that("invert_sign() works properly", {

  # With double values
  expect_equal(invert_sign(c(0.5, 2)) |> as.character(),
               c("×2", "÷2"))
})




# Tests for abs_sign() ----------------------------------------------------
test_that("abs_sign() works properly", {

  expect_equal(abs_sign(c(0.5, 2)) |> as.character(),
               c("×2", "×2"))

  expect_equal(abs_sign(c(0.5, 2), sign = "times") |> as.character(),
               c("×2", "×2"))

  expect_equal(abs_sign(c(0.5, 2), sign = "div") |> as.character(),
               c("÷2", "÷2"))

  expect_error(abs_sign(c(0.5, 2), sign = "time"))

})



# Tests for times() -------------------------------------------------------
test_that("times() properly", {

  expect_equal(times(c(1, 2)) |> as.character(),
               c("×1", "×2"))

})


test_that("values provided to times() must be greater or equal than 1", {

  expect_error(times(c(0)))
  expect_error(times(c(-1)))

})


test_that("class of values provided to times() must not be `ptvalue`", {

  expect_error(times(c(ptvalue(2))))

})



# Tests for div() ---------------------------------------------------------
test_that("div() properly", {

  expect_equal(div(c(1, 2)) |> as.character(),
               c("×1", "÷2"))

})


test_that("values provided to div() must be greater or equal than 1", {

  expect_error(div(c(0)))
  expect_error(div(c(-1)))

})


test_that("class of values provided to div() must not be `ptvalue`", {

  expect_error(div(c(ptvalue(2))))

})



# Tests for as_times() and as_div() ---------------------------------------
test_that("as_times() and as_div() work properly", {

  expect_equal(as_times(c(0.5, 1, 2)) |> as.character(),
               c("×2", "×1", "×2"))

  expect_equal(as_div(c(0.5, 1, 2)) |> as.character(),
               c("÷2", "×1", "÷2"))

  })




# Tests for operation inside a data.frame ---------------------------------
df <- data.frame(x = ptvalue(c(0.5, 2)), y = c(2, 2))
test_that("operation inside data.frame works properly", {
  expect_equal({df["z"] <- df["x"] * df["y"]; df["z"]},
               data.frame(z = c(ptvalue(1), ptvalue(4))))
})

