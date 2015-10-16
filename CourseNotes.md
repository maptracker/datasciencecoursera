General notes from the lectures.

# The Data Scientist’s Toolbox

### Week 3

* Types of Questions
  * Descriptive
    * Simply state emperical observations extracted from data (eg Census)
  * Exploratory
    * Find previously unknown relationships, can define future studies
  * Inferential
    * Use observations on a small set of data to infer patterns in larger superset
  * Predictive
    * Use subset of known data to build models that can predict outcomes in unknown data
    * More data + Simpler models = better
  * Causal
    * Analyze how changes in one variable affect other variables
    * "gold standard" for data analysis
  * Mechanistic
    * Precisely relate changes in one or more variables to others
    * Mostly used in fields with low variability (engineering, physics)
* Experimental Design
  * Replication allows variabiltiy to be measured
  * [Duke sued over flawed stuides][dukesuit]. This does not seem to be entirely a poor design issue, as it is also linked to alleged academic fraud associated with [Anil Potti][potti].
  * [LOL insert statistical method here][nsaunders] ([Original paper][zhangetal], since editted)
  * Statistical Inference
    * Small sample designed to allow conclusions to be made against larger ones.
  * Using shoes size vs. age to illustrate confounding
  * Randomization and blocking
    1. If a variable does not need to be variant, fix it (keep constant)
    2. If you can't fix it, make sure it is stratified (equally distributed relative to other variables)
    3. If you can't do either, randomize it
* Prediction
  * Generally use a training set to build a predictive function
  * Relative size of effect is important. We may be able to infer without being able to predict due to overlap of the populations. Prediction requires decent separation of the the two populations.
* Data Dredging (multiple testing)

| Metric | Probability |
| --- | --- |
| Sensitivity | ``Pr( PositiveTest | Disease )`` |
| Specificity | ``Pr( NegativeTest | NotDisease )`` |
| Positive Predictive Value | ``Pr( Disease | PositiveTest )`` |
| Negative Predictive Value | ``Pr( NotDisease | NegativeTest )`` |
| Accuracy | ``Pr( CorrectTest )`` |


# R Programming #

### Week 1 ###

* R derived from S, now termed "S-PLUS" and owned by TIBCO
* R created in 1991; v 1.0 2000; v3.0 2013
  * Similar syntax to S, semantics are different
  * Modular packaging (CRAN), graphics support
  * FOSS.
    * LOL. First freedom is indexed zero even though R indices start at 1.
  * All objects are stored in physical memory
* Packages
  * CRAN has 4000+
  * Bioconductor
  * Random packages scattered around various websites
  * Includes training packages



[dukesuit]: http://news.sciencemag.org/2011/09/flawed-cancer-trial-duke-sparks-lawsuit
[potti]: https://en.wikipedia.org/wiki/Anil_Potti
[nsaunders]: https://nsaunders.wordpress.com/2012/07/23/we-really-dont-care-what-statistical-method-you-used/

[zhangetal]: http://www.biomedcentral.com/1752-0509/5/S3/S4
