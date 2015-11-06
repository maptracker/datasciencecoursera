
* [Fundamentals](#fundamentals)
  * [Syntax](#syntax)
    * [Non-obvious Operators](#oddop)
  * [References and Helpful Tools](#reftool)
* [Objects](#objects)
  * [Object Utility Methods](#objutil)
  * [Atomic Classes](#atomic)
  * [Date and Time](#datetime)
  * [Vectors, Matrices and Data Frames](#vecmat)
    * [Subsetting](#subsetting)
    * [Vectors](#vectors)
      * [Vectorization](#vectorization)
    * [Lists](#lists)
    * [Matrices](#matrices)
    * [Recycling](#recycling)
    * [Arrays](#arrays)
    * [Factors](#factors)
    * [Data Frames](#dataframe)
* [Data Import and Export](#importexport)
  * [General File Manipulation](#filesystem)
  * [Data Import](#import)
  * [Data Export](#export)
  * [Connections](#connections)
  * [Databases](#databases)
    * [ODBC](#rodbc)
    * [PostgreSQL](#postgres)
    * [MySQL](#mysql)
    * [SQLite](#sqlite)
* [Data Transformation](#transformation)
  * [Sorting](#sorting)
  * [dplyr](#dplyr)
* [Control Structures](#control)
  * [if, else](#ifelse)
  * [for loops](#forloop)
  * [while loops](#while)
  * [repeat, next, break, return](#nextbreak)
  * [Loop Functions](#loopfunc)
    * [lapply](#lapply)
    * [sapply](#sapply)
    * [vapply](#vapply)
    * [mapply](#mapply)
    * [apply](#apply)
    * [tapply](#tapply)
      * [split](#split)
    * [mapply](#mapply)
    * [plyr](#plyr)
* [Functions](#functions)
  * [Symbol Scoping](#scoping)
* [Packages](#packages)
* [Object Oriented Programming](#oop)
  * [S3 OOP](#s3)
    * [Importance of Classes in S3](#s3classes)
  * [S4 OOP](#s4)
    * [setClass](#s4setclass)
    * [new](#s4new)
    * [Rle](#s4rle)
* [Developing in R](#rdeveloping)
  * [Errors and Error Handling](#errors)
  * [Debugging](#debugging)
  * [Profiling](#profiling)
  * [Programmer-like Objects](#dataobject)
* [Text Handling](#texthandling)
* [Probability](#probability)
  * [Distributions](#distributions)
  * [Random Number Generator](#rng)
* [Random Things](#randomstuff)
  * [Generating Examples](#makeexamp)
  * [Internal R Stuff](#rinternals)
  * [Serialization](#serialization)
  * [Scott Wisdom](#wisdom)
  * [Weird Things](#weird)
    * [Aliases, Aliases, Aliases](#aliases)
    * [data.class() vs class()](#dataclassweird)
  * [Markdown Notes](#markdown)

# <a name='fundamentals'></a> Fundamentals #

* `x <- y` : The arrow operator is **always** a copy function. That
  is, it does NOT simply create a new reference/pointer to the
  right-hand argument. In the above example, x and y will be "the
  same", but will be two independent objects (manipulating x will not
  change y, even if y is a data frame or other 'complex' object).
  * The `identical(x,y)` function can be used to do a deep
    identity test on two objects.
  * `all.equals(a,b,c,...)` is similar to identical, but it can take
    multiple arguments and can specify a `tolerance` to allow for
    minor mathematical differences.
* `=` can be used as an alias for `<-`
  * Scott avoids this, because it can cause confusion when dealing
    with parameter assignment, which also uses equals, for example
    with the 'nrow' parameter in `diag(1:2, nrow = 4)`
* R is case-sensitive: b != B
* <a name='setget'></a>Left methods and right methods may have the
  same name, but are generally different functions.
  * Example: `dim()`
    * On the right(eg `myDims <- dim(myMatrix)`), will **get**
      the dimensionality of the query
    * On the left (eg `dim(myMatrix) <- c(2, 3)`) will **set** dimensions
    * These are **two different functions** in R
      * The right function is named "as is", that is just "dim"
      * The "real" name of the left function is `dim<-` (that is,
        with the "<-" arrow tacked on), which R calls a "replacement
        method". Scott calls this "dim gets"
      * `?dim` will show you help for *both* methods
  * Not all functions follow this paradigm; For example, finding the
    locale of the current system is broken into the separate functions
    `Sys.getlocale()` and `Sys.setlocale()`

### <a name='syntax'></a>Syntax Considerations ###

* `.` (period) has - *sometimes* - special meaning. Sometimes it does
  not. If you wish, you can use it as an arbitrary character in a
  variable name. This is probably not a good idea, though, as it can
  cause confusion with [S3 OOP classes](#s3).
* `_` (underscore) has no special meaning in R, and can be used in
  variable names. *However*, it has (had?) special meaning in S, where
  it served as an alias for `<-`. This means that use of underscores
  can make your code incompatible in S. Probably best to avoid usage.
  * The emacs ESS major mode [ESS][ESS] will irritatingly convert `_`
    to ` <- ` automatically. Probably can override somewhere.
* `<<-` is a special assignment vector that will bypass normal
  [scope](#scoping) to assign variables in the
  function-environment-hierarchy
* `:::` is used to access [internally scoped](#internalscope) variables
* Backticks allow recovery of function objects that would otherwise
  insist on be function-y eg `` `if` ``
* There are a few "naked" operators, like `next` or `break`, but
  nearly all other functions should include parentheses: Using
  `return` will return the *function* return; You probably wanted to
  `return()`.
* Curly brackets define an "expression", eg `{ op1; op2; op3}`. The
  last operation is what will be returned.

#### <a name='oddop'></a>Non-obvious Operators ####

* `%%` Modulus
* `%/%` Integer division (no decimal / remainder)
* `%*%` Matrix multiplication
* `&` / `|` = Vectorized logical AND / OR. `c(T,F,T) & c(F,F,T)` =
  `[1] FALSE FALSE TRUE`. That is, it cycles over the elements and
  performs the requested boolean logic.
  * `&&` / `||` = I still have not quite figured out what this
    does. They're boolean operations that cascade in some way.

### <a name='reftool'></a>References and Helpful Tools ###

* [Advanced R][AdvancedR] = Hadley Wickham's R site
* [The R Inferno][Rinferno] : A fairly deep look at some of the issues
  in R
* `library(codetools)` / `?codetools` : debugging utilities
  * `checkUsage( myFunction )` : provides some feedback on potential
    issues, like undeclared variables.

# <a name='objects'></a>Objects #

* [Hadley Wickham : Data structures][WickhamDataStructures] - nice
  overview shared by Scott.
* Objects have an initial value that is used when an object is needed
  but has not been explicitly provided. For example, if you create a
  structure that is specified as having integers, but you don't
  provide the actual values, then the default value is used until such
  time as you provide your own.
* Names
  * Most R objects can have names
    * If you try to name something that is un-name-able, you'll get
      `target of assignment expands to non-language object`
  * `names(someObject) <- c("First name", "another name", "name 3")`
    * If you supply insufficient names, `NA` is assigned to the
      remaining parts of the object
    * Assigning too many names yields `'names' attribute [#] must be
      the same length as the vector [#]`, and the assignment fails
      (nothing changes).
  * `dimnames(myMatrix) <- list(c("alpha", "beta"), c("hot", "cold"))`
    * Assigns row and column names, respectively, to a matrix
  * In some circumstances R allows "partial matching", where you need
    not provide the entire name, only enough of the first letters to
    unambiguously distinguish the name from other names in the object.
    * This is potentially dangerous and should probably not be used in
      practice.
* Attributes
  * `attributes()` can get and set values
  * names & dimnames, dimensions (matrices, arrays), class, length, etc
  * user-defined

### <a name='objutil'></a>Object Utility Methods ###

* `str()` = "Structure"
  * Provides a verbose report of what the object is and what
    value(s) it contains.
  * Includes a dozen parameters controlling output
* `summary()`
  * Context-specific, brief information on an object
  * For lists / vectors reports min, max, mean, median and quartiles
* `head()` = report first n (default 10) lines of a list / vector /
  file / etc
  * `tail()` = reports last n lines
* `typeof()` = "storage mode" (basic class)
  * For a vector, reports the mode of the contents (ie not "vector")
* `class()` = like typeof, but reports object classes (ie, inherited
  classes in an Objected Oriented paradigm).
  * class can also be a left-had argument used to *set* the class of
    an object. This can be used to assign a class
    * The R documents disadvise doing this, and recommend `as()`
      to coerce a class instead.
    * `inherits()` tests if a particular object belongs to a particular class
      * `inherits(x, what = 'vector')`
  * `data.class()` = seems similar-but-different to class. It
    [behaves weirdly](#dataclassweird).
* `summary()` = brief overview of object
  * Reports "NA" content
* `quantile( myNumericVector, na.rm = FALSE)` = Report numeric values
  within your vector residing at specific probabilities.
  * `probs` = Specifies probability bins, default is `seq(0, 1, 0.25)`
* `table( factors1, factors2, ... )` = Report summary counts for
  factors or factorizable data.
  * `as.table()` = will try to coerce the input to a table
  * `is.table()` = will test input to see if it is a contingency table
  * `use.NA = "ifany"` = Always useful to add, will include a count of
    NA values (otherwise will not!)
* `is.SOMETHING()` = class / type test method
  * eg `is.numeric()`
  * Returns a boolean indicating if the object "is" that thing
* `as.SOMETHING()` = coerce / cast an object from one mode to another
  * eg `as.integer()`

### <a name='atomic'></a>Atomic Classes ###

* Character
  * default value `""` (empty string)
  * `is.character()` / `as.character()`
* Numeric
  * The aliases "double" and "real" can be interchanged anywhere
    "numeric" is used. `typeof(1.3)` will return "double".
  * default value `0`
  * `is.numeric()` / `as.numeric()`
  * Double-precision reals
  * `Inf` = infinity, `-Inf` = negative infinity
    * `is.finite()` / `is.infinite()`
    * R defines `1 / 0` as Inf - why isn't that UNDEF, since it's
      either Inf or -Inf ??
  * With some effort can [increase magnitude of floats][BigNumbersInR]:
    * `library(gmp)` = "Arithmetic Without Limits"
    * `library(Brobdingnag)` = represent numbers in log form
  * `options(digits=16)` = set the number of digits R displays
    ([StackOverflow][SObignumbers])
* Integer
  * default value `0`
  * `is.integer()` / `as.integer()`
  * If defining explicitly, suffix with `L` to avoid being cast as
    numeric, eg `172L`
* Complex
  * default value `0+0i`
  * `is.complex()` / `as.complex()`
* Logical (Boolean)
  * default value `FALSE`
* <a name='specialvalues'></a>Special values
  * <a name='NA'></a>`NA` = "Not Available"
    * `is.na()` = boolean check
    * Apparently returned for "not possible", eg `as.integer("pineapple")`
    * Is the default value for some objects, such as matrices without
      any values.
    * NA can exist in many (any?) of the other modes. That is, there
      is an integer mode for NA, a character mode, etc. The default
      mode appears to be logical.
      * These can be assigned directly with `as`, for example `as.character(NA)`
      * More commonly the mode will be assigned "automatically" to
        make the mode fit the surrounding context. In the example
        below, the "NA" is mode numeric, since that is the mode of the
        source vector:
        
        ```R
        > x <- c( one = 1, two = 2, four = 4)
        > x[c("one", "three")]
         one <NA> 
           1   NA 
        > mode(x[c("one", "three")][[2]])
        [1] "numeric"
        ```
    * `NaN` = Not a Number
      * `is.nan()`
      * More specific form of NA
      * Used for missing values, plus "not numbers".
  * `NULL` = undefined
    * `is.null()`
      * Throws an error with no argument. Seems like that should be "TRUE"
    * Weird behavior. Throws an error when passed to is.na(), but
      spits out a bizarre value of `logical(0)` with is.nan(). May
      be a sign of a latent malignant AI - must watch carefully.
    * Asking Scott about NULL seems to make him uncomfortable, like
      telling a parent that their child is eating paste.

### <a name='datetime'></a>Date and Time ###

* `Date` class
  * Uses POSIX standard relative to 1 Jan 1970, resolved in days for
    dates and seconds for times.
    * Internally the date is an integer (?) value with zero at the
      start of 1970
      * *Times can capture sub-second resolution, not sure how that's
        handled with an integer representation.*
    * **POSIXct** = internal format that represents dates and times
      numerically.
    * **POSIXlt** = internal format representing dates and times as
      structures, such that sub-parts (eg month, seconds) can be
      accessed by name.
      * If you see the error `$ operator is invalid for atomic
        vectors` then your object may be in ct format and should be
        transformed to lt.
    * `as.POSIXct()` and `as.POSIXlt()` can be used to convert back
      and forth.
* `Time` class
* Built-in utility methods:
  * `as.Date( dateString )` = Make a date object. The default `format` is
    `"%Y-%m-%d"`, but can be set as something else.
  * `strptime( dateString)` = Format date output, similar to sprintf.
  * `Sys.Date()` = Current date for the system's locale.
  * `Sys.time()` = System's time in POSIXct format
  * `Sys.getlocale()` / `Sys.setlocale()` = get or set
  * `weekdays( dateObject )` = return the name of the day (eg "Sunday")
  * `months( dateObject )` = return month name
  * `quarters( dateObject )` = Quarter name (eg "Q3")
  * `julian( dateObject, origin = dateObject)` = get the difference in
    days between two Dates.
* Date math
  * As long as the objects are the same classes, mathematical
    operations can be done.
  * Generates `difftime` time range objects.
  * Can provide specific time zones to each object in the comparison

```R
dt <- as.Date("1970-02-01")
```

## <a name='vecmat'></a>Vectors, Matrices and Data Frames ##

* "Lists of stuff"

#### <a name='subsetting'></a>Subsetting ####

* Selecting part of a list
* `[` = returns an object of the same class, can select multiple elements. Simple example with a vector:

  ```R
v <- c(12,6,7,NA,19,5)
v[3] # Get the third element
v[c(3,5)] # Get third and fifth element
v[2:4] # Elements 2,3,4
v[v < 15] # All elements less than 15
b <- v < 15 # b is a logical vector same length as v, reporting entries < 15
v[b] # Will perform the same selection as two lines up
# NA entries can be irritating; they return NA in booleans, too
v[which(b)]  # Use which() to avoid them
  ```
  
  * Single brackets are needed for accessing multiple elements from a list
* ``[[`` = Access a specific element
  * Only one element at a time!
* `$` = Access by name. Simple example with list:

  ```R
  myList <- list( dog = c(17,32,1), cat = c(7,5,2) )
  myList$dog      # A numeric vector representing the 'dog' column
  myList[[1]]     # Same as above, a vector from the dog column
  myList[["dog"]] # Same as above, accessing via name
  
  myList[1]       # a *list* of just the dog column. Includes the name
  myList["dog"]   # Same as above, accessing via name
  colName <- "dog"
  myList[colName] # Same as myList["dog"]
  
  myList[[1]][[2]] # Get single element in first row, second column
  myList[[c(1,2)]] # Same as above
  ```
  
* Matrix subsets that are 1 dimensional by default will return
  vectors. If you want such results to remain as matrices, use `drop
  = FALSE`. Examples:
  
  ```R
  x <- matrix( 11:22, nrow = 3, dimnames = list
    ( c("Alice","Bob","Chris"),
      c("Alpha","Beta","Gamma","Delta") ) )
  x[[10]]        # Get the 10th element
  x[ 2, ]        # Get the second row
  x[ "Bob" ]     # second row by name
  x[ , 3]        # Third column
  x[ , "Gamma" ] # Third column by name
  x[ 2,1 ]       # Element in second row, first column *as a vector*
  x[ 2,1, drop = FALSE ] # As above, but now returns a 1x1 matrix
  x[ c(2,3),c(2,4) ]     # Slice of rows 2+3 / cols 2+4
  # Matrices do not use '$' for named accession:
  x[ c("Bob","Chris"), c("Beta","Delta") ] # Same slice as above
  ```

* Missing values can be found with `is.na()`, and exclued with `!is.na()`.
  * `complete.cases()` can be used to exclude any row with a missing
    value in any column.

  ```R
  > x <- data.frame( color = c("blue", "red", NA, "yellow"),
                     weight = c(13.2, NA, NA, 19.9))
  > !is.na(x$color)
  [1]  TRUE  TRUE FALSE  TRUE
  > ccx <- complete.cases(x)
  > x[ ccx, ]
     color weight
  1   blue   13.2
  4 yellow   19.9
  ```

* When using [S4 objects](#s4), the "slots" are accessed with the `@`
  operator.

#### <a name='vectors'></a>Vectors ####

* Most basic object
  * Scott says instead of scalars R uses vectors-of-length-one. That
    is, if you need to represent a single number, it's not a scalar
    object, but rather a vector with one entry. Presumably that's
    why when you evaluate just `4.3` R will reply `[1] 4.3`; the
    "[1]" is a reminder that R views this as a vector with one
    element, which is the double 4.3.
* Must contain homogeneous (same class) entries
* Creation
  * `vector()`
    * `x <- vector("numeric", length = 10)`
    * Initialized with default values.
  * `c()` = "concatenate"
    * `x <- c( 1L, 2L, 3L )`
    * **CAUTION:** c() will type-cast your input to force it into
      homogeneity, if required. For example:
    * `x <- c( 1L, 2L, 3L, 5, "7" )` (integer, numeric, character)
      * `str(x)` &rarr; `chr [1:5] "1" "2" "3" "5" "7"` (all characters!)
* Sequences
  * Iterative vectors, defined easily with ":"
  * Shorthand `1:20` = 1, 2, 3 ... 19, 20
  * Scott says to use `seq()` as a safer version:
    * `1:length(x)`: If x is zero length, you probably wanted an
      empty vector, but instead you'll get a vector of length 2: `c(1,0)`
    * `seq(from = 1, to = length(x), length = length(x))` will
      provide what you need (`integer(0)`, an integer vector with no
      members).

##### <a name='vectorization'></a>Vectorization #####

* Many R operations occur in vector context - the arguments are
  vectors, and are operated on in an implicit loop on all vector
  members.
* Be very aware of [recycling](#recycling), which will occur if you
  perform operations with two vectors of different length. You will
  only be warned of this if the shorter vector can not be "evenly"
  recycled to match the longer one.

```R
> v <- c(4, 10, 25)
> v + 3
[1]  7 13 28
> v %% 2
[1] 0 0 1
> v < 14
[1]  TRUE  TRUE FALSE
> w <- c(2,3,2)
> v * w
[1]  8 30 50
> x <- c(2,4,6,8,10)
> v - x  # recycling is unhappy
[1]  2  6 19 -4  0
Warning message:
In v - x : longer object length is not a multiple of shorter object length
> y <- c(2)
> v - y  # recycling is content!!
[1]  2  8 23
```

#### <a name='lists'></a>Lists ####

* A list of things, optionally keyed to names.
  * The "things" are formally referred to as "elements". When I
    mentioned that I think of them as "columns" I got a disapproving
    look from Scott.
* Utilities
  * `is.list( obj )` = Logical check
  * `typeof( genericList )` &rarr; `list`
* Lists can be turned into arrays by assigning `dim()`. Scott says
  this is generally useless, but occasionally very useful;
  Conversion to an array lets members be accessed by row and column
  indices/names.
* <a name='pairlists'></a>A **dotted pair list** is a weird variant that
  shows up in some output. It apparently has something to do with
  Lisp, but I have not found anything beyond cryptic
  references. AFAICT you can use these lists just like other lists.
  * Found while playing with the `formals()` function.
  * `typeof( myWeirdDottedPairList )` &rarr; `"pairlist"`
  * `is.list( myWeirdDottedPairList )` &rarr; `TRUE`
  * `is.pairlist( myWeirdDottedPairList )` &rarr; `TRUE`
  * `is.pairlist( myNormalList )` &rarr; `FALSE`
  * `is.pairlist(NULL)` &rarr; `TRUE`
  * `is.list(NULL)` &rarr; `FALSE`

#### <a name='matrices'></a>Matrices ####

* Two dimensional array
* default components `NA`
* `is.matrix()` / `as.matrix()`
  * as.matrix will make a single column array
  * `is.array()` will evaluate TRUE
* `matrix( nrow = 2, ncol = 3 )` = empty
  * Attribute `dimnames` can be used to name the rows an columns
* `matrix(1:6, nrow = 2, ncol = 3 )` = populated with the sequence
  * Construction is "column-wise", meaning the matrix columns are
    filled first into column 1, then column 2, etc
  * While maintaining dimensionality, the contents of the matrix are
    effectively a linear vector wrapped into those dimensions.
    * However, `is.vector` will evaluate FALSE.
* `dim()` = return dimensions of matrix
  * `dim` can also be **assigned**:
    * `dim(myMatrix) <- c(2,5)`
  * Doing so will "linearize the contents of the matrix, and then
    re-construct them (column-by-column) into the specified dimensions.
* `cbind( col1, col2, ... )` / `rbind( row1, row2, ...)` = pass
  explicit vectors that you wish to write into columns or rows of a new matrix
  * **CAUTION:** If your provided vectors are not the same length, R
    will "pad" them out by *repeating the input vector* until the full
    dimensionality is filled. See the [Recycling section](#recycling).
* `diag()` = weirdly polymorphic matrix function:

  ```R
  myDiag <- diag( myMatrix ) # Extract the diagonal
  mySquare <- diag( 5 ) # Creates a 5x5 matrix
  myMostlyEmpty <- diag(1:10) # Creates a 10x10 matrix with only the diagonal populated
  diag( myMatrix ) <- value # Change the diagonal
  x <- diag(5,4)  # Creates a 4x4 empty matrix with a diagonal of fives.
  ```

#### <a name='recycling'></a>Recycling ####

* Some structures have an implicit size (for example, a 4x4 matrix has
  a length of 16). In at least some cases, these structures can be
  provided with content that has a lesser size. R can behave in
  different ways in different circumstances.
* In some cases, the "extra" values will be populated with the
  initial/default values for the mode.
* In other cases, the input will be **recycled**. That is, R will
  keep looping through the input to fill out the result. For
  example:
  
  ```R
  > rbind(16:18,5:9)
       [,1] [,2] [,3] [,4] [,5]
  [1,]   16   17   18   16   17
  [2,]    5    6    7    8    9
  Warning message:
  In rbind(16:18, 5:9) :
    number of columns of result is not a multiple of vector length (arg 1)
  ```
  
    * In the case above, the matrix has five columns, but the first
      row has only three values (`c(16,17,18)`) provided. R responds
      by "recycling" the row over and over until the matrix is
      padded out to the full five columns.
    * In this case, R can pad out the row by recycling the input
      twice, but it has "one left over" (`5 %% 3 == 2`). This upsets
      it, and while it completes the recycling, it complains `number
      of columns of result is not a multiple of vector length`
    * If R was able to "cleanly" recycle the input, **you will be
      given no warning**:
      
      ```R
      > rbind(7:9, 20:28)
           [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
      [1,]    7    8    9    7    8    9    7    8    9
      [2,]   20   21   22   23   24   25   26   27   28
            ```
* In some cases, recycling will refuse to operate if the modulus is not met:
  ```R
  > sprintf("%s %d %d", "test", 1:3, 10:11)
  Error in sprintf("%s %d %d", "test", 1:3, 10:11) : 
    arguments cannot be recycled to the same length
  ```

#### <a name='arrays'></a>Arrays ####

* Under construction

#### <a name='factors'></a>Factors ####

* Factors are "labeled integer vectors"
* Useful for categorical data, like "Male" / "Female" or "10 ug" /
  "20 ug" / "50 ug"
* Functionally will be utilized as vectors, but the labels provide
  human interpretation (so you don't forget what 4 represents).
* Used in modeling methods like `lm()` and `glm()`
  
  ```R
  > x <- factor(c("peach", "pear", "marmoset", "peach", "peach"))
  > typeof(x)
  [1] "integer"
  > str(x)
   Factor w/ 3 levels "marmoset","peach",..: 2 3 1 2 2
  ```
  
  * Note that internally while your order is maintained the integer
    assignment is made independently by R; peach is 2, even though it
    was "first".
  * `levels(x)` = reports the factor names as ordered by integer value
  * If you want to set the factor order explicitly, the `levels`
    argument can be used:
    
    ```R
    x <- factor(c("peach", "pear", "marmoset", "peach", "peach"),
                 levels = c("peach", "pear", "marmoset"))
    ```
    
* The order of levels is important in some modeling because the
    first level is taken as baseline.
* `table()` = simple contingency table of the factor
  * By default missing values will be excluded in the counts! set
    `exclude = NULL` to count them as well. Scott says some
    statistic shops have altered the table function to have this as
    the default.
* `gl()` = "Generate Levels", make a vector of factors based on some
  pattern:
  
  ```R
  gl(n = 3, k = 4, labels = c("alpha", "beta", "gamma"))
   [1] alpha alpha alpha alpha beta  beta  beta  beta  gamma gamma gamma gamma
  Levels: alpha beta gamma
  ```
    
#### <a name='dataframe'></a>Data Frames ####

* Special form of list
  * Each element is effectively a column
  * Like a matrix, is rectangular: All columns must have same length
    (same number of rows)
  * Like a list, but unlike a matrix, a data frame can be
    heterogeneous; Each column can be a different data type
  * Popularly abbreviated **DF**.
* Every row is named (attribute `row.names`)
  * These names are preserved when subsetting.
* `data.matrix()` = convert to matrix
* Creation
  * `read.table()` [see below](#import)
  * `data.frame( col1, col2, ... )` = direct generation
  * `myDF$myCol <- myVector` = Assigns myVector to the column myCol in
    DF myDF
    * `myDF <- cbind( myDF, myCol = myVector )` = Same as above
  * `rbind(DF1, DF2)` = Appends rows, columns must be identical

##### <a name='datatable'></a>Data Tables #####

* Not part of core R:
  * `install.packages("data.table")`
  * `library(data.table)`
  * [Has its own website][datatable], plus [code on GitHub][datatablegithub]
  * [Comparison to data.frame][dfVSdt]
  * [Good intro to using data.table][advmanip]
  * Is supposed to be much faster than data.frame, particularly for
    subsetting, group and updating.
  * **OBJECTS ARE UTILIZED AS REFERENCES!!**
    * `yourDT <- myDT` = yourDT and myDT *are the same object*
    * Use `yourDT <- copy(myDT)` to get a "distinct" object
* `myDT <- data.table()` = Create a new data table
* `tables()` = Shows current tables held in memory
* Can efficiently add new columns with `:=`
  * `myDT[, w := z^2]` = Adds a column "w" as the square of z.
  * `myDT[,b:= mean(x+w),by=a]` = [plyr-like](#plyr) operation that
    sets column "b" to be equal to the mean of x+w, where x+w are
    aggregated "by" column a as a factor.
  * `myDT[, .N, by=x]` = uses special variable `.N` which represents the
    count of the expression
* Subsetting
  * Subsets get complex enough that data.table simply *discards row names*. 
  * Row subsetting is effectively the same as a DF
  * Column subsetting is quite different
    * Can pass a list of functions
    * Still confused here...
* `setKey(myDT, z)` = specifies that column "z" holds the "keys"
  associated with the data.table.
  * `myDT[ "rootbeer" ]` = Will subset the table with all rows where
    the designated key column is equal to "rootbeer".
  * `merge( myTab1, myTab2 )` = Will perform a join on the two tables,
    merging rows where their key columns match.
* `fread( myFile )` = Fast read of a data.table.
  * In addition to being faster than `read.table()`, the defaults look
    to be different (such as `stringsAsFactors` being false for DT).

# <a name='importexport'></a>Data Import and Export #

* [CRAN guide to Data Import/Export][CranImportExport]
* *I remain very confused over the diversity of import / export methods*
  * Some of the functions appear to be almost identical (`serialize`
    vs `saveRDS`) and it's unclear what the nuances are.
* [Advanced Data Manipulation][advmanip] - Tips for working
  efficiently with large data sets.

### <a name='filesystem'></a>General File Manipulation ###

* General Considerations and Quirks
  * There are directory-specific commands below, but many of the
    "file" commands will work with directories as well. For example,
    file.exists() will return a true value if passed either an
    existing file or existing directory. Use dir.exists() if you need
    to explicitly determine if the path is a directory.
  * Platform variation
    * Help indicates that you *must not* include a trailing backslash if
      passing a directory path on Windows.
    * Case sensistivity varies by platform. On insensitive platforms,
      some functions may map filenames to upper or lower case.
  * In most cases R appears to be aware that `~` represents the user's
    home directory.
* File manipulation
  * `list.files( myDir )` = Returns a character vector of the file
    paths in the specified directory
    * Defaults to the current working directory
    * `pattern = myRegExp` = Specifies an optional regular expression
      against which files must be matched.
    * `full.names` = Default FALSE, if TRUE will return absolute
      paths.
    * `recursive` = Default FALSE, when TRUE the listing recursively
      drills into directories.
    * `include.dirs` = Default FALSE, which will exclude directories
      from the returned value.
  * `file.exists( myFileList )` = Returns a logical vector if the file
    exists. Note that for links the result is if the target exists.
  * `file.remove( myFileList )` = Deletes the passed file paths. Can
    remove empty directories. Returns logical "success vector"
  * `unlink( myFileList, recursive = FALSE, force = FALSE )`
    * Deletes the requested files / directories.
    * Returns logical "success vector"
    * Allows `*` and `?` wildcards, as supported by host filesystem.
    * If `recursive` is TRUE then encountered directories will be
      fully deleted, if possible. If FALSE then even
      explicitly-specified empty directories will not be removed.
  * `file.create( myFileList )` = Creates the files if they do not
    exist. Returns logical "success vector"
    * **WILL TRUNCATE EXISTING FILES**
  * `file.rename( from, to )` = Change a file's name. Returns logical
    "success vector"
  * `file.info( myFileList )` = Returns a data frame of information
    related to the provided paths:
    * `size` = Size in bytes
    * `isdir` = Logical flag indicating if the path is a directory
    * `mode` = Permissions octal flags
    * `mtime` = Modification time
    * `ctime` = Creation time
    * `atime` = Access time
    * `uid` = User ID
    * `gid` = Group ID
    * `uname` = User name
    * `gname` = Group name
  * `file.mtime()`, `file.size()`, `file.mode()` = Wrappers around
    file.info that return just a single column.
  * `file.show( myFileList )` = Paginated file viewer, like `more`,
    showing the file(s) requested.
  * `file.append( targetFiles, sourceFiles )` = Appends the second
    argument to the first. Not clear to me how multiple/multiple
    requests are handled.
  * `file.copy( from, to )` = Make copies of "from" in "to"
    * `to` can be a list of files, or a single directory.
      * `recursive = FALSE` When copying to a single directory, the
        recursive flag indicates if "from" directories should be
        deep-copied.
    * `overwrite` = If false, will prevent existing files from being
      clobbered. The default is "recursive", unclear what that is.
    * `copy.mode = TRUE` = Specifies if "to" should inherit mode
      (permissions) from "from"
    * `copy.date = FALSE` = Specifies if "to" should inherit date from "from"
* Directory manipulation
  * `getwd()` = get the current working directory
  * `setwd( myPath )` = set working directory. Allows absolute and relative
    paths
    * Lecture says escaped "\\" must be used for windows hierarchy?
      That seems poorly designed. Help indicates that getwd will
      consistently use "/", even on Windows.
  * `dir.exists( myPath )` = Check that a path exists AND is a
    directory. Vectorized, will return a logical vector.
  * `dir.create( myPath, recursive = FALSE, mode = "0777")` = Creates
    the specified directory with requested mode
    * A TRUE `recursive` flag will also create any parent directories
      as needed.
    * Will throw a warning if the directory already exists
* Permissions
  * Use a special integer mode of class `octmode`
  * `Sys.chmod( myPaths, mode = "0777")` = Sets the permissions on one
    or more files.
  * `Sys.umask( optionalNewValue )` = Sets and returns the current umask
  * `file.mode( )` = wrapper around file.info; Returns the octal mode of the
* Links
  * Platform dependent! Generally if a link is passed to one of the
    above functions, the operations will be on the target, not the
    link itself.
  * `file.symlink( from, to )` = Create a symbolic link to a
    file. Returns logical "success vector"
  * `file.link( from, to )` = Create a hard link to a file. Returns
    logical "success vector"
  

### <a name='import'></a>Data Import ###

* `read.table()` = flexible file import, lots of parameters:
  * `file` = path to file, or a connection
  * `header` = flag indicating a header row is present
  * `spe` = column separator
  * `colClasses` = character vector specifying column classes
    * Always a good idea to specify this for large files, since
      otherwise an initial scan is required for R to analyze the file.
  * `nrows` = number of rows to read in
    * Presumably this would be useful in testing to read in a subset
    * Lecture implies that providing the actual value (or something a
      bit larger) improves read performance?
    * `skip` = number of leading rows to skip over (useful for
      interrupted loads))
  * `comment.char` = character that defines a comment row
    * Default is "#"
    * Set to `""` if you are reading a large file with no comments
  * `stringsAsFactors` = if true (**DEFAULT!**), factorize strings
    * `as.is` = utility flag that is the opposite of stringsAsFactors,
      forces import of data as they are in the file.
  * `na.strings` = character vector of strings to be treated as `NA`
  * `strip.white` = if true, the leading and trailing white space
    around character information will be automatically removed.
    * `blank.lines.skip` = skip rows that are entirely empty
  * `read.csv()` = alias for read.table, but with different defaults
    for CSV files. Use `read.csv2()` for CSV formats from countries
    where ',' is used as a decimal point.
  * <a name='quotedCoercion'></a>**Caution** - If a "cell" in a file is
    quoted, R will consider it character data *no matter what you've
    specified with colClasses*. If you try to set the mode with
    colClasses to something other than "character" (numeric, logical,
    etc), R will halt with an error. You need to read such columns as
    character, [then explicitly cast them][ReadCsvForcedChar], for
    example with as.numeric().
* `readLines(fileName, numLines)` = read arbitrary lines from a text file
  * returns a character vector
* `load()` = reads in binary R object saved to a file
  * **PREFERRED METHOD**
  * Inverse of `save`
  * Can reconstitute an entire R workspace
* `source()` = reads ASCII-serialized R objects
  * Inverse of `dump`
* `dget()` = reads ASCII-serialized R objects
  * Inverse of `dput`
* `unserialize()` = reconsitute an R object via a [connection](#connections)
  * Inverse of `serialize`. Can also use `loadRDS`
* `loadRDS` = Similar to `unserialize`. Preferred?
* `scan()` = less convenient that read.table, but **much** faster; Useful
  for very large files.
* <a name='downloadfile'></a>`download.file(url, destination)` =
  Download a file over the network and save it to a local destination.
  * `method` = Specifies the method used (internal, libcurl, wget, curl)
    * `extra` = Additional options passed to the method
    * HTTPS sites may not work with some methods (`curl` will work)
  * `quiet` = Set to TRUE to suppress status and progress
  * `cacheOK` = Default TRUE, which allows server-side cached values
    to be used.
  * Proxies are handled with environment variables http_proxy /
    ftp_proxy (or upper case variants).
  * `options( internet.info = 2 )` = Default verbosity. Setting to 0
    or 1 providesmore information.
  * [url()](#connections) provides a finer-grained connection
    mechanism to access a networked file.
* `library(XML)` - [Using XML in R][xmlInR]
  * `myDoc <- xmlTreeParse( fileOrUrl )` = parses the tree into a structure
    * `htmlTreeParse()` = version of xmlTreeParse with defaults
      altered for HTML data.
  * `xmlSApply( xmlNode, <xmlType> )`. "<xmlType>" is one of the naked
    identifiers:
    * `xmlValue` = The text content of the nodes
    * `xmlAttrs` = Attributes assigned to the nodes
    * `xmlSize` = Number of child nodes
  * `xpathSApply( xmlNode, "<nodeSelector>", <xmlType> )` = Like
    above, but "<nodeSelector>" is a quoted xpath node selection
    syntax
* `library(jsonlite)` - [jsonlite tutorial][jsonlite]
  * `jsonData <- fromJSON( myFileOrUrl )`
    * jsonData will be a nested data.frame representing the
      hierarchical JSON object.
* <a name='complexformats'></a>More complex formats
  * `install.packages("XLConnect")`
    * Looks to be a very rich library to read and write Excel workbooks.
    * `xlcDump()` = Dumps R objects as worksheets in a workbook
    * `xlcRestore()` = Reads such a workbook back into R
  * `library(xlsx)` = Allows import and export of Excel spreadsheets
    * `read.xlsx( file, sheetIndex = mySheetNum, header = TRUE)`
    * `colIndex` and `rowIndex` are vector arguments specifying
      specific columns and rows to read.

### <a name='export'></a>Data Export ###

* `save()` = full export of an R object to a file
  * **PREFERRED METHOD**
  * Inverse of `load` 
  * Default format is binary, but argument `ascii` can be used to make
    an ascii file
  * `save.image()` will save the entire workspace
* `dput(obj, file = "/file/path/myObj.R")` = serializes an R object to
  ASCII text
  * Inverse of `dget`
  * Not as complete as `save`; will not export object name
  * Essentially generates R code that will reconstitute the object.
    * Somewhat human-readable, but the generated code is generally
      much more verbose than the code you used to generate the object
      in the first place. Presumably the code generation function
      works as a reverse-compiler.
* `dump(c("obj1", "obj2"), file = 'myDump.R')` = serialize one or more
  R objects to ASCII text
  * Inverse of `source`
  * Takes a list of *names* as input (not objects)
    * When reconstituted with `source` it will invoke the objects under
      their original names.
    * You can set the first argument with `ls( pattern = "myRegExp")`
      to select objects by a complex regular expression
  * May not generate an exact copy
* `serialize` = Serialize a single R object
  * Inverse of `unserialize`. The output can also be read by `readRDS`
    * Docs say `saveRDS` is "more convenient"
  * Default is binary format, but can be set to ASCII
  * Documentation warns that the format may change in future releases of R
* `saveRDS()` = Serialize a single R object
  * Inverse of `loadRDS`. Resultant files can also be read by `unserialize`?
* Lectures point out that text-based formats are more friendly with
  version control systems for finer-granularity change tracking
* Also see the [Serialization](#serialization) section below
* Note also the [more complex formats](#complexformats) mentioned
  above in the Import section, many of those packages also export
* `library(jsonlite)`
  * `jsonText <- toJson( rObject )` = will serialize an R object to
    JSON. Lots of configuration arguments.

### <a name='connections'></a>Connections ###

* Includes files, but also file compression/decompression, URLs, pipes
* `file()` = general utility read/write
* `url()` = general utility URL access, supports http, https, ftp and file.
  * `method = "libcurl"` exposes more schemes, depending on platform
  * file methods are local machine only and need to be absolute paths
  * `URLencode` can be used to escape parameters in the
    URL. `URLdecode()` might be useful for unescaping.
  * [download.file()](#downloadfile) is a simpler mechanism 
* Compression algorithms: `gzfile()`, `bzfile()`, `xzfile()`, `unz()`
  * zip files may be read with unz, but not created
* `open( myCon ... )` = used to create a handle after specifying one
  of the connections above.
  * `close()` and `flush()` can operate on an open connection
  * `isOpen()` and `isIncomplete()` utility functions
* Connections have an `open` argument specifying the read/write state
  * `r`, `w`, `a` = ASCII read, write, append
  * `rb`, `wb`, `ab` = Binary read, write, append
  * `r+` = read and write, `w+` = truncate, then read + write, `a+` =
    read and append. Not sure where these modes would be used; Maybe
    if memory is limited?
* `file( description = "clipboard", open = "r" )` = special mode to
  read the X11 clipboard. Setting description to "X11_secondary" reads
  the alternate clipboard.
* Session limit of 125 user connections

### <a name='databases'></a>Databases ###

* Some packages will mask one another; For example, `dbApply()` in
  both RPostgreSQL and RMySQL. Be careful if using two or more
  database architectures.

#### dbConnect ####

* Higher-level supporting package
* Comes with MySQL by default?
  * Specific database driver support below
* The number of simultaneous connections appears to be 10 (per
  driver?)

```R
# Change for the DB architecture you use:
library(RPostgreSQL)

# Establish a connection object
# The first argument is the driver, match to the DB architecture
con <- dbConnect(PostgreSQL(), user="username", db="mydb", port="5433",
                    host="example.com")
                    
# Build and execute a SQL statement:
sql <- "SELECT * FROM tags WHERE tag LIKE 'ran%'"
# GetQuery will execute the SQL and return the results
ranTags <- dbGetQuery(con, sql)
# The returned object is a DF with matched column headers
ranTags
        tag       name url_id     ldap
1    random     Random      4 tilfordc
2 randomtag random tag      3 tilfordc

# SendQuery will get a results object:
rs <- dbSendQuery(con, "SELECT * FROM tags")
# Fetch then recovers a set of rows as a DF from the query:
dbFetch(rs, n = 1)
      tag    name url_id     ldap
1 testing testing      1 tilfordc
# ClearResult closes the statement
dbClearResult(rs)

# column headers will honor AS remappings:
sql <- "SELECT tag, name AS NiceName FROM tags WHERE tag = 'bioperl'"
colMap <- dbGetQuery(con, sql)
colMap
      tag nicename
1 bioperl  BioPerl

# If you wanted to the entire table could be read:
fullTable <- dbReadTable(con, "tags")

# Close the connection
dbDisconnect(con)
```

* t looks like *some* [drivers support placeholders][SqlPlaceholders]
  using `dbGetPreparedQuery()`, but apparently not all

Utility methods:

```R
# For convienence in calls below:
myDriverObj  <- PostgreSQL() 
myDriverName <- "PostgreSQL"
# con is presumed to be a connection to your database
dbListTables(con) # Character vector of all tables in schema
dbListFields(con, "myTable") # List columns in a table
dbListConnections( myDriverObj ) # List of currently open connections
dbListResults(con) # List of pending results
dbExistsTable(con, "tableName" ) # Logical test for table
dbIsValid(con) # Logical check if the connection is still ok
dbQuoteString(con, "A'B\"C\\") # Escapes SQL characters
dbGetInfo(resultObject) # Information about a live result
dbDataType(con, "hello world") # Get the database value type for the R object
                               # eg TRUE -> "bool", 1.3 -> "float8"
# Not all drivers are fully compliant. This method will show the functions
# that may be missing or non-compliant:
dbiCheckCompliance( myDriverName )
```

##### <a name='postgres'></a>PostgreSQL #####

* Setup: `install.packages("RPostgreSQL")`
  * On Ubuntu/Debian needs: `sudo apt-get install libpq-dev`
* Usage: `library(RPostgreSQL)`

##### <a name='mysql'></a>MySQL #####

* Setup : `install.packages("dbConnect")`
  * On Ubuntu/Debian [needs][mysqlDebian]: `sudo apt-get install libmysqlclient-dev`
* Usage : `library(dbConnect)`

##### <a name='sqlite'></a>SQLite #####

[SQLite][SqliteWP] is a very cool light-weight database. It is
efficient, fast, and generally fully SQL-compliant.

* Setup : `install.packages("RSQLite")`
* Usage : `library(RSQLite)`
* [dplyr](#dplyr) includes its own support for SQLite:

  ```R
  library("dplyr")
  library("nycflights13")
  my_db <- src_sqlite("mySQLiteFile.sqlite3", create = T)
  copy_to(my_db, flights, temporary = FALSE, indexes = list(
          c("year", "month", "day"), "carrier", "tailnum"))
  ```

  * `src_sqlite(path, createFlag)` = Connect to a SQLite database
    file, creating it if needed (and allowed)
  * `copy_to(dest, myDataFrame)` = when `dest` is a SQLite object,
    will copy the provided data.frame into the DB

##### <a name='rodbc'></a>Generalized ODBC #####

[ODBC][OdbcWP] is a generalized interface to databases

* Setup: `install.packages("RODBC")`
  * On Ubuntu/Debian [needs][rodbcDebian]: `sudo apt-get install libiodbc2-dev`
* Usage: `library(RODBC)`
* Documentation: `RShowDoc("RODBC", package="RODBC")`
* Your database needs to be configured to use ODBC

# <a name='dplyr'></a>Data Transformation #

* Helper package for working with [data frames](#dataframe)
* Very fast
* For all functions:
  * The first argument is a data frame
    * To be useful the input should be properly formatted / annotated
  * Result will always be a new data frame
  * Columns can be refered to "raw", as just the name (does not need $)

### Basic "Verbs" ###

* `select(df, cols)` = Pick a subset of the columns
  * "cols" could be a wide range of column selectors. In additional to
    traditional selections (ranges, quoted names) there are:
    * `foo1:foo2` = Range from column named "foo1" to the one called "foo2"
    * `-(c(foo3, bar6))` = Excluding columns named "foo3" and "bar6"
* `filter()` = Pick a subset of the rows
  * `filter(X, foo8 > 4 | bar1 < 10)` = Returns a data frame based on
    X, mathematically filtered on the values of columns "foo8" and
    "bar1"
* `arrange()` = Re-order rows
  * `arrange(X, foo1, desc(bar2))` = Sort by "foo1" ascending, "bar2"
    descending
* `rename()` = Change column names
  * `rename(X, foo2 = Peanuts, bar7 = Weight )` = Rename "foo2" to
    "Peanuts" and "bar7" to "Weight"
* `mutate()` = Add new variables or columns, or alter existing ones
  * 
* `summarize()` = Create summary statistics

### <a name='sorting'></a>Sorting ###

* `sort( myVector, decreasing = FALSE, na.last = NA )` = sorts the
  input values, returning a *vector of values*
  * Makes use of `order()` under the hood
  * Custom sort functions can be written for objects
  * `decreasing` will sort from high-to-low when true
  * `na.last` controls how NA values behave
  * `partial` optional vector of indices to just sort part of input
* `order(vec1, vec2, ... )` = sorts on one or more vectors, returning
  a *vector of indices*
  * Shares arguments with `sort()`
  * Does not appear to support descending on some inputs and ascending
    on others.
* `arrange( myDF )` = [plyr](#plyr) function

### <a name='dplyr'></a>dplyr ###

* Setup: `install.packages("dplyr")`
  * Sample data: `library(nycflights13)`
* Usage: `library("dplyr")`
   * Sample data: `library(nycflights13)`
* Documentation: `"browseVignettes(package = "dplyr")"`

* `arrange( myDF, variable )`
  * Sorts a frame by the provided variable
  * `desc()` = wrapper for descending sort
  
# <a name='control'></a>Control Structures #

* Useful functions
  * `seq( along.with = myObject )` = same as `seq_along(myObject)` =
    get an iteration of the things in myObject.
  * `length(myObject)` = get the total size / length of myObject
  
#### <a name='ifelse'></a>if, else ####

```R
size <- if (!is.numeric(x)) {
    "Error"
} else if (x < 10) {
    "Small"
} else if (x < 100) {
    "Medium"
} else {
    "Large"
}
```
#### <a name='forloop'></a>for loops ####

* Curly braces are not needed if the interior of the loop is a single
  statement.

```R
for (i in 1:10) {
    for (j in 1:10) {
        # Do something
    }
}

dwarves <- c("Happy", "Sleepy", "Grumpy")
for (dwarf in dwarves) {
   cat("Looking for", dwarf, "\n")
}
```

#### <a name='while'></a>while loops ####

```R
i <- 0
while (i < 10) {
  i <- i + 1
  print(i)
}
```

#### <a name='nextbreak'></a>repeat, next, break, return ####

* `repeat` is basically `while( TRUE )`
* `break` will exit any of the loop structures
* `next` will continue the loop to the next iteration
* `return()` exits a function with a return value.
  * **NOTE THE PARENTHESES** - repeat, break and next can be used
    "naked", but if you try to just `return` then you'll return the
    function named "return" (if it's the last line in the function) or
    not return at all (if it's in the middle).
* `invisible( return(something) )` - invisible is used when you want
  to return a value without having it print out if it's not
  captured. That is, it's an aesthetic function to help avoid
  cluttering your terminal output.


```R
repeat {
   if (someCondition) break
   # Do stuff
}
```

## <a name='loopfunc'></a>Loop Functions ##

* `lapply(x, fun)` = Returns a list the same length as x after
  applying fun to each element of x
  * `sapply` = simplified version of lapply
    * `vapply` = similar to sapply, may be faster in some cases
    * `mapply` = multivariate version of sapply
* `apply(x, margin, fun)` = Returns vector / array / list after
  applying a function to either rows, columns or rows and columns.
* Any `...` arguments will get passed on to the supplied function
  * Important to watch for argument name collisions here!

### <a name='lapply'></a>lapply() ###

```R
x <- list(x1 = 35:42, x2 = c(4:1, 2:5))
#    Input  Function
lapply( x,    mean )
```

* **Always** returns a list of same length as the input, with values
  resulting from applying the function to each list member
* If the provided object is not a list, R will try to coerce it to one
* Looping is a C internal (fast)
* An anonymous function can be provided "in-line" in the lapply()
  call.

### <a name='sapply'></a>sapply() ###

* Designed to modify the returned value from lapply:
  * List of vectors of *uniform* length:
    * Length 1 : Return a **vector**
    * All other lengths: Return a **matrix**. This is a handy way to
      get tabular output for an analysis.
  * Otherwise, return an unaltered list

#### <a name='vapply'></a>vapply() ####

#### <a name='mapply'></a>mapply() ####

```R
# Call vector() three times:
# vector( mode = "integer", length = 2 )
# vector( mode = "logical", length = 3 )
# vector( mode = "character", length = 5 )

str(mapply( vector, mode = c("integer", "logical", "character"),
            length = c(2,3,5)))
List of 3
 $ integer  : int [1:2] 0 0
 $ logical  : logi [1:3] FALSE FALSE FALSE
 $ character: chr [1:5] "" "" "" "" ...
```

* Multivariate version of sapply, applying the function to the `...`
  arguments.
  * The argument `MoreArgs` is used to shuttle additional arguments
    into the called function.
* mapply is very useful in [vectorizing](#vectorization) a function

### <a name='apply'></a>apply() ###

```R
x <- cbind(x1 = 35:42, x2 = c(4:1, 2:5))
dimnames(x)[[1]] <- letters[1:8]
#    Input  MarginFlag  Function
apply( x,      2,         mean )
```

* Generally used with matrices, but can also work with general arrays
* 'margin' is a flag indicating what apply should, uh, apply the
  function to:
  * `1` = rows
  * `2` = columns
  * `c(1,2)` = rows and columns
  * `c(1,3)` = First and third dimensions
  * A character vector will select dimensions with those names
* The return value depends on the return value of the function:
  * fixed-length vector : apply returns an **array**, or a **vector**
    if the returned array has length 1.
  * variable-length vector : apply returns a **list**
* Formal looping is just as efficient, apply has advantage of being a
  "one-liner".
* Utility functions based on apply:
  * `rowSums(x)` &rarr; `apply(x, 1, sum)`
  * `rowMeans(x)` &rarr; `apply(x, 1, mean)`
  * `colSums(x)` &rarr; `apply(x, 2, sum)`
  * `colMeans(x)` &rarr; `apply(x, 2, mean)`
  * For some reason, these shortcuts are *much* faster than using
    apply directly.
  * The argument `na.rm` can be set to true to automatically exclude
    NA entries from the calculation. Otherwise a single NA value in an
    operation will result in a final value of NA.

### <a name='tapply'></a>tapply() ###

```R
x <- c(20,33,49,33,42,30,41,26,5,23)
y <- c('b','a','a','c','c','a','b','c','c','c')
z <- c('i','i','i','k','j','i','j','k','k','k')
#      Input    Factors       Function
tapply(  x,   list(y=y,z=z),    mean)

   z
y          i  j     k
  a 37.33333 NA    NA
  b 20.00000 41    NA
  c       NA 42 21.75
```

* Applies a function over a subset of a vector. The subsets are
  defined by one or more vectors, each the same length as the data.
  * Uses `split` (below) to break up the data. `tapply(x, f, mean)`
    &equiv; `lapply(split(x,f), mean)`

#### <a name='split'></a>split() ####

```R
myData <- c(20,33,49,33,42,30,41,26,5,23)
myFactors <- c('b','a','a','c','c','a','b','c','c','c')
split(myData,myFactors)

$a
[1] 33 49 30

$b
[1] 20 41

$c
[1] 33 42 26  5 23
```

* `split()` is the function used by `tapply` to combine a vector of
  data with a factor vector and produce a list of the data,
  partitioned by factors.
* Factors can be a single vector, or a list of vectors.
  * Argument `drop` (default FALSE) will cause any unrepresented
    factor levels to be excluded.

### <a name='mapply'></a>mapply() ###

## <a name='plyr'></a>plyr ###

* `library(plyr)`
* Formal combination of "split-apply-combine". Functions are of format
  `<in><out>ply`, where "<in>" and "<out>" are one of:
  * `a` = array
  * `l` = list
  * `d` = data.frame
  * `m` = multiple inputs
  * `r` = repeat multiple times
  * `_` = nothing

# <a name='functions'></a>Functions #

* R will fail if you access a function with fewer arguments than it
  was defined with, unless the missing arguments have a default set:
  `argument "arg1" is missing, with no default`
* It will always fail if you pass more arguments than expected,
  or use argument names that are not explicitly specified in the
  function (`unused argument`).
* `class(myFunc)` will return "function"
* Arguments to functions have both a position in the argument list
  (first parameter, second parameter, etc) and a name (`length = 5`).
  * Named parameters can be passed in any position in the function call.
  * If an un-named parameter is encountered, R will slot that into the
    first "unclaimed" argument. So for example in `matrix()`, "nrow"
    can be passed as the second argument and "ncol" as the third:
    
    ```R
    # From the documentation:
    # matrix(data = NA, nrow = 1, ncol = 1, byrow = FALSE,
    #        dimnames = NULL)
    > x <- matrix(ncol = 3, 1:6, nrow = 2 )
    > y <- matrix(1:6, 2, 3)
    > identical(x,y)
    [1] TRUE
    ```
    
  * This is crazy goofy and looks prone to all kinds of hard-to-catch
    bugs. Probably best to not mess with the order and used named
    arguments as much as possible.
    * Arguments also use partial name matching. Inside a function call
      this is probably not as dangerous as in a data frame, but
      likewise if the function changes over time a unique partial
      argument name might become non-unique later.
  * <a name='dotdotdot'></a>`...` is used to pass arbitrary,
    unspecified arguments onwards to sub-functions. That is,
    specifying `...` in a function definition then allows use of `...`
    again internally to pass on the "extra" arguments to internal
    function calls:
    
    ```R
    myFuncTwo <- function( a = NULL, b = 2, ... ) {
        myFunc( a, b, c = 4, ... )
    }
    ```

    * `...` is also used in "generic functions" for argument dispatch.
    * `...` is used when the number of arguments in a call can not be
      predicted, like in `paste()` or `cat()`, where 1-or-more
      arguments are concatenated together.
      * In these situation any "other" arguments *must* be named when
        calling the function (otherwise they will be gathered into the
        "general" arguments specified by the initial `...`).
* R calls the defined argument list **formals**
  * The arguments specified for a function can be found with the
    `formals()` function, which returns a "dotted pair" list of
    key/values.
  
    ```R
    formals(fun = vector)
    $mode
    [1] "logical"
    
    $length
    [1] 0
    ```


```R
myFunc <- function( arg1, arg2 = optionalDefaultValue) {
   # Stuff happens
   returnValue # Last operation gets returned
}
myFunc <- function( arg1, arg2 = 2) {
    arg1 + arg2
}
```


### <a name='scoping'></a>Symbol Scoping ###

* ... is quite weird
* Scott recommends: [How R Searches and Finds Stuff][RScopeSearching]
* All objects in R reside in an **environment** (which is also an
  object). Each environment has two<sup>&dagger;</sup> things:
  1. A **frame**, which is a structure holding all the environment's
     objects
  2. The **owner** (parent) environment. <sup>&dagger;</sup>*The "Empty
     Environment" is the ultimate top-level environment, it does not
     have an owner.*
* Environments can be manually created with `new.env()`
* The owner can be found or changed with `parent.env( envObject )`
* Your current environment is returned with `environment()`
* `ls()` reports objects held by the current environment. You can use
  `ls( name = envID )` to find objects in an arbitrary
  environment. The name argument is flexible and can use an
  environment object, name or search position.
* `rm()` removes objects from an environment
  * Ron recommends that scripts begin with `rm(list=ls())`. This will
    clear all variables held by the current environment and assure
    that you're starting with a clean slate.
* The `assign()` function allows an object to be created in a
  particular environment. Conversely, `get()` recovers objects, and
  allows an environment to be specified.
* There are some special environments:
  * **.GlobalEnv*, which can be accessed with either `.GlobalEnv` (no
    quotes) or `globalenv()`
  * **R_EmptyEnv**, the top-level empty environment, accessed via
    `emptyenv()`
  * **base**, accessed via `baseenv()`
* A package in R is associated with 3 environments. These are formally
  represented with '<environment>:<package>', eg `namespace:stats`
  1. The **package: environment** holds the "exported" objects you
     presumably want from the package; Functions, constants, data,
     etc.
  2. The **namespace: environment** has the same (sort-of kind-of)
     objects from the package environment, plus (optionally?) hidden
     "support" objects
  3. The **imports: environment** holds package dependencies; Other
     packages that this package is going to need to be loaded as well.
    * On CRAN, direct dependencies are shown under "Imports", while
      indirect dependencies appear under "Depends". Apparently this
      distinction can be consequential.
    * The imports environments are enclosed by the namespace:base
      environment.
* *For the love of all that's holy this is confusingly complex*
* A function "resides" in an environment, and runs in one. By
  default these are the same, but the running environment can be
  changed with the function's environment property.
* Scoping and environments are important to R in order to facilitate
  the location of named objects. Once R has an object in hand, it no
  longer really cares what environment is associated with it. So
  getting an environment from a (non-function) object is hard.
* [Graphical view of search pattern][RScopeMap]. As far as I can tell,
  the search is:
  1. Try local environment
  2. Recursively try enclosing environments. For package functions in
     a package called myPackage, this would generally
     be:
    1. `namespace:myPackage`
    2. `imports:myPackage`
    3. `namespace:dependencyPackage` / `imports:dependencyPackage`
       recursion for any packages that myPackage has specified as an
       Imports dependency.
  4. `namespace:base` if not found in package or Imports
  5. `R_GlobalEnv`
  6. `namespace:dependencyPackage` / `imports:dependencyPackage`
     recursion for any packages that myPackage has specified as an
     Depends dependency.
* An object can be explicitly defined with `::`, eg `myPackage::myFunc`
  * <a name='internalscope'></a> `::` works for exported objects;
    Three colons can by used for internal objects, eg
    `myPackage:::someThing`
* Lexical scoping works allows construction of closures. In the
  example below, "make.dice" returns a function that "remembers" the
  caller parameter:

  ```R
  make.dice <- function (sides) {
      dice <- function( rolls ) {
          # runif() is the uniform distribution = "random number"
          # My attempt at generating random numbers:
          # floor(sides * runif(1:rolls)) + 1
          # Scott's suggestion for a more R-ish way:
          sample.int(n = sides, size = rolls, replace = TRUE)
      }
      dice # Return the closure
  }
  sixSided <- make.dice(6)
  sixSided(5)
  [1] 1 3 6 3 2
  ```

  * Closures are useful for operations that take parameterized
    functions as input. For example, `optimize()` finds the minimum or
    maximum of a function within a range. A closure allows some
    parameters to be fixed while varying only the arguments being
    "scanned" by optimize.
  * Scott recommends limiting usage of closures to where they're
    really needed, because they make following code flow more
    difficult.
* The scoping paradigm is apparently why R objects must all be kept in
  memory, as opposed to cached to disk.
* `<<-` is a special gets method that will assign a variable "above"
  the current environment:
  1. If the assignment is occuring in a function's environment, R will
     first "look up" into the function's environment (and recursively
     through any nested parents) to try to find the variable. As soon
     as it locates the variable, it assigns the value within that
     environment.
  2. If R fails to find the variable in any of the nested function
     environments (or if the assignment occurs outside a function)
     then assignment will occur at the global environment, whether the
     symbol exists there or not.
    

Great scoping example from [O Beautiful Code][RScopeSearching]:
```R
age <- 32 
MyFunction <- function() {
   age <- 22 
   FromLocal <- function() { print(paste("Local", age + 1 )) } 
   FromGlobal <- function() { print(paste("Global", age + 1 )) } 
   NoSearch <-  function() { age <- 11; print(paste("NoSearch", age + 1 )) } 
   environment( FromGlobal ) <- .GlobalEnv 
   FromLocal() 
   FromGlobal() 
   NoSearch() 
} 
MyFunction() 
[1] "Local 23"
[1] "Global 33"
[1] "NoSearch 12"
```

This is a good example from a quiz:
```R
f <- function(x) {
  g <- function(y) {
    y + z
  }
  z <- 4
  x + g(x)
}
z <- 10
f(3)
```
Compare to Perl:
```Perl
use strict;
my $z = 10;

# Prints 16:
print &f(3);

sub f {
    my $x = shift;
    my $g = sub {
        my $y = shift;
        # This closure has not encountered the local $z below
        # So the closure "holds on to" the global value of $z defined above
        return $y + $z;
    };
    
    # This $z is not going to be used!
    my $z = 4;
    return $x + &{$g}($x);
}
```

The difference here is that **R is not using references**. It is
parsing everything by name. So when `g()` is evaluated inside `f()`,
and it encounters an expression using `z`, it will start following the
environment search pattern to find the "nearest" instance of z, which
it quickly finds inside function f's environment.

# <a name='packages'></a>Packages #

* `a <- available.packages()` = puts list of all packages in `a`
* `head(rownames(a), 3)`
* `install.packages("<PACKAGE_NAME_HERE>")` = install the package from CRAN
 * First install asks you to specify a local mirror
 * Can pass a list of package names as well
 * RStudio : Menu option Tools > Install Packages
 * Code to install only as needed:
   * `require(myPackage) || install.packages("myPackage")`
* `source("http://bioconductor.org/biocLite.R")` = loads a remote
  script for installing the Bioconductor packages
  * `biocLite()` = Installs **ALL** of Bioconductor
  * `biocLite(c("<PACKAGE_1>","<PACKAGE_2>",...))` = Installs just a
    subset of packages
  * AFAICT this is not a general loading mechanism but is rather a
    specific helper script for managing large-scale package
    installations. Probably common to other resources as well.
* `library(ggplot2)` = load the ggplot2 package into your current R session
  * `install()` downloads code to your local machine. Needs to be
    done once (per machine)
  * `library()` makes it available for your current session /
    script. Will automatically **load** dependencies, but I don't
    think it will automatically **install** them. Needs to be done
    every session. Should not use quotes.
* Rtools is needed for building packages in Windows.
  * Also want to `install.packages("devtools")` after downloading
* `search()` lists the currently installed namespaces, and the
  precedence order for when a symbol exists in two or more namespaces.
  * `library` by default will insert packages at position [2] (highest
    level excepting `.GlobalEnv`), bumping down all other packages.

# <a name='oop'></a>Object Oriented Programming #

R had OOP "cobbled on" late in its history. It actually has been added
*twice*; When you see references to "S3" or "S4", they are referring
to OOP paradigms from versions 3 / 4 of the [S language][S], which are
quite different. You may use both simultaneously, but it is highly
disadvised.

## <a name='s3'></a>S3 OOP ##

* S3 is based on the [1988 version of S][sHistory]
  * You get it "for free", no need to load additional libraries
  * CONS: Kludgy, weird implementation. Aspects of the syntax are
    oddly defined and may be difficult to predict behavior.
  * PROS: Simple but still powerful. Scott says it is much harder to
    maintain code when using the S4 paradigm; Changes tend to require
    propogation across all dependent scripts and libraries, whereas
    changes in S3 are less likely to break reliant code.
* The `.` character has a special role in S3 - It defines
  class-specific dispatch methods (see below)

#### <a name='s3classes'></a>Importance of Classes in S3 ####

Classes play a central role in S3. They are used for "method
dispatch", where a function can call different code depending on the
class(es) of the passed argument.
    
* `UseMethod( "baseMethodName" )` = Generally (always?) used inside a
  "stub" to set up a method as being S3 dispatched:
  
  ```R
  twiddle <- function( x ) {
      UseMethod( "twiddle" )
      # If x's first class is 'foo', then R will look for a function
      # called "twiddle.foo"
      # If a function can not be found, R will look for "twiddle.default"
      # If it can't find either you get an error:
      # no applicable method for 'twiddle' applied to an object of class ...
  }
  ```
  
  * Note that the "inherent" classes of an object can have methods,
    too. So you could make a method "twiddle.logical" or
    "twiddle.double".
* `NextMethod()` = Dispatches functions on the next class (if any)
  held by the object.
  * Should be called from inside the function *that was called by* the
    previous UseMethod/NextMethod block.
  * Keep in mind that return values from NextMethod will end up
    "trapped" inside the previous calling function unless you do
    something with them. NextMethod would presumably be most useful
    for configuring aspects of the analysis done by the "primary"
    class' function.
* `analyze.info.detail` = This function could be dispatched by either
  `analyze.info()` on a "detail" object, or by `analyze()` on an
  "info.detail" object.

Scott indicates that the use of NextMethod below is highly unusual. I
do not think I am comprehending it properly.

```R
speak <- function( ... ) {
    # This is the "dispatcher" function. It will look for a function named
    # "speak.<firstClassName>" or "speak.default"
    UseMethod( "speak" )
}
saySomething <- function (animal, what) {
    sprintf("%s says %s", animal, what)
}
speak.cow <- function(animal, vehemently = FALSE, alert = FALSE, ... ) {
    # speak() method for class "cow"
    # First see if there are any other classes to deal with:
    NextMethod( )
    what <- if (vehemently) {
        if (alert) {
            # Vehemently alert!
            "I said MOO WHO?!?!"
        } else {
            "MOOOO!!!"
        }
    } else if (alert) {
        "Moo who?"
    } else {
        "Moo"
    }
    saySomething( animal, what );
}
speak.dog <- function(animal, alert = FALSE, ...) {
    # speak() method for class "dog"
    # First see if there are any other classes to deal with:
    NextMethod( )
    what <- if (alert) {
        "BARK BARK BARK!!!"
    } else {
        "Woof"
    }
    saySomething( animal, what );
}
speak.singer <- function(animal, ...) {
    # This method is designed to be called as a secondary (NextMethod)
    # function to the primary class. It is called before the primary
    # class' dispatched function returns. If we return a value here,
    # it will be quietly "absorbed" inside the primary block, and we
    # will never see it. So we print the value to STDOUT here so the
    # cow can sing.
    print(sprintf("%s sings La la la laaaaa!", animal))
    return()
}
speak.default <- function(animal, ...) {
    # Stay silent. This is needed to catch NextMethod calls when the
    # class stack has no more classes available.  To avoid having NULL
    # returned and cluttering up our output, we explicitly return
    # https://stackoverflow.com/a/25719114
    return()
}

# Make some animals:

pet <- "Fido"
class(pet) <- "dog"
# Dogs behavior not affected by vehement, so the flag is quietly ignored
speak(pet, vehemently = TRUE)
[1] "Fido says Woof"

bovine <- "Bessie"
class(bovine) <- c("cow","singer")
# Cows can be both alert and vehement
# This cow is also a singer
speak(bovine, alert = TRUE)
[1] "Bessie sings La la la laaaaa!"
[1] "Bessie says Moo who?"
```

* Scott recommends testing auto-dispatched methods with a direct call
  to them (`speak.singer("Oscar")`) to verify that they're behaving as
  anticipated.

## <a name='s4'></a>S4 OOP ##

* [StackExchange S4 Useful Links][SeUsefulLinks]
* S4 is recommended when
  [developing with Bioconductor pacakages][s4bioconductor].
* My [Bioconductor notes](./bioconductorNotes.md)
* [Useful S4 / slots description][SeS4slots]
* `typeof( someS4object )` &rarr; `S4`

### <a name='s4setclass'></a>setClass ###

* `setClass(className, representation)` is used to define an S4 class.

   ```R
   setClass("dog", representation = representation(
             color = "character",
             age   = "integer",
             friendly = "logical"
             ))
   ```
   
 * Arguments:
   * `representation` = Defines the **slots** that the objects will
     have. A slot is a named container that can hold arbitrarily
     complex data, including other S3/S4 objects. If a "foo" object
     has a "bar" slot, it will have one and only one value for bar,
     but that value can be anything *(except perhaps another foo
     object?)*
   * `contains` = optional, defines superclasses of this class. Used
     to extend existing objects, or to inherit functionality from
     them. Can be "VIRTUAL".
   * `prototype` = optional default values for the object
   * `validity` = optional sanity-checking method
   * `where` = optional specification of the environment
   * `sealed` = if TRUE, prevents the class from being redefined by
     subsequent setClass calls.

### <a name='s4new'></a>new ###

### <a name='s4rle'></a>Rle ###

* "Run-length encoding"
* Compact mechanism to represent a vector with repetition.
  * "Runs" of values are collapsed into the "values" property, with
    the length of each run stored in a separate "lengths" property
* Construction
  * Directly with `Rle( someVector )`
  * Explicitly with `Rle( values = valueVector, lengths = lenVector)`
  * Coerced via `as( compatibleObject, "Rle")`
* Conversion
  * `as.vector( myRle )`
  * `as.factor( myRle )`
* `getOption("dropRle")` = default false. For some operations using
  Rles, affects if you get an Rle back (FALSE) or a vector (TRUE).

```R
myVec <- c('c','a','a','a','a','b','b','c','b','b')
myRle <- Rle( myVec );
myRle

character-Rle of length 10 with 5 runs
  Lengths:   1   4   2   1   2
  Values : "c" "a" "b" "c" "b"
# That is: 1 c, 4 a, 2 b, 1 c, 2 b

as.factor(myRle)
 [1] c a a a a b b c b b
Levels: a b c

identical(as.vector(myRle), myVec)
[1] TRUE

# Can also build with a list of values and repeat lengths:
anRle <- Rle( values = c("c","a","b","c","b"), lengths = c(1,4,2,1,2))
identical(anRle, myRle)
[1] TRUE
```

# <a name='rdeveloping'></a>Developing in R #

* Some coding style suggestions
  * [Google R Style Guide][GoogleStyle]
  * [R Coding Conventions][RCC]

### <a name='errors'></a>Errors and Error Handling ###

* Four levels of error:
  * `message` = informational
    * `suppressMessages( boolean )` = If true, turn off messages
  * `warning` = Possible problem, no impact on code flow
    * `suppressWarnings( boolean )` = turn of warnings if true
  * `error` = Fatal problem, code halts (via `stop`)
  * `condition` = Programmer-defined event
* Funtions that throw errors. The first arguments in the calls will be
  coerced into strings then joined together to make the message.
  * `message()` = print a message.
  * `warning()` = throw a warning.
  * `stop()` = throw an error.
    * `stopifnot( cond1, cond2, ... )` = conditional stop, will halt
      unless all passed arguments are true. If a stop is triggered,
      the first condition that caused it is reported.

### <a name='debugging'></a>Debugging ###

* `traceback()` = Prints the call stack of the last uncaught error
  * Errors within `try` and `tryCatch` are not considered
* `debug( aFunction )` = Flag a function for step-wise debugging
  * `undebug( aFunction )` to turn off
* `browser()` = Break out of execution and allow inspection of the
  environment. Generally included within code that's being
  developed. Special commands when in browser mode:
  * `help` = show browser commands
  * `c` aka `cont` = return to execution
  * `f` = finish execution of current loop or function
  * `n` = next statement, stepping over functions
  * `s` = next statement, stepping into functions
  * `where` = stack trace at current point
  * `Q` = exit browser *and* evaluation
* `trace` = Inject debugging code into any function
  * Arguments define what the code is, and where it should go
  * `tracingState()` = turns tracing on and off
* `recover()` = Can change error behavior so a browser is invoked
  rather than throwing a message.
  * Set `options(error = recover)` to automatically drop into recover
    mode when an error is thrown. You will be presented with a stack
    trace and can choose the frame you wish to inspect.

### <a name='profiling'></a>Profiling ###

* `system.time( arbitraryExpression )` = calculates the number of
  seconds for arbitraryExpression to evaluate
  * Useful when you want to time a specific block of code
  * Returns an object of class `proc_time`
  * Holds `system` (CPU), `user` and `elapsed` components.
  * System and user times are broken into "self" and "child" components
* `Rprof( profileFile )` = Deep profiling mode
  * R must have been *compiled* with profiling support
  * Do **not** mix system.time with Rprof
  * Works by sampling the call stack
    * Default sampling frequency is 20 msec
    * Fast-running code will need shorter inteval (or may not benefit
      from profiling in the first place)
  * Raw output is not really useful, needs to be fed to `summaryRprof()`
    * Data can be normalized `by.total` or `by.self`
  * Will not profile C or Fortran code

```R
Rprof( filename = "myBenchmarks.txt" )
slowCode()
moreCode()
Rprof( NULL ) # Turns off profiling
dontCareCode()
# Turn profiling on again, append to previous file:
Rprof("myBenchmarks.txt", append = TRUE)
otherSlowCode()
# It looks like you need to turn it off to write final data to file?
Rprof(NULL)
# Show all details:
summaryRprof("myBenchmarks.txt")
# Or just the "self" level:
summaryRprof("myBenchmarks.txt")$by.self

```

* `install.packages("microbenchmark")` = Provides sub-millisecond
  precision for timing.
  * `library(microbenchmark)`; `microbenchmark( someExpression )`
  * Note that the `unit` argument is set to dynamically adjust for the
    actual benchmarks. To fix it, set `unit = "us"` (or some other
    unit).

### <a name='dataobject'></a>Programmer-like Objects ###

That is, structuring complex objects as one might in other
langauages. Scott recommends using lists, but warns that it becomes
unweildy for large amounts of data.

```R
fido <- list( name = "Fido", toys = c("ball", "stick"), color = "brown")
butch <- list( name = "Butch", food = c("cats", "small children"), friendly = F)
# Yeesh - fido = fido.
kennel <- list( dogs = list(fido = fido, butch = butch), clean = TRUE)
kennel
$dogs
$dogs$fido
$dogs$fido$name
[1] "Fido"

$dogs$fido$toys
[1] "ball"  "stick"

$dogs$fido$color
[1] "brown"

$dogs$butch
$dogs$butch$name
[1] "Butch"

$dogs$butch$food
[1] "cats"           "small children"

$dogs$butch$friendly
[1] FALSE

$clean
[1] TRUE

# If I passed the kennel's dogs as an un-named list:
kennel <- list( dogs = list(fido, butch), clean = TRUE)

# ... then I'd need to use array subsetting rather than names to
# get information on its $dogs:

kennel$dogs[[1]]$toys
[1] "ball"  "stick"
```

# <a name='texthandling'></a>Text Handling #

* `print()` = Basic STDOUT, includes newline
  * Objects can define an internal print method, which will be invoked here
    * Objects can also have a `toString()` method - I'm not sure if
      that's how print gets implemented, or if it is different
  * Assured output to terminal; Other methods are manipulation
    methods, that will output in an interactive session but only if
    not captured by another object.
* `cat()` = concatenates character data into a single string
  * Does not automatically include newlines, must terminate with "\n"
    if desired
* `format()` = fine-grained control over object representation.
  * Significant digits, scientific notation, date/time
* `sprintf()` = Exposed C function.
  * Will implicitly loop! If multiple vectors are provided to multiple
    bind locations, then they **must** be of the same modulus or
    sprintf will fail to execute.

  ```R
  > sprintf("%s %d", "test", 1:3)
  [1] "test 1" "test 2" "test 3"
  ```

* `prettyNum()` = Fairly extensive numeric formatting options

# <a name='probability'></a>Probability #

## <a name='distributions'></a>Distributions ##

* Nearly all distributions have four functions associated them, keyed
  by the first letter of the function name: `d`, `p`, `q` and `r`. For
  example, the Uniform Distribution has four functions:
  * `dunif()` = The [probability density function][WpDensityFunc], "the
    relative likelihood for this random variable to take on a given
    value"
    * The first argument, `x`, is a vector of quantiles
  * `punif()` = The
    [cumulative distribution function][WpCumulativeFunc], "the
    probability that a real-valued random variable X with a given
    probability distribution will be found to have a value less than
    or equal to x"
    * The first argument, `q`, is a vector of quantiles
  * `qunif()` = The [quantile function][WpQuantileFunc], "the value at
    which the probability of the random variable being less than or
    equal to this value is equal to the given probability"
    * The first argument, `p`, is a vector of probabilities
  * `runif()` = A function generating random values selected from the
    distribution
    * The first argument, `n`, is the number of observations

#### Specific Distributions ####

* `<*>` = one of d/p/q/r
* Logical flag `log` (for `d...`) and `log.p` (for `p...` or `q...`)
  will report logarithms of probabilities when true. Default is
  (always?) FALSE.
* Logical flag `lower.tail` will report probabilites for `P[X <= x]`
  when TRUE (default), while FALSE reports `P[X > x]`

* `<*>unif()` = The [uniform distribution][WpUniformDist]
  * All functions have `min` and `max` arguments
* `<*>norm()` = The [normal distribution][WpNormalDist]
  * All functions have `mean` and `sd` arguments
* `<*>pois()` = The [Poisson distribution][WpPoissonDist]
  * All functions have the `lambda` argument
* `<*>bionom()` = The [binomial distribution][WpBinomialDist]
  * All functions have the `size` and `prob` arguments
* `<*>gamma()` = The [gamma distribution][WpGammalDist]
  * All functions have the `shape`, `rate` and `scale` arguments
* `<*>exp()` = The [exponential distribution][WpExponentialDist]
  * All functions have the `rate` argument

## <a name='rng'></a>Random Number Generator ##

Random numbers in R are not meant to be cryptographic, but rather to
fall as randomly as practical along a specified distribution. Multiple
[pseudo random number generator][WpPRNG] (PRNG) algorithms can be
chosen.

* `set.seed( mySeed )` = Sets the RNG seed. mySeed is an integer. The
  seed will "auto advance" as the code executes.
  * If you know your code has a random component (or suspect it might)
    it is a good idea
* `RNGkind(kind = rngType)` = Choose alternate PRNG algorithms. The
  default is [Mersenne-Twister][WpMersenneTwister], which has an
  insanely large period.
* `sample( x )` picks random values from x
  * The second argument `size` specifies the number of values to
    select. If left out, will equal the length of x. If only x is
    provided, then the returned value will be a random permutation of
    x.
  * When argument `replace` is FALSE (default) then the sample is
    chosen without replacement (each value in x can only be chosen
    once), otherwise replacement is used.

## <a name='lecture89'></a>Random Linear Model ##

*This code is just transcribed from [lecture 89](https://class.coursera.org/rprog-033/lecture/89)*

Working with model:

*y = &beta;<sub>0</sub> + &beta;<sub>1</sub>x + &epsilon;*

```R
set.seed(20)
# x is a numeric vector generated from the normal distribution:
x <- rnorm(n = 100)
e <- rnorm(n = 100, mean = 0, sd = 2)
# y will also be a 100-element numeric vector:
y <- 0.5 + 2 * x + e
summary(y)
plot(x,y)
```

X is binary:

```R
set.seed(10)
x <- rbinom( n = 100, size = 1, prob = 0.5 )
e <- rnorm(n = 100, mean = 0, sd = 2)
y <- 0.5 + 2 * x + e
summary(y)
plot(x,y)
```

Simulate from Poisson:

Y ~ Poisson(&mu;)

log&mu; = *&beta;<sub>0</sub> + &beta;<sub>1</sub>x*

```R
set.seed(1)
x <- rnorm(n = 100)
logMu <- 0.5 + 0.3 * x
y <- rpois( n = 100, lambda = exp(logMu) )
summary(y)
plot(x,y)
```

# <a name='randomstuff'></a>Random Things #

* `R.Version()` = show the software version information for current
  R session
* There have been requests for
  [emacs keybindings in RStudio][RstudioEmacs] but they are no plans
  to implement it.
* `vignette(all = FALSE)` = Get a list of all vignettes in attached
  packages.
  * `vignette(all = TRUE)` = List **ALL** vignettes

### <a name='makeexamp'></a>Generating Examples ###

```R
# Ten random letters a-c
sprintf("x <- c('%s')", paste(letters[runif(10, min = 1, max = 4)],
                              collapse = "','"))
# Ten random integers 1-100
sprintf("x <- c(%s)", paste(as.integer(runif(10, min = 1, max = 101)),
                             collapse = ","))
```

## <a name='rinternals'></a>Internal R Stuff ##

* `match.fun( functionRequest )` = Helper method that pulls out a
  function based on polymorphic input. functionRequest can be a
  function, a symbol, or string, and R will try to locate and return
  the most appropriate function matching the request. This function is
  utilized by many other methods that take functions as input (eg
  `apply`)
* `as.environment()` = Used both to coerce and as a helper function
  when an argument requires an environment. Can take an environment
  object (returns it), a positive integer (takes from search() list),
  a character string (match by name) or -1 (calling environment).

## <a name='serialization'></a>Serialization ##

* `match.call()`
  * Returns a 'language' object
* `parse()` can be used to process a character string to an R
  'expression'. That expression can then be fed to `eval`, which
  will then execute the code represented by the initial text. So
  `eval( parse( text = "some R code" ) )` is the same as eval("some
  R code") in many other languages:
  
  ```R
  > myExp <- parse(text = "z <- 3")
  > myExp
  expression(z <- 3)
  > eval(myExp)
  > z
  [1] 3
  ```

* See also the [Data Import](#import) section above.

## <a name='wisdom'></a>Scott Wisdom ##

* <a name='masking'></a>Ariella pointed out that identically-named
  functions from one library will "overwrite" each other (the most
  recently loaded package wins).
  * R calls this "masking" and you can identify such situations with
    `conflicts()` to show the function names and `find()` to show the
    packages the function resides in. If it's a "gets" method, you may
    need to use `help()` explicitly (rather than `?`) to call up
    documentation.

    ```R
    > conflicts()
    [1] "body<-"    "kronecker"
    > find("body<-")
    [1] "package:methods" "package:base"
    > help("body<-", package = "methods")
    No documentation for ‘body<-’ in specified packages and libraries:
    you could try ‘??body<-’
    ```

  * Scott notes that the functions are not "overwritten"; All
    same-named functions still exist within the R session, and can all
    be accessed as long as you specify the package you want a particular from:

    ```R
    somePackage::someFunction( color = "lizzard" )
    get("someFunction", pos = "somePackage")( color = "lizzard" )
    ```

## <a name='weird'></a>Weird Things ##

#### <a name='aliases'></a>Aliases, Aliases, Aliases ####

R seems very fond of aliases. These are commands or variables that
have different names but do the same thing. It also "figures out what
you really want" in some cases. Here are the examples I've been able to
find:

* Mode `double` is the same as mode `numeric`
* `isTRUE(x)` is an abbreviation of `identical(TRUE, x)`
* When a function is on the left side, it's called the "replacement
  form", and even though you'd write it as `foo()`, it's really
  `"foo<-"()`:
  
  ```R
  y <- "Red"
  x <- "Blue"
  attr(y, "name") <- "Rachel"
  x <- "attr<-"(x, "name", "Barry")
  
  x
  [1] "Blue"
  attr(,"name")
  [1] "Barry"
   y
  [1] "Red"
  attr(,"name")
  [1] "Rachel"
  ```

#### <a name='dataclassweird'></a>data.class() vs class() ####

R documentation: *For compatibility reasons ...  When ‘x’ is ‘integer’,
the result of ‘data.class(x)’ is ‘"numeric"’ even when ‘x’ is
classed.*
     
```R
> x <- vector('integer', length = 10)
> inherits(x, what = 'integer')
[1] TRUE
> inherits(x, what = 'numeric')
[1] FALSE
> data.class(x)
[1] "numeric"
> class(x)
[1] "integer"
```

#### <a name='markdown'></a>Markdown Notes ####

Not R *per se*, but these have been useful in making this document...
* [Daring Fireball][daringfireball] - Original Markdown specification
* [Internal document anchors][NamedAnchors] - `<a
  name='anchorname'></a>` - You must use single quotes!
* [GitHub Markdown][githubmd] - Note that the "extra" features may not
  port to tools like knittr
  * Within code blocks you can use `` ```R `` to specify R
    [syntax highlighting][githubsyntax]. Unfortunately this
    [does not work](https://stackoverflow.com/a/25058886) with inline
    code blocks.
    * [Code blocks in lists][CodeBlockInList] are quite finicky.
      * The leading and trailing backticks need to be at the same
        indent as the list item content. If you don't do this, leading
        whitespace will be removed from each line.
      * Also, it seems like you need a newline before the first set of
        backticks, otherwise the code gets shoveled into an inline
        block. If you have newlines, they *must* be indented to the
        list, too!
        * If the indententing on a code-block-in-a-list is messed up,
          it will mess up list nesting at weird points later in the
          document. If you find
  * [HTML sanitization][GitHubSanitization] - You can use raw HTML
    tags, but GitHub will strip out many of the attributes for
    security. The link shows the WHITELIST structure used. Both
    attributes and tags are excluded. For example, a `style` attribute
    is not allowed, but `color` is. `span` tags are not allowed, but
    `b` is.
    * It is apparently
      [impossible to colorize text](https://stackoverflow.com/q/23904274)

[BigNumbersInR]: https://stackoverflow.com/questions/2053397/long-bigint-decimal-equivalent-datatype-in-r
[CranImportExport]: https://cran.r-project.org/doc/manuals/R-data.html
[NamedAnchors]: https://stackoverflow.com/questions/6695439/how-do-you-create-link-to-a-named-anchor-in-multimarkdown
[SObignumbers]: https://stackoverflow.com/questions/17724382/display-exact-value-of-a-variable-in-r
[WickhamDataStructures]: http://adv-r.had.co.nz/Data-structures.html
[daringfireball]: https://daringfireball.net/projects/markdown/syntax
[githubmd]: https://help.github.com/articles/github-flavored-markdown/
[githubsyntax]: https://help.github.com/articles/github-flavored-markdown/#syntax-highlighting
[CodeBlockInList]: https://stackoverflow.com/questions/6235995/markdown-github-syntax-highlighting-of-code-block-as-a-child-of-a-list
[GitHubSanitization]: https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/sanitization_filter.rb
[RScopeSearching]: http://blog.obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff/
[RScopeMap]: http://blog.obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff/#map-of-the-world-follow-the-purple-line-road
[RstudioEmacs]: https://support.rstudio.com/hc/communities/public/questions/200757977-Emacs-key-bindings-again-
[ESS]: http://ess.r-project.org/
[Rinferno]: http://www.burns-stat.com/pages/Tutor/R_inferno.pdf
[AdvancedR]: http://adv-r.had.co.nz/
[s4bioconductor]: https://stackoverflow.com/questions/3602154/when-does-it-pay-off-to-use-s4-methods-in-r-programming
[S]: https://en.wikipedia.org/wiki/S_%28programming_language%29
[sHistory]: http://ect.bell-labs.com/sl/S/history.html
[GoogleStyle]: http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml\
[RCC]: http://www.aroma-project.org/developers/RCC
[SeS4slots]: https://stackoverflow.com/a/4714080
[SeUsefulLinks]: https://stackoverflow.com/questions/4143611/sources-on-s4-objects-methods-and-programming-in-r
[WpDensityFunc]: https://en.wikipedia.org/wiki/Probability_density_function
[WpCumulativeFunc]: https://en.wikipedia.org/wiki/Cumulative_distribution_function
[WpQuantileFunc]: https://en.wikipedia.org/wiki/Quantile_function
[WpUniformDist]: https://en.wikipedia.org/wiki/Uniform_distribution_%28continuous%29
[WpNormalDist]: https://en.wikipedia.org/wiki/Normal_distribution
[WpPoissonDist]: https://en.wikipedia.org/wiki/Poisson_distribution
[WpBinomialDist]: https://en.wikipedia.org/wiki/Binomial_distribution
[WpGammalDist]: https://en.wikipedia.org/wiki/Gamma_function
[WpExponentialDist]: https://en.wikipedia.org/wiki/Exponential_function
[WpMersenneTwister]: https://en.wikipedia.org/wiki/Mersenne_Twister
[WpPRNG]: https://en.wikipedia.org/wiki/Pseudorandom_number_generator
[ReadCsvForcedChar]: https://stackoverflow.com/questions/6616020/problem-with-specifying-colclasses-in-read-csv-in-r/6616047#6616047
[xmlInR]: http://www.stat.berkeley.edu/%7Estatcur/Workshop2/Presentations/XML.pdf
[jsonlite]: http://www.r-bloggers.com/new-package-jsonlite-a-smarter-json-encoderdecoder/
[datatable]: https://www.datacamp.com/courses/data-analysis-the-data-table-way
[datatablegithub]: https://github.com/Rdatatable/data.table
[dfVSdt]: https://stackoverflow.com/questions/13618488/what-you-can-do-with-data-frame-that-you-cant-in-data-table
[advmanip]: https://github.com/raphg/Biostat-578/blob/master/Advanced_data_manipulation.Rmd
[rodbcDebian]: https://superuser.com/questions/283272/problem-with-rodbc-installation-in-ubuntu
[mysqlDebian]: https://superuser.com/questions/283272/problem-with-rodbc-installation-in-ubuntu
[OdbcWP]: https://en.wikipedia.org/wiki/Open_Database_Connectivity
[SqliteWP]: https://en.wikipedia.org/wiki/SQLite
[SqlPlaceholders]: https://stackoverflow.com/questions/2186015/bind-variables-in-r-dbi
