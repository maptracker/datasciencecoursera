# Fundamentals #
* ``x <- y`` : The arrow operator is **always** a copy function. That
  is, it does NOT simply create a new reference/pointer to the
  right-hand argument. In the above example, x and y will be "the
  same", but will be two independent objects (manipulating x will not
  change y, even if y is a data frame or other 'complex' object).

### Objects ###
* [Hadley Wickham : Data structures][WickhamDataStructures] - nice
  overview shared by Scott.
* Object utility methods
  * ``str()`` = "Structure"
    * Provides a verbose report of what the object is and what
      value(s) it contains.
    * Includes a dozen parameters controlling output
  * ``typeof()`` = "storage mode" (class)
    * For a vector, reports the mode of the contents (ie not "vector")
  * ``summary()`` = brief overview of object
    * Reports "NA" content
  * ``is.SOMETHING()`` = class / type test method
    * eg ``is.numeric()``
    * Returns a boolean indicating if the object "is" that thing
  * ``as.SOMETHING()`` = coerce / cast an object from one mode to another
    * eg ``as.integer()``
* All objects appear to have a default value that is used when an
  object is needed but has not been explicitly provided.

* Atomic classes
  * Character
    * default value ``""`` (empty string)
    * ``is.character()`` / ``as.character()``
  * Numeric
    * The alias "double" apparently can be interchanged anywhere
      "numeric" is used.
    * default value ``0``
    * ``is.numeric()`` / ``as.numeric()``
    * Double-precision reals
    * ``Inf`` = infinity, ``-Inf`` = negative infinity
      * ``is.finite()`` / ``is.infinite()``
      * R defines ``1 / 0`` as Inf - why isn't that UNDEF, since it's
        either Inf or -Inf ??
    * With some effort can [increase magnitude of floats][BigNumbersInR]:
      * ``library(gmp)`` = "Arithmetic Without Limits"
      * ``library(Brobdingnag)`` = represent numbers in log form
    * ``options(digits=16)`` = set the number of digits R displays [StackOverflow](https://stackoverflow.com/questions/17724382/display-exact-value-of-a-variable-in-r)
  * Integer
    * default value ``0``
    * ``is.integer()`` / ``as.integer()``
    * If defining explicitly, suffix with ``L`` to avoid being cast as
      numeric, eg ``172L``
  * Complex
    * default value ``0+0i``
  * Logical (Boolean)
    * default value ``FALSE``
* Special values
  * ``NA`` = "Not Available"
    * ``is.na()`` = boolean check
    * ``NaN`` = Not a Number
      * ``is.nan()``
      * More specific form of NA
      * Used for missing values, plus "not numbers".
  * ``NULL`` = undefined
    * ``is.null()``
      * Throws an error with no argument. Seems like that should be "TRUE"
    * Weird behavior. Throws an error with is.na(), but spits out a
      bizzare value of ``logical(0)`` with is.nan(). May be a sign of
      a latent malignant AI - must watch carefully.
    * Asking Scott about NULL seems to make him uncomfortable, like
      telling a parent that their child is eating paste.
* Vector
  * Most basic object
    * Scott says everything in R is a vector - it does not have the
      concept of scalars.
  * Must contain homogenous (same class) entries
  * Creation
    * ``vector()``
      * ``x <- vector("numeric", length = 10)``
      * Initialized with default values.
    * ``c()`` = "concatenate"
      * ``x <- c( 1L, 2L, 3L )``
      * **CAUTION:** c() will type-cast your input to force it into
        homogeneity, if required. For example:
      * ``x <- c( 1L, 2L, 3L, 5, "7" )`` (integer, numeric, character)
        * ``str(x)`` &rarr; ``chr [1:5] "1" "2" "3" "5" "7"`` (all characters!)
  * Sequences
    * Iterative vectors, defined easily with ":"
    * ``1:20`` = 1, 2, 3 ... 19, 20
  * List
    * Represented as a vector, but can be heterogeneous
* Attributes
  * reported via ``attributes()``
  * names & dimnames
  * dimensions (matrices, arrays)
  * class
  * length
  * user-defined

# Packages #
* ``a <- available.packages()`` = puts list of all packages in ``a``
* ``head(rownames(a), 3)``
* ``install.packages("<PACKAGE_NAME_HERE>")`` = install the package from CRAN
 * First install asks you to specify a local mirror
 * Can pass a list of package names as well
 * RStudio : Menu option Tools > Install Packages
* ``source("http://bioconductor.org/biocLite.R")`` = loads a remote
  script for installing the Bioconductor packages
  * ``biocLite()`` = Installs **ALL** of Bioconductor
  * ``biocLite(c("<PACKAGE_1>","<PACKAGE_2>",...))`` = Installs just a
    subset of packages
  * AFAICT this is not a general loading mechanism but is rather a
    specific helper script for mananging large-scalle package
    installations. Probably common to other resources as well.
* ``library(ggplot2)`` = load the ggplot2 package into your current R session
  * ``install()`` downloads code to your local machine. Needs to be
    done once (per machine)
  * ``library()`` makes it available for your current session /
    script. Will automatically **load** dependencies, but I don't
    think it will automatically **install** them. Needs to be done
    every session. Should not use quotes.
* Rtools is needed for building packages in Windows.
  * Also want to ``install.packages("devtools")`` after downloading

# Random

## Serialization ##
* ``match.call()``
  * Returns a 'language' object
* ``parse()`` can be used to process a character string to an R
  'expression'. That expression can then be fed to ``eval``, which
  will then execute the code represented by the initial text. So
  ``eval( parse( text = "some R code" ) )`` is the same as eval("some
  R code") in many other languages.

    > myExp <- parse(text = "z <- 3")
    > myExp
    expression(z <- 3)
    > eval(myExp)
    > z
    [1] 3


## Scott Wisdom ##
* Ariella pointed out that identically-named functions from one
  library will "overwrite" each other (most recently load wins).
  * R calls this "masking" and you can identify such situations with
    ``conflicts()``
  

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
