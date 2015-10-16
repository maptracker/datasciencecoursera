# https://class.coursera.org/rprog-033/assignment/view?assignment_id=3
# https://d396qusza40orc.cloudfront.net/rprog%2Fdoc%2Fcomplete-demo.html

complete <- function(directory = "specdata", id = 1:332) {
    # How many files do we have?
    numFiles <- length(id)
    
    # Preallocate the columns:
    idCol    <- vector("integer", numFiles)
    rowCol   <- vector("integer", numFiles)

    # Scott reminds me it's dangerous to use 1:var because if var is
    # zero you get a two-element sequence of c(1,0). Use seq_len instead
    for (i in seq_len(numFiles)) {
        monId <- id[ i ]
        # Note the monitor ID:
        idCol[[i]] <- monId
        # Read in the relevant file (need to zero-pad ID)
        filePath <- sprintf("%s/%03d.csv", directory, monId)
        tab <- read.csv( filePath,
                        colClasses = c("Date","double","double","integer" ) )
        cc <- complete.cases(tab)
        # xx <<- cc
        if (FALSE) {
            # Make a filtered frame and count the number of rows
            ccTab <- tab[ cc, ]
            rowCol[[i]] <- nrow(ccTab)
            # Found out that length() counts columns, not rows!
            # rowCol[[i]] <- length(ccTab)
        } else {
            # ... but cc is a logical vector, we can just count the
            # number of TRUEs it contains. sum() works nicely, because
            # TRUE/FALSE typecasts to 1/0, respectively.
            rowCol[[i]] <- sum(cc)
        }
    }
    data.frame( id = idCol, nobs = rowCol )
}

