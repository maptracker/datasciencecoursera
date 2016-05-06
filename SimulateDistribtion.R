## Taken from Statistical Inference course module 5

sf <- function (val) {
    ## Just report 4 significant figures
    signif(val,4)
}

## Getting the string name of a variable:

simulate <- function(n = 10, nosim = 1000, distfunc = rnorm, metric = mean,
                     refvar = NULL) {

    ## Get the string name of the passed methods
    ## https://stackoverflow.com/a/4108650
    metName <- deparse(substitute(metric))
    distName <- deparse(substitute(distfunc))

    ## https://stat.ethz.ch/pipermail/r-help/2011-September/288786.html
    argg <- as.list( sys.call() )

    ## Capture the parameters as passed to this function
    ## https://stackoverflow.com/a/17244041
    ## argg <- c(as.list(environment()))
    print(argg)
    ## Turn the functions into their string names
    ## https://stackoverflow.com/a/5100147
    ## metName  <- as.character(substitute(argg$metric))
    ## distName <- as.character(substitute(argg$distfunc))

    ## print(as.list(match.call()))
    ## Make a matrix to hold each simulated sample
    ## Each sample will be pulled from the selected distribution
    m <- matrix(distfunc(nosim * n), nosim)
    ## Use apply to efficiently calculate our chosen metric across the matrix:
    met <- apply(m, 1, metric)
    mysd <- sd(met)
    message(sprintf("%d simulations with %d samples taken from %s\n  StdDev of %s = %s",
                    nosim, n, distName, metName, sf(mysd)))
    if (!is.null(refvar)) {
        ## A reference variance has been provided
        refsd = sqrt( refvar / n )
        diffsd = refsd - mysd
        percdiff = abs(100 * diffsd / refsd)
        message(sprintf("Difference from reference (var = %s, sd = %s) is %s (%.2f%%)",
                        sf(refvar), sf(refsd), sf(diffsd), percdiff))

    }
    hist(met, breaks = 50)
    m
}
