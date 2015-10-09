* Hello

* `[` = returns an object of the same class, can select multiple elements.
  Simple example with a vector:
  ```R
  v <- c(12,6,7,22,19,5)
  v[3] # Get the third element
  v[c(3,5)] # Get third and fifth element
  v[2:4] # Elements 2,3,4
  v[v < 15] # All elements less than 15
  b <- v < 15 # b is a boolean vector of same length as v, reporting entries < 15
  v[b] # Will perform the same selection as two lines up
    ```
* `$` = Access by name. Simple example with list:
  ```R
  myList <- list( dog = c(17,32,1), cat = c(7,5,2) )
  myList$dog    # A numeric vector representing the 'dog' column
  myList[[1]]   # Same as above, a vector from the dog column
  myList[["dog"]] # Same as above, accessing via name

  myList[1]     # a *list* of just the dog column. Includes the name
  myList["dog"]   # Same as above, accessing via name
  colName <- "dog"
  myList[colName] # Same as myList["dog"]
  
  myList[[1]][[2]] # Get single element in first row, second column
  myList[[c(1,2)]] # Same as above
  ````
  * Goodbye
* Really goodbye
