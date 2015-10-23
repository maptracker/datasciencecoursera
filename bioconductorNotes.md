# Installation and Setup #

### Initial Installation ###

* [Installation Documentation][BioconductorInstall]

  ```R
  source("http://bioconductor.org/biocLite.R")
  biocLite()
  ```
  
  * Installing a specific package:
    
    ```R
    library(BiocInstaller)
    biocLite("GenomicRanges")
    biocLite(pkgs=c("Biobase", "IRanges", "AnnotationDbi"))
    ```

    * Note: biocLite appears to happily re-install existing packages,
      even if you've set `suppressUpdates=FALSE`. Given that some of
      these packages are large, you probably want to use biocLite manually.


# Internals #

### Iranges ###

* These are 

# Specific Packages #

### GenomicRanges ###

* Setup
  
  ```R
  library(BiocInstaller)
  biocLite(pkgs=c("GenomicRanges, "airway"))
  
  # Load example data set:
  library(airway)
  data(airway)
  ```
  
  * The **airway** dataset contains a nice human RNAseq data set
    encapsulated as a "RangedSummarizedExperiment" object


[BioconductorInstall]: http://www.bioconductor.org/install/
