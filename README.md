# plainEnum

<!-- badges: start -->
  [![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

The plainEnum package adds a simple crutch to emulate enumerations in R. 

An enumeration type (or enum type) is a value type defined by a set of named constants of the underlying integral numeric type. To define an enumeration type, use the enum keyword and specify the names of enum members.

They make it easier to write readable code: `Days["Monday"]` provides more information than `Days[1]` and is, thus, easier to understand.


Usage is simple. Define an enumeration with `enum()`:

```r-lang
enum(Monday = 1, Tuesday = 2, Wednesday = 3, Thursday = 4, Friday = 5, Saturday = 6, Sunday = 7)
#> Enum 
#> Monday   Tuesday Wednesday  Thursday    Friday  Saturday    Sunday 
#>      1         2         3         4         5         6         7 
```

Provide readable code with these enumerations:
```r-lang
Days <- enum(Monday = 1, Tuesday = 2, Wednesday = 3, Thursday = 4, Friday = 5, Saturday = 6, Sunday = 7)
Days["Monday"]
#> Monday 
#>      1
```

An even easier way to set up an enumeration is the use of a character vector. The integer values are created automatically.
```r-lang
enum("Montag", "Dienstag", "Mittwoch", "Donnerstag", "Samstag", "Sonntag")
```


Setting the value of an enumeration value I recommend using a character index for maximum readability: `val <- myEnum[["label"]]`. It is possible to use this value `val` directly. That is the **faster** way. However, the **safer** way using enums is `myEnum[[val]]` instead of just `val`. Unless performance is an issue in an app, `myEnum[[val]]` is preferable. Not only enhances it the readability of the code because it shows the type of the variable, it is also safer because it also works correctly when `val` loses it's attributes (see "Caveats").


The best way to use an enumeration value are the `[` or `[[` operator. It is not possible to access value `c` of an enum `enum(a = 1, c = 3)` by position. The statement `enum(a = 1, c = 3)[2]` would give you an error, because a value `2` does not exist. 

Examples:

```r-lang
Vision <- enum(Clear = 1, Blurred = 99, ColorDeficient = 666)
Vision[666]
#> ColorDeficient
#> 666
Vision[[3]] 
#> integer(0)
Vision[[666]]
#> ColorDeficient
#> 666
```

The differences between `[...]` and  `[[...]]` are:

* `[[...]]` supports partial matching with character access. The argument `exact = FALSE` allows it. By default, partial matching is off.
* `[...]` supports a vectors of indices while `[[` only allows a single one.
* `[...]` may drop the `enum` class. Either by users' choice (using the argument `drop=FALSE`) or when the subset contains duplicates.


Test if a value is part of an enumeration with `inEnum()`:

```r-lang
inEnum(7)
#> TRUE

inEnum("Thursday")
#> TRUE

inEnum("Thanksgiving")
#> FALSE
```


If you want to use the enumeration in [shiny widgets](https://shiny.rstudio.com/), you need to strip them of all attributes, first:
```r-lang
shiny::updateSelectInput(inputId = "cbWeekday", choices = strip(Days))
```


## Caveats

You have to avoid functions that remove attributes from its' arguments. The result in the following expression loses its attributes and is not an enumeration, anymore. Typical attribute removing functions are: `ifelse`, `min`/`max`, `range`. `which.min`/`which.max` are also misleading even though they seem to preserve the names but, as specified, they give you the index of the min/max value along with the right name. Similarly difficult are `pmin`/`pmax`.

```r-lang
bits <- ifelse(rep(TRUE, 4), enum(bit1 = 1, bit2 = 2, bit4 = 4, bit8 = 8), LETTERS[1:4])
bits
#> [1] 1 2 4 8
is.enum(bits)
#> FALSE

bits <- enum(bit1 = 1, bit2 = 2, bit4 = 4, bit8 = 8)
bits
#> Enum 
#> bit1 bit2 bit4 bit8 
#>    1    2    4    8
is.enum(bits)
#> TRUE
```

You can add the [sticky](https://github.com/decisionpatterns/sticky) package to retain attributes. But sticky does not work for all functions. E.g. `ifelse()` still removes them.


The same is unfortunately true for `for` loops. They strip the enumeration values of their names.
```r-lang
for (i in enum(a = 1, c = 3)) print(i)
#> [1] 1
#> [1] 3
```

If you need to use an enumeration in a loop, you can do that by using the double `[[` selector. 

```r-lang
myEnum <- enum(a = 1, c = 3)
for (i in myEnum) print(myEnum[[i]])
#> a
#> 1
#> c
#> 3
```





## Implementation

The enum solution is an S3 class based on atomic vectors. 

Several assignment functions have been replaced to make it harder to change the `enum` after it has been defined. Of course there is no way to completely avoid it. R is not strongly typed, 
and there will always be a way around it. The plainEnum package does it's best to avoid the most common mistakes.



## Installation

To get the current development version from github:

```r-lang
library(devtools)
devtools::install_github("SigurdJanson/plainEnum")
```
