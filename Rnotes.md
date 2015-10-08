# Fundamentals #
* `x <- y` : The arrow operator is **always** a copy function. That
  is, it does NOT simply create a new reference/pointer to the
  right-hand argument. In the above example, x and y will be "the
  same", but will be two independent objects (manipulating x will not
  change y, even if y is a data frame or other 'complex' object).
* R is case-sensitive: b != B
* Left methods and right methods may have the same name, but are
  generally (always?) different functions.
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
* Methods can be

### Objects ###
* [Hadley Wickham : Data structures][WickhamDataStructures] - nice
  overview shared by Scott.
* Object utility methods
  * `str()` = "Structure"
    * Provides a verbose report of what the object is and what
      value(s) it contains.
    * Includes a dozen parameters controlling output
  * `typeof()` = "storage mode" (class)
    * For a vector, reports the mode of the contents (ie not "vector")
  * `summary()` = brief overview of object
    * Reports "NA" content
  * `is.SOMETHING()` = class / type test method
    * eg `is.numeric()`
    * Returns a boolean indicating if the object "is" that thing
  * `as.SOMETHING()` = coerce / cast an object from one mode to another
    * eg `as.integer()`
* All objects appear to have a default value that is used when an
  object is needed but has not been explicitly provided.
* Atomic classes
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
  * `NA` = "Not Available"
    * `is.na()` = boolean check
    * Apparently returned for "not possible", eg `as.integer("pineapple")`
    * Is the default value for some objects, such as matrices without
      any values.
    * `NaN` = Not a Number
      * `is.nan()`
      * More specific form of NA
      * Used for missing values, plus "not numbers".
  * `NULL` = undefined
    * `is.null()`
      * Throws an error with no argument. Seems like that should be "TRUE"
    * Weird behavior. Throws an error when passed to is.na(), but
      spits out a bizzare value of `logical(0)` with is.nan(). May
      be a sign of a latent malignant AI - must watch carefully.
    * Asking Scott about NULL seems to make him uncomfortable, like
      telling a parent that their child is eating paste.
* Vector
  * Most basic object
    * Scott says everything in R is a vector - it does not have the
      concept of scalars.
  * Must contain homogenous (same class) entries
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
    * `1:20` = 1, 2, 3 ... 19, 20
  * List
    * Represented as a vector, but can be heterogeneous
* Matrix
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
      dimensionality is filled
        * `rbind(1:2,5:10)` will yield a first row that is
          `1,2,1,2,1,2` so that it is the same length as
          `5,6,7,8,9,10` in the second row.
        * If R can not fully reuse every repetition of an input vector
          it will warn you `number of columns of result is not a
          multiple of vector length` (but will still happily shovel
          repeating values into the matrix). You will get *no warning
          at all* if it is able to "cleanly" repeat all the input
          vectors.
* Array
* Factor
  * Factors are "labeled integer vectors"
  * Useful for categorical data, like "Male" / "Female" or "10 ug" /
    "20 ug" / "50 ug"
  * Functionally will be utilized as vectors, but the labels provide
    human interpretation (so you don't forget what 4 represents).
  * Used in modeling methods like `lm()` and `glm()`
  * `x <- factor(c("peach", "pear", "marmoset", "peach", "peach"))`
    * `typeof(x)` = `"integer"`
    * `str(x)` = `Factor w/ 3 levels "marmoset","peach",..: 2 3 1 2 2`
      * Note that internally while your order is maintained the
        integer assignment is made independently by R; peach is 2,
        even though it was "first".
    * `levels(x)` = reports the factor names as ordered by integer value
    * If you want to set the factor order explicitly, the `levels`
      argument can be used:
      * `x <- factor(c("peach", "pear", "marmoset", "peach", "peach"), levels = c("peach", "pear", "marmoset"))`
    * The order of levels is important in some modeling because the
      first level is taken as baseline.
  * `table()` = simple contigency table of the factor
* Data Frame
  * Special form of list
    * Each element is effectively a column
    * Like a matrix, is rectangular: All columns must have same length
      (same number of rows)
    * Like a list, but unlike a matrix, a data frame can be
      heterogeneous; Each column can be a different data type
  * Every row is named (attribute `row.names`)
  * `data.matrix()` = convert to matrix
  * Creation
    * `read.table()` (see below)
    * `data.frame( col1, col2, ... )` = direct generation
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
* Attributes
  * reported via `attributes()`
  * names & dimnames
  * dimensions (matrices, arrays)
  * class
  * length
  * user-defined

# Data Import #
* `read.table()` = flexible file import, lots of parameters:
  * `file` = path to file, or a connection
  * `header` = flag indicating a header row is present
  * `spe` = column separator
  * `colClasses` = character vector specifying column classes
  * `nrows` = number of rows to read in (useful for testing presumably)
    * `skip` = number of leading rows to skip over (useful for
      interupted loads))
  * `comment.char` = character that defines a comment row
    * Default is "#"
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
* `readLines()` = read arbitrary lines from a text file
* `load()` = reads in binary R object saved to a file
  * **PREFERRED METHOD**
  * Inverse of `save`
  * Can reconstitue an entire R workspace
* `source()` = reads ASCII-serialized R objects
  * Inverse of `dump`
* `dget()` = reads ASCII-serialized R objects
  * Inverse of `dput`
* `unserialize()` = reconsitute an R object via a "connection"
  * Inverse of `serialize`
* *I remain a tad confused over the diversity of import / export methods*

# Data Export #
* `save()` = full export of an R object to a file
  * **PREFERRED METHOD**
  * Inverse of `load` 
  * Default format is binary, but argument `ascii` can be used to make
    an ascii file
  * `save.image()` will save the entire workspace
* `dump()` = serialize an R object to ASCII text
  * Inverse of `source`
  * Takes a list of *names* as input (not objects)
  * May not generate an exact copy
* `dput()` = serializes an R object to ASCII text
  * Inverse of `dget`
  * Not as complete as `save`; will not export object name
  * Tries to maintain human readability
* `serialize` = 

# Packages #
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
    specific helper script for mananging large-scalle package
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

# Random

* `R.Version()` = show the software version information for current
  R session

## Serialization ##
* `match.call()`
  * Returns a 'language' object
* `parse()` can be used to process a character string to an R
  'expression'. That expression can then be fed to `eval`, which
  will then execute the code represented by the initial text. So
  `eval( parse( text = "some R code" ) )` is the same as eval("some
  R code") in many other languages.
```R
> myExp <- parse(text = "z <- 3")
> myExp
expression(z <- 3)
> eval(myExp)
> z
[1] 3
```

## Scott Wisdom ##
* Ariella pointed out that identically-named functions from one
  library will "overwrite" each other (most recently load wins).
  * R calls this "masking" and you can identify such situations with
    `conflicts()`
  

## Course Notes ##
* R derived from S, now termed "S-PLUS" and owned by TIBCO
* R created in 1991; v 1.0 2000; v3.0 2013
  * Similar syntax to S, semantics are different
  * Modular packaging (CRAN), graphics support
  * FOSS.
    * LOL. First freedom is indexed zero even though R indices start at 1.
  * All objects are stored in physical memory
* Packages
  * CRAN has 4000+
  * Bioconductor
  * Random packages scattered around various websites
  * Includes training packages


[WickhamDataStructures]: http://adv-r.had.co.nz/Data-structures.html
[BigNumbersInR]: https://stackoverflow.com/questions/2053397/long-bigint-decimal-equivalent-datatype-in-r
[SObignumbers]: https://stackoverflow.com/questions/17724382/display-exact-value-of-a-variable-in-r
