# enum Assignments
# Changing an enum is forbidden


#' @describeIn extract Forbids enum value assignments
#' @param value an `R` object
#' @export
`[<-.enum` <- function(x, ..., value) {
  stop("Enums shall not be changed after initialization")
}


#' @describeIn extract Forbids enum value assignments
#' @export
`[[<-.enum` <- function(x, ..., value) {
  stop("Enums shall not be changed after initialization")
}


#' @describeIn extract Forbids enum value assignments
#' @export
`names<-.enum` <- function(x, value) {
  stop("Enums shall not be changed after initialization")
}
