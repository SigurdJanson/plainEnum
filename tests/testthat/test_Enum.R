
# Type checks --------------
test_that("`enum` has the right class and names attribute", {
  Result <- enum(a = 1, b = 2)

  expect_s3_class(Result, "enum")
  expect_identical(attr(Result, "names"), letters[1:2])
  expect_named(Result, letters[1:2])
})


# Content type --------------
test_that("enum", {
  #
  Expected <- c(a = 1L, b = 2L)
  class(Expected) <- "enum"
  Result <- enum(a = 1L, b = 2L)
  expect_identical(is(Result, "enum"), TRUE)
  expect_identical(Result, Expected)

  # doubles are coerced to integer
  Expected <- c(a = 1L, b = 2L)
  class(Expected) <- "enum"
  Result <- enum(a = 1.0, b = 2.0)
  expect_identical(is(Result, "enum"), TRUE)
  expect_identical(Result, Expected)

  # strings will be coerced to integer
  Expected <- c(a = 1L, b = 2L, c = 3L)
  class(Expected) <- "enum"
  Result <- enum(a = 1, b = 2, c = "3")
  expect_identical(is(Result, "enum"), TRUE)
  expect_identical(Result, Expected)

  # strings only will be used as names
  Expected <- c(a = 1L, b = 2L, c = 3L)
  class(Expected) <- "enum"
  Result <- enum("a", "b", "c")
  expect_identical(is(Result, "enum"), TRUE)
  expect_identical(Result, Expected)

  Result <- enum(letters[1:3]) # same but different
  expect_identical(is(Result, "enum"), TRUE)
  expect_identical(Result, Expected)
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


  # No arguments
  expect_error(enum())
})


#  --------------
test_that("is() - simply check class attribute", {
  Result <- enum(a = 1L, b = 2L, c = 3L)
  expect_identical(is(Result, "enum"), TRUE)

  # doubles are coerced to integer
  Result <- enum(a = 1.0, b = 2.0)
  expect_identical(is(Result, "enum"), TRUE)

  # strings will be coerced to integer
  Result <- enum(a = 1, b = 2, c = "3")
  expect_identical(is(Result, "enum"), TRUE)
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



# Helpers --------------
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




# PRINT -----------------
test_that("print", {
  Result <- enum(a = 1, b = 2, c = 3)

  expect_output(print(Result), NULL)
  expect_output(print(Result), "^Enum.*a.*3[[:space:]]+$")
})
