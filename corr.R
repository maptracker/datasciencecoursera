# https://class.coursera.org/rprog-033/assignment/view?assignment_id=3
# https://d396qusza40orc.cloudfront.net/rprog%2Fdoc%2Fcorr-demo.html

corr <- function(directory = "specdata", threshold = 0) {
    allFiles <- list.files(directory)
    numFiles <- length(allFiles)
    allCors  <- vector("numeric", numFiles)
    # Scott: This is a way to iterate the right argument over all
    # entries in the left argument
    allCors[] <- NA
    
    # The summary statistics were subtly different than the examples
    # in the sample output. I played with another way of assembling
    # the final vector (using variable "rv") to see if I was messing
    # up threshold exclusion. In the end, but there did not appear to
    # be any difference between them, so I commented out the rv lines
    
    # rv <- vector("numeric")
    for (i in seq_len(numFiles)) {
        file <- allFiles[i]
        # Sanity check to see if the file is really a CSV. Scott
        # points out grepl returns a logical vector
        isCSV <- grepl("\\.csv$",file);
        if (!isCSV) {
            print(paste("Ignoring non-CSV file:", file));
            next
        }
        
        filePath <- sprintf("%s/%s", directory, file)
        tab <- read.csv( filePath,
                        colClasses = c("Date","double","double","integer" ) )
        # Tally number of complete cases:
        cc <- complete.cases(tab)
        numCC <- sum(cc)
        # Skip unless number of cases is greater than threshold:
        if (numCC <= threshold) next
        # Filter table
        ccTab <- tab[ cc, ]
        # print(sprintf("%d = %d rows", i, nrow(ccTab)))
        SOx <- ccTab$sulfate
        NOx <- ccTab$nitrate
        corVal <- cor(SOx, NOx)
        allCors[[i]] <- corVal
        # rv <- c(rv, corVal)
    }
    hasValue <- allCors[ !is.na( allCors ) ]
    # print(sprintf("rv = %d, hasValue = %d", length(rv), length(hasValue)))
    hasValue
    # rv
}
