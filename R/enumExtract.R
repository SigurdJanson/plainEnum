

#' @describeIn extract Access several
#' @param x An `enum` object
#' @param ... a specification of indices.
#' @param drop With `drop=TRUE` the result will be integer. By default subsetting
#' returns `enum`.
#' @export
`[.enum` <- function(x, ..., drop = FALSE) {
  y <- NextMethod("[")
  if (anyDuplicated(y)) {
    warning("Enumeration operation created duplicates. Result is coerced to integer.")
    y <- strip(y)
  } else if (!drop) {
    attr(y, "names") <- attr(x, "names")[y]
    class(y) <- oldClass(x)
  } else {
    y <- strip(y)
  }
  return(y)
}



