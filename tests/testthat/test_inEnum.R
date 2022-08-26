
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


