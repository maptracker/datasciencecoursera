
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
  * [Data Import](#import)
  * [Data Export](#export)
  * [Connections](#connections)
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
* [Functions](#functions)
  * [Symbol Scoping](#scoping)
* [Packages](#packages)
* [Object Oriented Programming](#oop)
  * [S3 OOP](#s3)
    * [Importance of Classes in S3](#s3classes)
  * [S4 OOP](#s4)
* [Developing in R](#rdeveloping)
  * [Errors and Error Handling](#errors)
  * [Debugging](#debugging)
  * [Programmer-like Objects](#dataobject)
* [Text Handling](#texthandling)
* [Probability](#probability)
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
  [scope](#scoping) in some circumstances and assign the global
  variable
* `:::` is used to access [internally scoped](#internalscope) variables
* Backticks allow recovery of function objects that would otherwise
  insist on be function-y eg `` `if` ``
* There are a few "naked" operators, like `next` or `break`, but
  nearly all other functions should include parentheses: Using
  `return` will return the *function* return; You probably wanted to
  `return()`.

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
* Special values
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
v <- c(12,6,7,22,19,5)
v[3] # Get the third element
v[c(3,5)] # Get third and fifth element
v[2:4] # Elements 2,3,4
v[v < 15] # All elements less than 15
b <- v < 15 # b is a logical vector same length as v, reporting entries < 15
v[b] # Will perform the same selection as two lines up
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

* Represented as a vector, but can be heterogeneous
* Lists can be turned into arrays by assigning `dim()`. Scott says
  this is generally useless, but occasionally very useful;
  Conversion to an array lets members be accessed by row and column
  indices/names.

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
* Every row is named (attribute `row.names`)
  * These names are preserved when subsetting.
* `data.matrix()` = convert to matrix
* Creation
  * `read.table()` [see below](#import)
  * `data.frame( col1, col2, ... )` = direct generation

# <a name='importexport'></a>Data Import and Export #

* [CRAN guide to Data Import/Export][CranImportExport]
* *I remain very confused over the diversity of import / export methods*
  * Some of the functions appear to be almost identical (`serialize`
    vs `saveRDS`) and it's unclear what the nuances are.

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

### <a name='connections'></a>Connections ###

* Includes files, but also file compression/decompression, URLs, pipes
* `file()` = general utility read/write
* `url()` = general utility URL access, supports http, https, ftp and file.
  * `method = "libcurl"` exposes more schemes, depending on platform
  * file methods are local machine only and need to be absolute paths
  * `URLencode` can be used to escape parameters in the
    URL. `URLdecode()` might be useful for unescaping.
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
* `<<-` is a special gets method that will assign a variable
  "normally" if it can find it in the parent search path, but if not
  will assign the variable in the global scope.
  * Docs say this is normally only used in functions. Scott reacted
    with alarm when I mentioned that Ron had told me about it.

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

* S4 is recommended when
  [developing with Bioconductor pacakages][s4bioconductor].

# <a name='rdeveloping'></a>Developing in R #

* Some coding style suggestions
  * [Google R Style Guide][GoogleStyle]
  * [R Coding Conventions][RCC]

### <a name='errors'></a>Errors and Error Handling ###

* `message` = informational
* `warning` = Possible problem, no impact on code flow
* `error` = Fatal problem, code halts (via `stop`)
* `condition` = Programmer-defined event

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

* `runif()` = The uniform distribution

# <a name='randomstuff'></a>Random Things #

* `R.Version()` = show the software version information for current
  R session
* There have been requests for
  [emacs keybindings in RStudio][RstudioEmacs] but they are no plans
  to implement it.

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
