
test_that("[<-", {
  #
  Result <- enum(a = 1, x = 2, c = 4)
  expect_error(Result[1] <- 2)
})



test_that("[[<-", {
  #
  Result <- enum(a = 1, x = 2, c = 4)
  expect_error(Result[[1]] <- 2)
})



test_that("names<-" {
  #
  Result <- enum(a = 1, x = 2, c = 4)
  expect_error(names(Result)[1] <- "newname")
})
