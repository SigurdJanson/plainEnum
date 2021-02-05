# plainEnum

The plainEnum package adds a simple crutch to emulate enumerations in R. 

An enumeration type (or enum type) is a value type defined by a set of named constants of the underlying integral numeric type. To define an enumeration type, use the enum keyword and specify the names of enum members.

They make it easier to write readable code: `Days["Monday"]` provides more information than `Days[1]` and is, thus, easier to understand.


The solution is based on atomic vectors.

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


The best way to use an enumeration value is the `[[` operator. The single `[` selects the position of the enum in the vector. To access `c` of an enum `enum(a = 1, c = 3)` you would have to use `enum(a = 1, c = 3)[2]`. That can be rather confusing. So the selection operator for enums is the double `[[`. 

```r-lang
Vision <- enum(Clear = 1, Blurred = 99, ColorDeficient = 666)
Vision[3]
#> ColorDeficient
#> 666
Vision[[3]] 
#> integer(0)
Vision[[666]]
#> ColorDeficient
#> 666
```



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

You have to avoid functions that remove attributes from its' arguments. The result in the following expression loses its attributes and is not an enum anymore.

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

The same is unfortunately true for `for` loops. They strip the enumeration values of their names.
```r-lang
for (i in enum(a = 1, c = 3)) print(i)
#> [1] 1
#> [1] 3
```

If you need to use an enum in a loop, you can do that by using the double `[[` selector.

```r-lang
myEnum <- enum(a = 1, c = 3)
for (i in myEnum) print(myEnum[[i]])
#> a
#> 1
#> c
#> 3
```



Not yet supported are enumerations that skip values or do not start with 1.
```r-lang
BinValue <- enum(bit1 = 1, bit2 = 2, bit4 = 4, bit8 = 8)
BinValue[3] # should be NA but returns 4
```

Hence, this is possible, but not recommended, yet:
```r-lang
Days[2]
#> Tuesday 
#>       2 
```

## Installation

TBD
