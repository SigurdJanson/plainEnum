# enum Assignments
# Changing an enum is forbidden


`[<-.enum` <- function(x, ..., value) {
  stop("Enums shall not be changed after initialization")
}


`[[<-.enum` <- function(x, ..., value) {
  stop("Enums shall not be changed after initialization")
}

`names<-.enum` <- function(x, value) {
  stop("Enums shall not be changed after initialization")
}
