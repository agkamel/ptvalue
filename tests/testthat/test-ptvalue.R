
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







# Tests for is_ptvalue() --------------------------------------------------
test_that("is_ptvalue works properly", {
  expect_equal(is_ptvalue(ptvalue(2)), TRUE)
  expect_equal(is_ptvalue(2), FALSE)

})


test_that("conversion works properly", {
  expect_equal(as_ptvalue(1) |> as.character(), "×1")
})


test_that("invert_sign works properly", {
  expect_equal(invert_sign(c(0.5, 2)) |> as.character(),
               c("×2", "÷2"))
})


