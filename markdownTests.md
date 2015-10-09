
#### <a name='subsetting'></a>Subsetting ####

* Selecting part of a list
  
  ```R
  v <- c(12,6,7,22,19,5)
  v[3] # Get the third element
  v[c(3,5)] # Get third and fifth element
  v[2:4] # Elements 2,3,4
  v[v < 15] # All elements less than 15
  b <- v < 15 # b is a logical vector same length as v, reporting entries < 15
  v[b] # Will perform the same selection as two lines up
  ```
  
  * Single brackets are needed for accessing multiple elements from a list
* `[[` = Access a specific element
  * Only one element at a time!
* `$` = Access by name. Simple example with list:

  ```R
  myList <- list( dog = c(17,32,1), cat = c(7,5,2) )
  myList$dog      # A numeric vector representing the 'dog' column
  myList[[1]]     # Same as above, a vector from the dog column
  myList[["dog"]] # Same as above, accessing via name
  
  myList[1]       # a *list* of just the dog column. Includes the name
  myList["dog"]   # Same as above, accessing via name
  colName <- "dog"
  myList[colName] # Same as myList["dog"]
  
  myList[[1]][[2]] # Get single element in first row, second column
  myList[[c(1,2)]] # Same as above
  ```
  
* Matrix subsets that are 1 dimensional by default will return
  vectors. If you want such results to remain as matrices, use `drop
  = FALSE`. Examples:
  
  ```R
  x <- matrix( 11:22, nrow = 3, dimnames = list
    ( c("Alice","Bob","Chris"),
      c("Alpha","Beta","Gamma","Delta") ) )
  x[[10]]        # Get the 10th element
  x[ 2, ]        # Get the second row
  x[ "Bob" ]     # second row by name
  x[ , 3]        # Third column
  x[ , "Gamma" ] # Third column by name
  x[ 2,1 ]       # Element in second row, first column *as a vector*
  x[ 2,1, drop = FALSE ] # As above, but now returns a 1x1 matrix
  x[ c(2,3),c(2,4) ]     # Slice of rows 2+3 / cols 2+4
  # Matrices do not use '$' for named accession:
  x[ c("Bob","Chris"), c("Beta","Delta") ] # Same slice as above
  ```

