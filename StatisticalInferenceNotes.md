### Basic Probability Notation

* https://en.wikipedia.org/wiki/Notation_in_probability_and_statistics
* P(A) = Probability that event / state "A" happens
* P(A &cap; B) = Probability that "A" *AND* "B" happens
* P(A &cup; B) = Probability that "A" *OR* "B" happens
* P(A | B) = Probability of "A" *GIVEN THAT* "B" is true
* P(X > x) = Cumulative probability for values of X greater than x.

### Set notation

* s &isin; S = "s" is a member of set "S"
* S &ni; s = "S" is a set with member "s"
* s &notin; S = "s" is not a member of set "S"
* `{}`


### Kolmogorov's Rules

* P(NothingHappens) = 0, P(SomethingHappens) = 1
  * Kolmogorov apparently never went to a baseball game
* P(Something) = 1 - P(OppositeOfSomething)
* P(Something &cap; NeverSomething) = 0
  * Mutually exclusive events never occur together
* P(This &cup; ThatWhichIsNeverThis) = P(This) + P(ThatWhichIsNeverThis)
  * Non-overlapping probabilities can be simply summed.
* P(A &cup; B) = P(A) + P(B) - P(A &cap; B)
  * More general rule to the previous one
* P(A | B) == 1 &rarr; P(A) &le; P(B)
  * If A always happens when B does, then A must be a subset of B

### Basics

* [Random Variable][WP_randvar] = numerical outcome of an experiment
* [Estimand][WP_estimand] = that which is to be estimated in a
  statistical analysis
* [Estimator][WP_Estimator] = rule for calculating an estimate of a
  given quantity based on observed data
* [Estimate][WP_Estimate] = the value of a statistic derived from a
  sample to estimate the value of a corresponding population parameter
* [Inference][WP_inference] = Linking your sample to a population.
* [Description][WP_desc] = Does not care about the l
* [Odds][WP_Odds] = `P(Something) / (1 - P(Something))`

### Probability mass function

* https://en.wikipedia.org/wiki/Probability_mass_function
* Always for discrete random variables
* Must always be >= 0
* Area under curve === 1.0
* &fnof;x(*x*) = P( X = *x* ) = P( { s &isin; S : X(s) = *x* } )
  1. &fnof;x = PMF, a discrete variable
  1. X = A function, a discrete random variable
  1. *x* = A particular observation from X
  1. S = The set of all possible observations
  1. s = A specific observation
* Scott used an example of two fair six-sided dice, and asking what
  the probability is that the sum of the die is 4:

```R
# S is the set of all possible paired rolls:
S <- expand.grid( d1 = 1:6, d2 = 1:6 )
# X maps the sum of the two dice to the frequency of that sum's occurrence
# Scott encourages use of rowSums() rather than d1 + d2
X <- with(S, table(d1 + d2))
# How frequent are rolls that sum to 4?
chi <- 4
X[as.character(chi)] / nrow(S)  # = 0.08333333
```

### Probability density function

* https://en.wikipedia.org/wiki/Probability_density_function
* Accessed via `d*` functions, like `dnorm()`
* Always for continuous random variables
* Must always be >= 0
* Area under curve === 1.0

### Cumulative distribution function

* https://en.wikipedia.org/wiki/Cumulative_distribution_function
* Accessed via `p*` functions, like `pnorm()`
* `F(x) = P( X <&le; x )`
* Survival function = inverse of CDF
  * `S(x) = 1 - F(x) = P( X > x )`

### Quantiles

* https://en.wikipedia.org/wiki/Quantile_function
* AKA "inverse cumulative distribution function"
* Accessed via `q*` functions, like `qnorm()`
* &alpha;th quantile = x&alpha; &rarr; F(X&alpha;) = &alpha;
* Percentile = quantile expressed as percent
* Median = 50th percentile

### Conditional Probability

#### Bayes' Rule

* https://en.wikipedia.org/wiki/Bayes'_rule
* Diagnostic tests
  * + = Positive test
  * - = Negative test
  * D = Condition where subject has disease
  * Dc = complement of D, subject does not have disease
  * https://en.wikipedia.org/wiki/Sensitivity_and_specificity
    * Specificity = P( + | D )
    * Sensitivity = P( - | D )
    * Prevalence = P( D )
  * https://en.wikipedia.org/wiki/Positive_and_negative_predictive_values
    * **PPV** = Positive predictive value = P( D | + )
      * `Sens * Prev / (Sens * Prev + (1 - Spec)*(1-Prev))`
      * P( Dc | + ) = 1 - P( D | + ), the probability of not having
        the disease given a positive test.
    * **NPV** = Negative predictive value = P( Dc | - )
      * `Spec * (1 - Prev) / ((1-Sens) * Prev + Spec*(1-Prev))`
  * https://en.wikipedia.org/wiki/Likelihood_ratios_in_diagnostic_testing
    * **DLR+** = positive likelihood ratio = P(+|D) / P(+|Dc)
    * Odds of disease given a positive test = P(D|+) / P(Dc|+)
      * = (P(+|D) / P(+|Dc)) * (P(D)/P(Dc))

#### Independence

* A is independent of B if P(A &cap; B) = P(A) * P(B)
* **IID** = "Independent and identically distributed" = variables
  independently chosen from the same distribution.

### Expected Values

* Will assume that populations are governed by densities and mass functions
  * Can then describe the population as charactersitics
  * *Mean* aka *expected value* = E[*X*] = center of distribution
  * *Sample mean* = estimates the population mean
  * variance, standard deviation
* Populations vs samples
  * The expected value of a sample mean is exactly that of the
    population mean that it is estimating.
  * The distribution of sample *averages* from a population will be
    centered at the same place as the average itself.
    * The population mean of *averages* is exactly the same as the
      population mean of sampled variables.
    * The distribution of averages will get more concentrated with
      higher sample sizes.

## Variability

* [Variance][WP_var]
  * Written either as Var(X) or &sigma;^2
  * A measure of spread. Given a mean of &mu; :
    * Var(X) = E[ (X-&mu;) ^ 2 ] = E[ X^2 ] - E[ X ]^2
    * Units are (units-of-distribution)-squared
  * SDmean = sqrt( Var(X) ) = [Standard deviation][WP_stddev]
    * Units are units-of-distribution
  * Sample Variance
    * sum( (X - Xavg)^2 ) / (n - 1)
    * Sample StdDev = sqrt(Sample Variance)
    * Like means, the variance of variance will constrict as more data
      are sampled. The center of the distribution of values will be at
      the population variance.
* [Standard error][WP_stderr]
  * SE = standard deviation of the sampling distribution of a statistic
  * Generally applied to the mean:
    * E[Xmean] = &mu;
    * Var(Xmean) = &sigma;^2 / n
      * Note that the variance goes to zero as n goes to infinity
    * With a sample standard deviation of *s*
      * SEmean = *s* / sqrt(n)
        * &rarr; How variable are random n-sized samples taken from the population
      * Compare to SD = &sigma; / sqrt(n) for the population


### Code snippets from lecture

```R
nosim <- 1000 # Number of simulations
n     <- 10   # sample size
m     <- matrix(rnorm(nosim * n), nosim) # Matrix of samples (here from normal distribution)
sampMean <- apply(m, 1, mean) # Use apply to efficiently get metric for simulated samples
sd( sampMean )   # report StdDev
hist( sampMean ) # Plot histogram
```

[WP_randvar]: https://en.wikipedia.org/wiki/Random_variable
[WP_estimand]: https://en.wikipedia.org/wiki/Estimand
[WP_Estimator]: https://en.wikipedia.org/wiki/Estimator
[WP_Estimate]: https://en.wikipedia.org/wiki/Estimation
[WP_inference]: https://en.wikipedia.org/wiki/Statistical_inference
[Description]: https://en.wikipedia.org/wiki/Descriptive_statistics
[WP_Odds]: https://en.wikipedia.org/wiki/Odds#Statistical_usage
[WP_stderr]: https://en.wikipedia.org/wiki/Standard_error
[WP_stddev]: https://en.wikipedia.org/wiki/Standard_deviation
[WP_var]: https://en.wikipedia.org/wiki/Variance
