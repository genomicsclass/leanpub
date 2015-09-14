---
Title: Introduction to high throughput data exercises
---

A>## Exercises
A>
A>For the remaining parts of this book we will be downloading larger datasets than those we have been using. Most of thes datasets are not avaialbe as part of the standard R installation or packages such as `UsingR`. For some of these packages we have created pacakges and offer them via GitHub. To download these you will need to install the `devtools` package. Once you do this you can install packages such as the `GSE5859Subset` which we will be using here:
A>
A>
```r
library(devtools)
install_github("genomicsclass/GSE5859Subset")
```
A>
A>```
A>## Downloading github repo genomicsclass/GSE5859Subset@master
A>## Installing GSE5859Subset
A>## '/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file  \
A>##   --no-environ --no-save --no-restore CMD INSTALL  \
A>##   '/private/var/folders/kv/h18_5_qn1hj43r8pq5l0tddw0000gn/T/Rtmp8XMTdM/devtools90421f538008/genomicsclass-GSE5859Subset-8ada5f4'  \
A>##   --library='/Library/Frameworks/R.framework/Versions/3.2/Resources/library'  \
A>##   --install-tests
A>```
A>
```r
library(GSE5859Subset)
data(GSE5859Subset)
```
A>
A>This package loads three tables:  `geneAnnotation`, `geneExpression`, and `sampleInfo`. Answer the following questions to familiarize yourself with the data set:
A>
A>
A>1. How many samples where processed on 2005-06-27?
A>
A>
A>
A>2. Question: How many of the genes represented in this particular technology are on chromosome Y? 
A>
A>
A>
A>3.  What is the log expression value of the for gene ARPC1A
A>on the one subject that we measured on 2005-06-10 ?
A>
A>Answer:
A>
