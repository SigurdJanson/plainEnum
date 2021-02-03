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

Test if a value is part of an enumeration with `inEnum()`:

```r-lang
inEnum(7)
#> TRUE

inEnum("Thursday")
#> TRUE

inEnum("Thanksgiving")
#> FALSE
```

If you want to use the enumeration in shiny widgets, you need to strip them of all attributes, first:
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


Not yet supported are enums that skip values are do not start with 1.
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


