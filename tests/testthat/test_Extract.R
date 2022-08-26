
# ENUM[*] ===================================================

test_that("`enum[*]` is still an enum with names?", {
  # Single element
  e <- enum(a = 1L, b = 2L, c = 3L)
  Result <- e[sample.int(length(e), 1L)]
  expect_true(is.enum(Result))

  # 2 elements
  e <- enum(a = 1L, b = 2L, c = 3L)
  Result <- e[sample.int(length(e), 2L)]
  expect_true(is.enum(Result))

  # All elements
  e <- enum(a = 1L, b = 2L, c = 3L)
  Result <- e[sample.int(length(e), length(e))]
  expect_true(is.enum(Result))
})



test_that("`enum[integer(*), drop=TRUE]` is a plain integer", {
  # Single element
  e <- enum(a = 1L, b = 2L, c = 3L)
  Result <- e[sample.int(length(e), 1L), drop=TRUE]
  expect_false(is.enum(Result))
  expect_type(Result, "integer")
  expect_named(Result, NULL)

  # 2 elements
  e <- enum(a = 1L, b = 2L, c = 3L)
  Result <- e[sample.int(length(e), 2L), drop=TRUE]
  expect_false(is.enum(Result))
  expect_type(Result, "integer")
  expect_named(Result, NULL)

  # All elements
  e <- enum(a = 1L, b = 2L, c = 3L)
  Result <- e[sample.int(length(e), length(e)), drop=TRUE]
  expect_false(is.enum(Result))
  expect_type(Result, "integer")
  expect_named(Result, NULL)
})




test_that("`enum[...]` causing duplicates drops `enum` class and throws warning", {
  # All elements + 1 cannot be an enum because it has duplicates
  e <- enum(a = 1L, b = 2L, c = 3L)
  indices <- sample.int(length(e), length(e) * 3, replace = TRUE)

  expect_warning(
    Result <- e[indices]
  )

  # Assert
  expect_false(is.enum(Result))
  expect_type(Result, "integer")
  expect_s3_class(Result, NA)
  expect_named(Result, NULL)
})



# ENUM[[*]] =================================================

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



test_that("`enum[[integer, exact = FALSE]]` works", {
  #
  e <- enum(Freebo = 1L, AlexTimmons = 2L, NurseMary = 3L, CindyLandon = 4L)

  expect_identical(e[[1, exact=FALSE]], structure(c(Freebo = 1L), class="enum"))
  expect_identical(e[[2L, exact=FALSE]], structure(c(AlexTimmons = 2L), class="enum"))
  expect_identical(e[[4L, exact=FALSE]], structure(c(CindyLandon = 4L), class="enum"))
})



test_that("`enum[[*, exact = FALSE]]` works for unique hits", {
  #
  e <- enum(Freebo = 1L, AlexTimmons = 2L, NurseMary = 3L, CindyLandon = 4L)

  expect_identical(e[["F", exact=FALSE]], structure(c(Freebo = 1L), class="enum"))
  expect_identical(e[["Al", exact=FALSE]], structure(c(AlexTimmons = 2L), class="enum"))
  expect_identical(e[["CindyLan", exact=FALSE]], structure(c(CindyLandon = 4L), class="enum"))
})



test_that("`enum[[*, exact = FALSE]]` error for ambiguous hits", {
  #
  e <- enum(Freebo = 1L, AlexTimmons = 2L, NurseMary = 3L, AlanElson = 4L)

  expect_error(e[["Al", exact=FALSE]], NULL)
})



test_that("multiple indices with `enum[[*]]` throw a error", {
  #
  e <- enum(Freebo = 1L, AlexTimmons = 2L, NurseMary = 3L, CindyLandon = 4L)

  expect_error(e[["F", "N"]], "Enums.*only one index")
})


test_that("`enum[[*]]` throws warning if named arguments are not 'exact'", {
  #
  e <- enum(Freebo = 1L, AlexTimmons = 2L, NurseMary = 3L, CindyLandon = 4L)

  expect_warning(e[[other="NurseMary"]], ".*Named argument.*")
  expect_warning(e[[other="NurseMary", exact=TRUE]], ".*Named argument.*")
  expect_warning(e[[other="NurseMary", exact=FALSE]], ".*Named argument.*")
})

# "$ operator is invalid for atomic vectors"
# test_that("`enum$...` is an enum", {
#   e <- enum(abc = 1L, bcd = 2L, cde = 3L)
#   Result <- e$bcd
#   expect_true(is.enum(Result))
# })
