# in enum



#' @name extract
#' @title Extract Enum Value
#' @description Access an enumeration by value
#' @param x object from which to extract element(s)
#' @param ... An integer value or string that identifies an enum value
#' @param exact Controls possible partial matching of `[[` when extracting
#' by a character vector. The default is no partial matching. Value `FALSE` allows
#' partial matching without any warning.
#' @return The enum value as integer
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
#' e[[3]] # does not exist
#' #> named integer(0)
`[[.enum` <- function(x, ..., exact = TRUE) {
  na <- nargs() - !missing(exact)
  if (na > 2L) stop("Enums are uni-dimensional and accept only one index")
  if (!all(names(sys.call()) %in% c("", "exact")))
    warning("named arguments other than 'exact' are discouraged")

  vmatch <- match(..1, x, nomatch = 0L) # value matching
  if (exact) # name matching
    nmatch <- match(..1, names(x), nomatch = 0L)
  else
    nmatch <- pmatch(..1, names(x), nomatch = 0L)

  return(x[sum(vmatch, nmatch)])
}



#' @title inEnum
#' @description Is `Needle` element of an enum `Haystack?
#' @param Needle an integer or string representing an element of the
#' enumeration `Haystack`
#' @param Haystack an enumeration class `enum`
#' @return TRUE/FALSE
#' @export
#' @examples
#' myEnum <- enum(a=1, b=3, c=5)
#' inEnum(3, myEnum)   # TRUE
#' inEnum("b", myEnum) # TRUE
#' inEnum(2, myEnum)   # FALSE, however ...
#' inEnum(myEnum[2], myEnum)   # TRUE
#' inEnum(myEnum["c"], myEnum) # TRUE
inEnum <- function(Needle, Haystack) {
  if (!is.enum(Haystack)) stop("'Haystack' is not an enum")
  return(match(Needle, Haystack, nomatch = 0L) > 0L |
           match(Needle, names(Haystack), nomatch = 0L) > 0L)
}

