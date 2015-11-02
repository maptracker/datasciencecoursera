General notes from the lectures.

# Getting and Cleaning Data

### Week 1 ###

* Nice example relating [SQL to MongoDB][SqlToMongoDB]
* [Baltimore City Data][BaltimoreData]
* Data should have four components:
  1. Original "raw" data
  2. "Tidy" data
  3. Code book describing all variables in the tidy set
  4. Explicit steps for converting raw to tidy

##### Tidy Data #####

* Table / Variable structure
  * Each variable should be in one column
    * Each table should have a header row
  * Each observation should be in one row
  * Each "kind" of variable should have one table
    * Generally each table should be its own file
    * Different tables are linked by shared columns
* Code Book provides additional descriptive information about experiment
  * "Code Book" section describes all variables, include units
    * Variable names should be human readable
  * Describe summary choices that were made
  * "Study Design" section describes analysis, including how data were
    collected
* Instruction List
  * Ideally an executable script
    * Input is the raw data
    * Output is the tidy data
    * **NO PARAMETERS** - Script should be fully self-contained
  * If it is not possible to script the entire process, provide clear
    written instructions on the manual steps.

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
[SqlToMongoDB]: https://rickosborne.org/blog/2010/02/infographic-migrating-from-sql-to-mapreduce-with-mongodb/
[BaltimoreData]: https://data.baltimorecity.gov/
