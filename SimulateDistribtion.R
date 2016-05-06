## Taken from Statistical Inference course module 5

sf <- function (val) {
    ## Just report 4 significant figures
    signif(val,4)
}

simulate <- function(n = 10, nosim = 1000, distfunc = rnorm, metric = mean,
                     popSD = 1, popMean = 0) {
    
    ## Line widths. Population values are thicker and plotted first so
    ## they can be seen behind sample lines.
    popWid <- 5
    sampWid <- 3

    ## Get the string name of the passed methods
    ## https://stackoverflow.com/a/4108650
    metName <- deparse(substitute(metric))
    distName <- deparse(substitute(distfunc))

    ## Make a matrix to hold each simulated sample
    ## Each sample will be pulled from the selected distribution
    if (distName == 'mean') {
        ## Uses sd argument
        m <- matrix(distfunc(nosim * n, sd = popSD, mean = popMean), nosim)
    } else {
        m <- matrix(distfunc(nosim * n, mean = popMean), nosim)
    }
    ## Use apply to efficiently calculate our chosen metric across the matrix:
    met  <- apply(m, 1, metric)
    mysd <- sd(met)
    
    message(sprintf("\n%d simulations with %d samples taken from %s\n  StdDev of %s = %s",
                    nosim, n, distName, metName, sf(mysd)))
    hdat = hist(met, breaks = 50, main = sprintf("%d simulations, sample size %d\n%s(mean=%s, sd=%s)", nosim, n, distName, popMean, popSD),
                xlab = sprintf("%s() of sample", metName, n, distName))
    maxFreq <- max(hdat$counts)
    meanX <- mean( met )

    ## Annotate the expected population mean:
    expMean = metric(rep(popMean, n))
    lines(c(expMean, expMean), c(0,maxFreq), col = "red", lwd = popWid)
    text(expMean, maxFreq, sprintf("Expect : %s", expMean), pos = 4, col = "red")

    ## Annotate the population variance and SD
    expSD <- 0
    if (metName == 'mean') {
        expSD = popSD / sqrt(n)
    } else {
        message("Do not know how to calculate expected sample SD for ",
                metName,"()")
    }
    expVar = expSD^2
    diffsd = expSD - mysd
    percdiff = abs(100 * diffsd / expSD)
    message(sprintf("  Reference var = %s, sd = %s\n  SD difference is %s (%.2f%%)",
                    sf(expVar), sf(expSD), sf(diffsd), percdiff))
    lines(c(expMean-expSD, expMean+expSD), c(0,0), col="red", lwd = popWid)

    obsHeight =  0.9 * maxFreq;
    lines(c(meanX-mysd, meanX+mysd), c(0,0), col="blue", lwd = sampWid)
    lines(c(meanX, meanX), c(0,obsHeight), col="blue", lwd = sampWid)
    text(meanX, obsHeight, sprintf("Observed : %s", sf(meanX)), pos = 4, col = "blue")
    message("")
    m
}
