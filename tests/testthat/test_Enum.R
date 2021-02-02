# library(testthat)

# .testdir <- getwd()
# setwd("../../R")
# .srcdir <- getwd()
# source("./enums.R")
# setwd(.testdir)

# Type checks --------------
test_that("is", {
  Result <- enum(a = 1, b = 2)

  expect_s3_class(Result, "enum")
  expect_named(Result, letters[1:2])

  # Same for partial enum? NO
  # expect_is(Result[1], "enum")
  # expect_s3_class(Result[2], "enum")
  # expect_named(Result[1], letters[1])
})



test_that("is.enum", {
  Result <- enum(a = 1, b = 2)
  expect_true(is.enum(Result))

  Result <- c(a = 1, b = 2)
  expect_false(is.enum(Result))

  # Not a valid enum because of duplicate values
  Result <- c(a = 1, b = 1)
  class(Result) <- "enum"
  expect_false(is.enum(Result))

  # Duplicate names: not a valid enum because
  Result <- c(a = 1, a = 2)
  class(Result) <- "enum"
  expect_false(is.enum(Result))

  # Missing name: not a valid enum because
  Result <- 1:3
  names(Result) <- letters[1:2] # names(obj) is now c("a", "b", NA)
  class(Result) <- "enum"
  expect_false(is.enum(Result))


})




# Content type coercion --------------
test_that("enum", {
  Result <- enum(a = 1L, b = 2L)
  expect_identical(is(Result, "enum"), TRUE)

  # doubles are coerced to integer
  Result <- enum(a = 1.0, b = 2.0)
  expect_identical(is(Result, "enum"), TRUE)

  # strings will be coerced to integer
  Result <- enum(a = 1, b = 2, c = "3")
  expect_identical(is(Result, "enum"), TRUE)
})



# Argument is Single List/Vec  --------------
test_that("enum() with list/vector as argument", {
  # ATOMIC VECTOR
  # integer
  Result <- enum(c(a = 1L, b = 2L))
  expect_identical(is(Result, "enum"), TRUE)

  # doubles are coerced to integer
  Result <- enum(c(a = 1.0, b = 2.0))
  expect_identical(is(Result, "enum"), TRUE)

  # strings will be coerced to integer
  Result <- enum(c(a = 1, b = 2, c = "3"))
  expect_identical(is(Result, "enum"), TRUE)

  # LIST
  # integer
  Result <- enum(list(a = 1L, b = 2L))
  expect_identical(is(Result, "enum"), TRUE)

  # doubles are coerced to integer
  Result <- enum(list(a = 1.0, b = 2.0))
  expect_identical(is(Result, "enum"), TRUE)

  # strings will be coerced to integer
  Result <- enum(list(a = 1, b = 2, c = "3"))
  expect_identical(is(Result, "enum"), TRUE)
})

# ERRORS --------------
test_that("Wrong Enums", {
  # Wrong names
  expect_error(enum(1:4)) # no names at all
  expect_error(enum(a = 1, b = 2, 3)) # one name is ""

  obj <- 1:3
  names(obj) <- letters[1:2] # names(obj) is now c("a", "b", NA)
  expect_error(enum(obj)) # one name is ""


  # Wrong content
  expect_error(enum(a = 1, b = 2, c = NA))
  expect_error(enum(a = 1, b = 2, c = "drei"))
  expect_error(enum(a = 1, b = NULL, c = 3))
  expect_error(enum(a = NaN, b = 2, c = 3))
  # no duplicates
  expect_error(enum(a = 1, b = 2, c = 2))
  # no duplicate names
  expect_error(enum(a = 1, b = 2, b = 3))
})


#  --------------
test_that("is() - simply check clas attribute", {
  Result <- enum(a = 1L, b = 2L, c = 3L)
  expect_identical(is(Result, "enum"), TRUE)

  # doubles are coerced to integer
  Result <- enum(a = 1.0, b = 2.0)
  expect_identical(is(Result, "enum"), TRUE)

  # strings will be coerced to integer
  Result <- enum(a = 1, b = 2, c = "3")
  expect_identical(is(Result, "enum"), TRUE)
  })



# Helpers --------------
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




test_that("strip", {
  #
  Result <- strip(enum(a = 1, b = 2))
  expect_type(strip(Result), "integer")
  expect_vector(Result, integer())
  expect_null(names(Result))

  # Divergent validity
  Result <- strip(1L:5L)
  expect_type(strip(Result), "integer")
  expect_vector(Result, integer())
  expect_null(names(Result))
})
