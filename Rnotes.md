# Fundamentals #

* `x <- y` : The arrow operator is **always** a copy function. That
  is, it does NOT simply create a new reference/pointer to the
  right-hand argument. In the above example, x and y will be "the
  same", but will be two independent objects (manipulating x will not
  change y, even if y is a data frame or other 'complex' object).
* `=` can be used as an alias for `<-`
  * Scott avoids this, because it can cause confusion when dealing
    with parameter assignment, which also uses equals, for example
    with the 'nrow' parameter in `diag(1:2, nrow = 4)`
* Parameters to functions are sometimes passed at particular positions
  (first parameter, second parameter, etc), and sometimes passed by
  name (`length = 5`).
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

# Objects #

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
* Attributes
  * `attributes()` can get and set values
  * names & dimnames, dimensions (matrices, arrays), class, length, etc
  * user-defined

#### Object Utility Methods ####

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

#### Atomic Classes ####

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
    * NA can exist in many (any?) of the other modes. That is, there
      is an integer mode for NA, a character mode, etc. The default
      mode appears to be logical.
      * These can be assigned directly with `as`, for example `as.character(NA)`
      * More commonly the mode will be assigned "automatically" to
        make the mode fit the surrounding context:
        ```R
> x <- c( one = 1, two = 2, four = 4)
> x[c("one", "three")]
 one <NA> 
   1   NA 
> mode(x[c("one", "three")][[2]])
[1] "numeric"
        ```
        The "NA" is mode numeric, since that is the mode of the source vector
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

## Vectors, Matrices and Data Frames ##

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

#### Vectors ####

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

#### Lists ####

* Represented as a vector, but can be heterogeneous
* Lists can be turned into arrays by assigning `dim()`. Scott says
  this is generally useless, but occasionally very useful;
  Conversion to an array lets members be accessed by row and column
  indices/names.

#### Matrices ####

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
* `diag()` = weirdly polymorphic matrix function
  * `myDiag <- diag( myMatrix )` = Extract the diagonal
  * `mySquare <- diag( 5 )` = Creates a 5x5 matrix
  * `myMostlyEmpty <- diag(1:10)` = Crates a 10x10 matrix with only
    the diagonal populated
  * `diag( myMatrix ) <- value` = Change the diagonal
  * `x <- diag(5,4)` = Creates a 4x4 empty matrix with a diagonal of fives.

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

#### Arrays ####

#### Factors ####

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
* `table()` = simple contingency table of the factor
  * By default missing values will be excluded in the counts! set
    `exclude = NULL` to count them as well. Scott says some
    statistic shops have altered the table function to have this as
    the default.
    
#### Data Frames ####

* Special form of list
  * Each element is effectively a column
  * Like a matrix, is rectangular: All columns must have same length
    (same number of rows)
  * Like a list, but unlike a matrix, a data frame can be
    heterogeneous; Each column can be a different data type
* Every row is named (attribute `row.names`)
* `data.matrix()` = convert to matrix
* Creation
  * `read.table()` [see below](#import)
  * `data.frame( col1, col2, ... )` = direct generation

# Data Import and Export #

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

### Data Export ###
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

### <a name='connections></a>Connections ###

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

# Random

* `R.Version()` = show the software version information for current
  R session

## <a name='serialization'></a>Serialization ##
* `match.call()`
  * Returns a 'language' object
* `parse()` can be used to process a character string to an R
  'expression'. That expression can then be fed to `eval`, which
  will then execute the code represented by the initial text. So
  `eval( parse( text = "some R code" ) )` is the same as eval("some
  R code") in many other languages.
  * ```R
    > myExp <- parse(text = "z <- 3")
    > myExp
    expression(z <- 3)
    > eval(myExp)
    > z
    [1] 3
    ```
* See also the [Data Import](#import) section above.

## Scott Wisdom ##
* Ariella pointed out that identically-named functions from one
  library will "overwrite" each other (most recently load wins).
  * R calls this "masking" and you can identify such situations with
    `conflicts()`
  * Scott notes that the functions are not "overwritten"; All
    same-named functions still exist within the R session, and can all
    be accessed as long as you specify the package you want a particular from:
    * `somePackage::someFunction( color = "lizzard" )` = access
      someFunction() contained in the package somePackage.
    * `get("someFunction", pos = "somePackage")( color = "lizzard" )`
      = same as above, different syntax using the `get` function.
  
## Weird Things ##

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


#### Markdown Notes ####
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
    * [Code blocks in lists][CodeBlockInList] are finicky. The leading
      and trailing backticks need to be at the same indent as the list
      item content.
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
