# https://class.coursera.org/rprog-033/assignment/view?assignment_id=3
# https://d396qusza40orc.cloudfront.net/rprog%2Fdoc%2Fpollutantmean-demo.html

# Curl would not install on submit()
# http://www.phillipburger.net/wordpress/cannot-find-curl-config/
# Needed additional linux packages:
#   libcurl4-openssl-dev  libssl-dev
pollutantmean <- function(directory = "specdata", pollutant, id = 1:332) {
    # Get a character vector of the file paths we want:
    # The IDs need to be zero-padded to three characters
    filePaths <- sprintf("%s/%03d.csv", directory, id)
    # Extract the relevant column:
    polVals <- mergedFileRead( filePaths, pollutant )
    # return the mean
    mean(polVals)
}

mergedFileRead <- function( filePaths, column, tossNull = TRUE ) {
    # My original code is below in mergedFileReadInefficient() I
    # suspected it was not an efficient way to handle the values, and
    # asked Scott for the best way to concatenate multiple values
    # together

    # How many files do we have?
    numFiles <- length(filePaths)
    # Make an empty list with pre-specified size. By setting the list
    # size in advance we save R the hassle of constantly re-allocating
    # memory for the vectors inside the loop.
    columnCollection <- vector("list", numFiles);
    # Cycle over the files:
    for (i in seq_len(numFiles)) {
        tab <- read.csv( filePaths[[i]],
                        colClasses = c("Date","double","double","integer" ) )
        # Extract the values from the requested column
        # The values will be slotted into the relevant spot on columnCollection
        if (tossNull) {
            # Also exclude NULL
            columnCollection[[i]] <- tab[ !is.na(tab[column]) , column ]
        } else {
            # Keep all rows
            columnCollection[[i]] <- tab[ , column ]
        }
    }
    # Now we need to merge each file's list into one long
    # vector. Scott says to use unlist, but warns it has issues when
    # working with named lists.
    unlist(columnCollection)
}


mergedFileReadInefficient <- function( filePaths, column, tossNull = TRUE ) {

    # I was right! This is inefficient.
    
    # Make an empty vector that will hold all the values:
    rv <- vector()
    # Cycle over the files:
    for (path in filePaths) {
        tab <- read.csv( path, colClasses =
                                   c("Date","double","double","integer" ) )
        # Extract the values from the requested column:
        if (tossNull) {
            # Also exclude NULL
            col <- tab[ !is.na(tab[column]) , column ]
        } else {
            # Keep all rows
            col <- tab[ , column ]
        }
        # Extend the return value:
        rv <- c(rv, col)
        # I suspect that is a very inefficient way to concatenate vectors
    }
    rv # Return the vector of values
}
