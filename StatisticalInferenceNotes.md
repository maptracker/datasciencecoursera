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
  * Sample Variance
    * sum( (X - Xavg)^2 ) / (n - 1)
    * Like means, the variance of variance will constrict as more data
      are sampled. The center of the distribution of values will be at
      the population variance.
* [Standard deviation][WP_stddev]
  * Describes how variable the population is
  * SDmean = sqrt( Var(X) )
    * Units are units-of-distribution
    * Sample StdDev = sqrt(Sample Variance)
* [Standard error][WP_stderr]
  * Describes how variable sample averages are
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
nosim  <- 1000  # Number of simulations
n      <- 10    # sample size
myDist <- rnorm # the distribution we will use
simulate <- function(n = 10, nosim = 1000, distribution = rnorm) {

m     <- matrix(rnorm(nosim * n), nosim) # Matrix of samples (here from normal distribution)
sampMean <- apply(m, 1, mean) # Use apply to efficiently get metric for simulated samples
sd( sampMean )   # report StdDev
hist( sampMean ) # Plot histogram
```

# Distributions

* [Bernoulli][Bernoulli]
  * result of a binary outcome
  * mean *p* -> Variance $p(1 - p)$
  * PMF = $$P(X = x) =  p^x (1 - p)^{1 - x}$$
* [Binomial][Binomial]
  * Sum of Bernoulli trials
* [Normal][Normal] aka Gaussian
  * `N`, when &mu; = 0 and &sigma; = 1, it's a "standard" normal
    distribution, `Z`
    * Z[ -1&sigma; - +1&sigma; ] = ~68%
    * Z[ -2&sigma; - +2&sigma; ] = ~95%
    * Z[ -3&sigma; - +3&sigma; ] = ~99%
    * Percentiles
      *  10th = -1.28&sigma;
      *   5th = -1.64&sigma;
      * 2.5th = -1.96&sigma;
      *   1st = -2.33&sigma;
* [Poisson][Poisson]
  * Used to model counts
  * `P(X = x; &lambda;)` = &lambda;^x * e^-&lamda; / x!
    * mean = &lambda;, variance = &lambda;
    * Default distribution for modeling [contingency tables][contingency]
    * Commonly used for survival analyses
  * Modeling rates
    * `X ~ Poisson(&lambda;t)`
      * &lambda; = E[ X / t ] = expected count per unit of time
      * t = total time monitored
  * Note: Important to use the appropriate lambda!
    * `ppois(x, y) != ppois(2*x, 2*y)`
  * Can approximate binomials for large *n* + small *p*
    * If `X ~ binomial(n, p)` use `&lambda; = np`
    * The estimation savings appear to be modest?

```R
library(microbenchmark)
size    <- 500000
success <- 4000
prob    <- 0.01
mbm <- microbenchmark( binom = pbinom(success, size, prob),
                       pois  = ppois(success, size * prob), times = 10000)
mbm

Unit: microseconds
  expr   min     lq     mean median     uq     max neval
 binom 3.739 5.2215 5.888463  5.702 6.1850 135.254 10000
  pois 4.385 5.9280 6.607649  6.428 6.9185  27.042 10000
```

# Asymptotics

* Behavior of statistics as sample size approaches infinity
* [Law of Large Numbers][LoLN] aka "LLN"
  * The average of a sample "limits to" the population mean
* An estimator is **consistent** if it converges to the expected value
* [Central Limit Theorem][CLT]
  * The sample average is normally distributed, with a mean
    approaching that of the population mean.

# Confidence Intervals

* &plusmn;2 &sigma; (two standard deviations on either side of mean)
  covers ~95% of a normal distribution.
* [Binomial proportion confidence interval][BPCI] aka "Wald interval"
  *
* A "conservative" confidence interval is one that is designed to
  assure an "adequately broad" interval that has a high(er) likelihood
  of representing your confidence ranges, but may be broader than
  neccesary.
* Poisson example from lecture: A device fails 5 times in 94.32
  days. What is the 95%CI for the daily failure rate?

```R
x      <- 5
t      <- 94.32
lambda <- x/t      # lambda-hat = Estimate of failure rate
varLam <- lambda/t # Variance of lambda-hat
round(lambda +       # Center of distribution
      c(-1, 1) *     # Get left and right sides
      qnorm(0.975) * # 97.5 percentile for standard normal distribution
      sqrt(varLam),  # The standard error
      3)             # Rounding to three places

# Conservative "exact" interval
poisson.test(x, T = t) # Interval stored in $conf.int
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

[Bernoulli]: https://en.wikipedia.org/wiki/Bernoulli_distribution
[Binomial]: https://en.wikipedia.org/wiki/Binomial_distribution
[Normal]: https://en.wikipedia.org/wiki/Normal_distribution
[Poisson]: https://en.wikipedia.org/wiki/Poisson_distribution
[Kaplan–Meier]: https://en.wikipedia.org/wiki/Kaplan%E2%80%93Meier_estimator
[contingency]: https://en.wikipedia.org/wiki/Contingency_table
[Law of Large Numbers]: https://en.wikipedia.org/wiki/Law_of_Large_Numbers
[CLT]: https://en.wikipedia.org/wiki/Central_limit_theorem
[BPCI]: https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval
