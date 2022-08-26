
#' @name extract-enum
#' @title Extract Enum Value
#' @description Access an enumeration by name or value.
#' @param x enum object from which to extract element(s)
#' @param ... An integer value or string that identifies an enum value
#' @param exact Controls possible partial matching of `[[` when extracting
#' by a character vector. The default is no partial matching. Value `FALSE` allows
#' partial matching without any warning.
#' @return `x[[...]]` returns the value as `enum`.
#' @note Unlike the equivalent function in base R this function does not throw a
#' warning when `exact` is `NA`.
#'
#' This function is not vectorized!
#' @export
#' @examples
#' e <- enum(a = 1, x = 2, c = 4)
#' e[[2]]
#' #> x
#' #> 2
#' e[["x"]]
#' #> x
#' #> 2
#' tryCatch(e[[3]], error = function(e) e ) # does not exist
#' #> Attempt to access non-existing enum value
`[[.enum` <- function(x, ..., exact = TRUE) {
  na <- nargs() - !missing(exact)
  if (na > 2L) stop("Enums are uni-dimensional and accept only one index")
  if (!all(names(sys.call()) %in% c("", "exact")))
    warning("Named arguments other than 'exact' are discouraged")

  vmatch <- match(..1, x, nomatch = 0L) # value matching
  if (exact) # name matching
    nmatch <- match(..1, names(x), nomatch = 0L)
  else
    nmatch <- pmatch(..1, names(x), nomatch = 0L)

  index <- sum(vmatch, nmatch)
  if (index <= 0 || index > length(x)) stop("Attempt to access non-existing enum value")
  return(x[index])
}


#' @describeIn extract-enum Extract elements of an enum
#' @param x An `enum` object
#' @param ... a specification of indices.
#' @param drop With `drop=TRUE` the result will be integer. By default subsetting
#' returns an `enum`.
#' @return For `x[...]` the default return type is `enum`. Duplicate values or `drop=TRUE` will
#' drop the return type to `integer`.
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



