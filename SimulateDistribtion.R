## Taken from Statistical Inference course module 5

sf <- function (val) {
    ## Just report 4 significant figures
    signif(val,4)
}

simulate <- function(n = 10, nosim = 1000, distfunc = rnorm, metric = mean,
                     refvar = NULL, center = NULL) {

    ## Get the string name of the passed methods
    ## https://stackoverflow.com/a/4108650
    metName <- deparse(substitute(metric))
    distName <- deparse(substitute(distfunc))

    ## Make a matrix to hold each simulated sample
    ## Each sample will be pulled from the selected distribution
    m <- matrix(distfunc(nosim * n), nosim)
    ## Use apply to efficiently calculate our chosen metric across the matrix:
    met <- apply(m, 1, metric)
    mysd <- sd(met)
    
    message(sprintf("\n%d simulations with %d samples taken from %s\n  StdDev of %s = %s",
                    nosim, n, distName, metName, sf(mysd)))
    hdat = hist(met, breaks = 50, main = sprintf("%d simulations of %s, sample size %d", nosim, distName, n),
                xlab = sprintf("%s of sample", metName, n, distName))
    maxFreq <- max(hdat$counts)
    meanX <- mean( hdat$counts * hdat$mids )
    str(hdat)
    if (!is.null(center)) {
        ## User has provided an expected center value for the metric
        lines(c(center, center), c(0,maxFreq), col = "red", lwd = 5)
        text(center, maxFreq, sprintf("Expect : %s", center), pos = 4, col = "red")
    }
    if (!is.null(refvar)) {
        ## A reference variance has been provided
        refsd = sqrt( refvar / n )
        diffsd = refsd - mysd
        percdiff = abs(100 * diffsd / refsd)
        message(sprintf("  Reference var = %s, sd = %s\n  SD difference is %s (%.2f%%)",
                        sf(refvar), sf(refsd), sf(diffsd), percdiff))
        cen = ifelse(is.null(center), meanX, center)
        lines(c(cen-refsd, cen+refsd), c(0,0), col="red", lwd = 5)
    }
    lines(c(meanX-mysd, meanX+mysd), c(0,0), col="blue", lwd = 3)
    lines(c(meanX, meanX), c(0,maxFreq), col="blue", lwd = 3)
    message("")
    m
}
