* Hello
  * ```R
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
    ```
  * Goodbye
