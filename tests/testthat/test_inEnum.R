

test_that("`enum[[*]]` is still an enum with names?", {
  #
  e <- enum(F = 1L, y = 2L, B = 3L)

  expect_identical(e[[1]], structure(c(F=1L), class="enum"))
  expect_identical(e[[2]], structure(c(y=2L), class="enum"))
  expect_identical(e[[3L]], structure(c(B=3L), class="enum"))

  expect_identical(e[["F"]], structure(c(F=1L), class="enum"))
  expect_identical(e[["y"]], structure(c(y=2L), class="enum"))
  expect_identical(e[["B"]], structure(c(B=3L), class="enum"))
})



test_that("`[[` in an out of bounds situation throws an error", {
  #
  Result <- enum(a = 1, x = 2, c = 4)

  expect_error(Result[[0]])
  expect_error(Result[[3]])
  expect_error(Result[[5]])
  expect_error(Result[["b"]])
})


test_that("inEnum()", {
  #
  Result <- enum(a = 1, x = 2, c = 4)

  for (i in Result) {
    expect_true(inEnum(i, Result))
  }
  for (i in names(Result)) {
    expect_true(inEnum(i, Result))
  }

  # Special case
  expect_true(inEnum("1", Result)) # match coerces everything to char before comparison
  expect_true(inEnum(TRUE, Result)) # match coerces everything to char before comparison

  # element is NOT in enum
  expect_false(inEnum(3, Result))
  expect_false(inEnum("b", Result))

  #
  expect_error(inEnum(3, 1:3))
})



