# in enum


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

