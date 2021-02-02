
# FALSE
x  <- as.list(1:26)
names(x) <- c(LETTERS[1:25], "")

# FALSE
y <- as.list(1:26)
names(y) <- c(LETTERS[1:25])

# TRUE
z <- as.list(1:26)
names(z) <- c(LETTERS[1:26])



f0 <- function(x) is.list(x) & length(x) == sum(names(x) != "", na.rm = TRUE)
f1 <- function(x) is.list(x) & !(is.null(names(x)) | "" %in% names(x)) & !any(is.na(names(x)))
f2 <- function(x) is.list(x) & !("" %in% allNames(x)) & !any(is.na(names(x)))
f3 <- function(x) is.list(x) & isTRUE(all(nchar(names(x)) > 0))

# Expected pattern: FALSE FALSE TRUE FALSE
f0(x); f0(y); f0(z); f0(as.list(1:26))
f1(x); f1(y); f1(z); f1(as.list(1:26))
f2(x); f2(y); f2(z); f2(as.list(1:26))
f3(x); f3(y); f3(z); f3(as.list(1:26)) # ERROR


library(microbenchmark)
microbenchmark(
  sum = f0(x),
  names = f1(x),
  allNames = f2(x),
  nchar = f3(x)
)

microbenchmark(
  sum = f0(x),
  names = f1(x),
  allNames = f2(x),
  nchar = f3(x)
)



