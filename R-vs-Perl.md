Notes and examples for trying to "mentally map" Perl paradigms to R.

### Implicit loops ###

* ![Scott][Scott] **Scott Feedback:**
  * Subsetting operations simply utilize a logical vector to select
    the desired subset. The column tests are each generating a logical
    vecor, which are then combined with the `&` element-wise operator
    to create a single logical vector.

Perl has the `map()` function which compactly iterates over a list. For example:

```Perl
my $total = 0;
# Loop over all values of @someNumbers and tally them:
map { $total += $_ } @someNumbers;
```

R appears to have implicit iteration:

```R
> mtcars[ mtcars$mpg > 25 & mtcars$hp > 80, ]
               mpg cyl  disp  hp drat    wt qsec vs am gear carb
Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.7  0  1    5    2
Lotus Europa  30.4   4  95.1 113 3.77 1.513 16.9  1  1    5    2
```

In order for the test to work, `mtcars$mpg` and `mtcars$hp` need to
"be on the same page" with regards to the loop; They have to be
considering the same row number. This implies a hidden iterator that
is shared between the statements so the comparison is "aligned".

* Is the iterartor specific to mtcars? Or is it provided to other
  structures that could be used in the row selection clause?
* Is the iterator exposed by some variable, like Perl's `$_`?
  * I suspect normally we don't care, but what if I want look-back or
    look-ahead functionality for some reason ($_ - 1 or $_ + 1)?


### Logical Tests ###

* ![Scott][Scott] **Scott Feedback:**
  * `&` is vectorized - it applies across all elements of a list or vector
  * `&&` expects length-1 operands, will ignore 'extra' values. It is
    also lazy evaluated, in that a logical chain will stop evaluation
    if the final boolean is determined early (eg `FALSE && TRUE &&
    TRUE` halts at the first FALSE).
* I thought `&` and `&&` were comperable to Perl's `&&` and
  `and`. This is clearly not the case:
  * `&` is either Perl's `&&` or `and`
  * Unclear to me what `&&` is doing in R

[Scott]: ./sao.png "Information or advice from Scott"
