# Packages #
* ``a <- available.packages()`` = puts list of all packages in ``a``
* ``head(rownames(a), 3)``
* ``install.packages("<PACKAGE_NAME_HERE>")`` = install the package from CRAN
 * First install asks you to specify a local mirror
 * Can pass a list of package names as well
 * RStudio : Menu option Tools > Install Packages
* ``source("http://bioconductor.org/biocLite.R")`` = loads a remote script for installing the Bioconductor packages
  * ``biocLite()`` = Installs **ALL** of Bioconductor
  * ``biocLite(c("<PACKAGE_1>","<PACKAGE_2>",...))`` = Installs just a subset of packages
  * AFAICT this is not a general loading mechanism but is rather a specific helper script for mananging large-scalle package installations. Probably common to other resources as well.
* ``library(ggplot2)`` = load the ggplot2 package into your current R session
  * ``install()`` downloads code to your local machine. Needs to be done once (per machine)
  * ``library()`` makes it available for your current session / script. Will automatically **load** dependencies, but I don't think it will automatically **install** them. Needs to be done every session. Should not use quotes.
* Rtools is needed for building packages in Windows.
  * Also want to ``install.packages("devtools")`` after downloading


## Scott Wisdom ##
* Ariella pointed out that identically-named functions from one library will "overwrite" each other (most recently load wins).
  * R calls this "masking" and you can identify such situations with ``conflicts()``
  
