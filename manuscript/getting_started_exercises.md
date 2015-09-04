---
layout: page
title: Getting Started Exercises
---

X> ## Exercises
X>
X> Here we will test if some of the basics of R data manipulation which you should know or should have learned by following the tutorials above. You will need to have the file `femaleMiceWeights.csv` in your working directory. As we showed above, one way to do this is using the `downloader` package:
X>```r
X>library(downloader) 
X>url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleMiceWeights.csv"
X>filename <- "femaleMiceWeights.csv" 
X>download(url, destfile=filename)
X>```
X> 1. Read in the file `femaleMiceWeights.csv` and report the bodyweight of the mouse in the exact name of the column containing the weights
X>
X> 2. The `[` and `]` can be used to extract specific rows and specific columns of the table.  What is the entry in the 12th row and second column?
X> 3. You should have learned how the`$` character is used to extract a column from the table returned as a vector. Use `$` to extract the weight column and report the weight of the mouse in the 11th row.
X> 4. The `length` function returns the number of elements in a vector. How many mice are included in our dataset?
X> 5. To create a vector with the numbers 3 to 7 we can use `seq(3,7)` or, because they are consecutive, `3:7`. View the data and determine what rows are associated with the heigh fat or `hf` diet. Then use the mean function to compute the average weight of these mice.
X> 6. One of the function we will be using often is `sample`. Read the help file for sample using `?sample`. Now take a random sample of size 1 from the numbers 13 to 24 and report back the weight of the mouse represented by that row. Make sure to type `set.seed(1)` to assure that everybody gets the same answer.



  
