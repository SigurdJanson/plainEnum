

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



