
#' @title enum
#' @description Create enumeration pseudo type as S3 `enum` class from a list of named arguments
#' @param ... One or more named arguments all of the same type. Alternatively it can be one
#' single list or atomic vector.
#' @details `enum()` will try to coerce values to integer and throw an error if that fails.
#' The consequence of this that it will also fail when a list/vector is not the first argument.
#' If a list/vector is indeed the first argument all remaining arguments will be ignored.
#' @return A named atomic vector of class `enum`
#' @export
#' @examples
#' myEnum <- enum(a=1, b=3, c=5)
#' inEnum(3, myEnum)   # TRUE
#' inEnum("b", myEnum) # TRUE
#' inEnum(2, myEnum)   # FALSE, however ...
#' inEnum(myEnum[2], myEnum)   # TRUE
#' inEnum(myEnum["c"], myEnum) # TRUE
enum <- function(...) {
  Args <- list(...)
  if (length(Args) == 0) stop("No arguments")

  # Unlist vectors and lists
  if (length(Args) == 1 && (is.list(Args) || is.atomic(Args)))
    Args <- unlist(Args)

  # Coerce to integer
  suppressWarnings(
    Result <- as.integer(unlist(Args))
  )
  if (any(is.na(Result))) stop("Cannot create valid enum")

  #
  NameCount <- sum(names(Args) != "", na.rm = TRUE)
  if (!isTRUE(NameCount == length(Result)))
    stop("Each element of an enum requires a name")
  names(Result) <- names(Args)

  if (length(unique(Result)) < length(Result))
    stop("Values in an enum must be unique")
  if (length(unique(names(Result))) < length(Result))
    stop("Names in an enum must be unique")

  class(Result) <- "enum"
  return(Result)
}


#' @title strip
#' @description Strip an object from all it's attributes.
#' @param obj any object
#' @return `strip()` removes all names, class, comments and any other attributes and returns
#' the result.
#' @export
#' @examples
#' strip(enum(a = 1, b = 2)) # 1:2
#' strip(c(a = 1, b = 2))    # 1:2
strip <- function(obj) {
  UseMethod("strip", obj)
}

#' @describeIn strip Strip any object from all it's attributes.
strip.default <- function(obj) {
  if (!is.null(attributes(obj)))
    attributes(obj) <- NULL
  return(obj)
}



#' @title print.enum
#' @description Prints its argument and returns it invisibly (via `[invisible](x)`).
#' @param x an `enum` object to print
#' @param ...	further arguments passed to or from other methods.
#' @return `[invisible](x)`
#' @examples
#' print(enum(a = 1, b = 2))
print.enum <- function(x, ...) {
  cat("Enum \n")
  print(unclass(x), ...)
  return(invisible(x))
}

# print(Enum(a=1, bcd=3, efghij= 5))



#' @title is.enum
#' @description Test if object is inherited from class `enum`. Moreover, the function checks if
#' the object can be coerced to `enum` and verifies if it is indeed a valid `enum`.
#' @param x any `R` object
#'
#' @return `TRUE` if object is a valid enum, otherwise `FALSE`.
#' @export
#' @examples
#' is.enum(enum(a = 1, b = 2)) # TRUE
#' is.enum(c(a = 1, b = 2))    # FALSE
is.enum <-function(x) {
  is.it <- FALSE
  # If it has the right class attribute, try to coerce to "enum" to verify
  if (inherits(x, "enum"))
    is.it <- !isFALSE(tryCatch(enum(x), error = function(e) FALSE))

  return(is.it)
}




#' @title inEnum
#' @description Is `Needle` element of an enum `Haystack?
#' @param Needle an integer or string representing an element of the
#' enumeration `Haystack`
#' @param Haystack an enumeration class `enum`
#' @return TRUE/FALSE
#' @export
#'
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
