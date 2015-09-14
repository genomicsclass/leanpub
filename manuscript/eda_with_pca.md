---
layout: page
title: Discovering Batch Effects with EDA 
---




##  Discovering Batch Effects with EDA 

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course3/eda_with_pca.Rmd).
Now that we understand PCA, we are going to demonstrate how we use it in practice with an emphasis on exploratory data analysis. To illustrate we will go through an actual dataset that has not be sanitized for teaching purposes. We start with the raw data as it was provided in the public repository. The only step we did for you is to preprocess these data and create an R package with a preformed Bioconductor object.

## Gene Expression Data

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course3/eda_with_pca.Rmd).

Start by loading the data:

```r
library(rafalib)
library(Biobase)
library(GSE5859)
```

```
## Error in library(GSE5859): there is no package called 'GSE5859'
```

```r
data(GSE5859)
```

```
## Warning in data(GSE5859): data set 'GSE5859' not found
```

We start by exploring the sample correlation matrix and noting that one pair has a correlation of 1. This must mean that the same sample was uploaded twice to the public repository, but given different names. The following code identifies this sample and removes it.

```r
cors <- cor(exprs(e))
```

```
## Error in exprs(e): error in evaluating the argument 'object' in selecting a method for function 'exprs': Error: object 'e' not found
```

```r
Pairs=which(abs(cors)>0.9999,arr.ind=TRUE)
```

```
## Error in which(abs(cors) > 0.9999, arr.ind = TRUE): object 'cors' not found
```

```r
out = Pairs[which(Pairs[,1]<Pairs[,2]),,drop=FALSE]
```

```
## Error in eval(expr, envir, enclos): object 'Pairs' not found
```

```r
if(length(out[,2])>0) e=e[,-out[2]]
```

```
## Error in eval(expr, envir, enclos): object 'out' not found
```

We also remove control probes from the analysis:


```r
out <- grep("AFFX",featureNames(e))
```

```
## Error in featureNames(e): error in evaluating the argument 'object' in selecting a method for function 'featureNames': Error: object 'e' not found
```

```r
e <- e[-out,]
```

```
## Error in eval(expr, envir, enclos): object 'e' not found
```


Now we are ready to proceed. We will create a detrended gene expression data matrix and extract the dates and outcome of interest from the sample annotation table. 

```r
y <- exprs(e)-rowMeans(exprs(e))
```

```
## Error in exprs(e): error in evaluating the argument 'object' in selecting a method for function 'exprs': Error: object 'e' not found
```

```r
dates <- pData(e)$date
```

```
## Error in pData(e): error in evaluating the argument 'object' in selecting a method for function 'pData': Error: object 'e' not found
```

```r
eth <- pData(e)$ethnicity
```

```
## Error in pData(e): error in evaluating the argument 'object' in selecting a method for function 'pData': Error: object 'e' not found
```

The original dataset did not include sex in the sample information. We did this for you in the subset dataset we provided for illustrative purposes. In the code below we show how we predict the sex of each sample. The basic idea is to look at the median gene expression levels on Y chromosome genes. Males should have much higher values. We need to upload an annotation package that provides information for the features of the platform used in this experiment:


```r
annotation(e)
```

```
## Error in annotation(e): error in evaluating the argument 'object' in selecting a method for function 'annotation': Error: object 'e' not found
```

We need to download and install the `hgfocus.db` package and then extract the chromosome location information.


```r
library(hgfocus.db)
```

```
## Warning: package 'S4Vectors' was built under R version 3.2.2
```

```r
annot <- select(hgfocus.db, keys=featureNames(e), keytype="PROBEID",columns=c("CHR"))
```

```
## Error in featureNames(e): error in evaluating the argument 'object' in selecting a method for function 'featureNames': Error: object 'e' not found
```

```r
##for genes with multiples, pick on
annot <-annot[match(featureNames(e),annot$PROBEID),]
```

```
## Error in eval(expr, envir, enclos): object 'annot' not found
```

```r
annot$CHR <- ifelse(is.na(annot$CHR),NA,paste0("chr",annot$CHR))
```

```
## Error in ifelse(is.na(annot$CHR), NA, paste0("chr", annot$CHR)): error in evaluating the argument 'test' in selecting a method for function 'ifelse': Error: object 'annot' not found
```

```r
chryexp<- colMeans(y[which(annot$CHR=="chrY"),])
```

```
## Error in is.data.frame(x): object 'y' not found
```

You can clearly see two modes which must be females and males:

```r
mypar()
hist(chryexp)
```

```
## Error in hist(chryexp): object 'chryexp' not found
```

So we can predict sex this way:

```r
sex <- factor(ifelse(chryexp<0,"F","M"))
```

```
## Error in ifelse(chryexp < 0, "F", "M"): error in evaluating the argument 'test' in selecting a method for function 'ifelse': Error: object 'chryexp' not found
```

#### Calculating the PCs

We have shown how we can compute principal components using: 


```r
s <- svd(y)
```

```
## Error in as.matrix(x): object 'y' not found
```

```r
dim(s$v)
```

```
## Error in eval(expr, envir, enclos): object 's' not found
```

But we can also use `prcomp` which creates an object with just the PCs and also demeans by default. Note `svd` keeps {$$}U{/$$} which is as large as `y` while `prcomp` does not. However, they provide practically the same principal components:



```r
pc <- prcomp(y)
```

```
## Error in prcomp(y): object 'y' not found
```

```r
for(i in 1:5) print( round( cor( pc$rotation[,i],s$v[,i]),3))
```

```
## Error in cor(pc$rotation[, i], s$v[, i]): error in evaluating the argument 'x' in selecting a method for function 'cor': Error in pc$rotation : object of type 'closure' is not subsettable
```

For the rest of the code shown here we use `s`.

#### Variance Explained

A first step in determining how much sample correlation induced_structure_ there is in the data. 


```r
library(RColorBrewer)
cols=colorRampPalette(rev(brewer.pal(11,"RdBu")))(100)
image ( cor(y) ,col=cols,zlim=c(-1,1))
```

```
## Error in image(cor(y), col = cols, zlim = c(-1, 1)): error in evaluating the argument 'x' in selecting a method for function 'image': Error in cor(y) : 
##   error in evaluating the argument 'x' in selecting a method for function 'cor': Error: object 'y' not found
```

Here we are using the term _structure_ to refer to the deviation from what one would see if the samples were in fact independent from each other. 

One simple exploratory plot we make to determine how many principal components we need to describe this _structure_ is the variance-explained plot. This is what the variance explained for the PCs would look like:


```r
y0 <- matrix( rnorm( nrow(y)*ncol(y) ) , nrow(y), ncol(y) )
```

```
## Error in nrow(y): error in evaluating the argument 'x' in selecting a method for function 'nrow': Error: object 'y' not found
```

```r
d0 <- svd(y0)$d
```

```
## Error in as.matrix(x): object 'y0' not found
```

```r
plot(d0^2/sum(d0^2),ylim=c(0,.25))
```

```
## Error in plot(d0^2/sum(d0^2), ylim = c(0, 0.25)): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'd0' not found
```

Instead we see this:


```r
plot(s$d^2/sum(s$d^2))
```

```
## Error in plot(s$d^2/sum(s$d^2)): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 's' not found
```

At least 20 or so PCs appear to be higher than what we would expect with independent data. A next step is to try to explain these PCs with measured variables. Is this driven by ethnicity? Sex? Date? Or something else?

#### MDS plot

As previously shown, we can make MDS plots to start exploring the data to answer these questions. One way to explore the relationship
between variables of interest and PCs is to use color to denote these variables. For example, here are the first two PCs with color representing ethnicity:



```r
cols = as.numeric(eth)
```

```
## Error in eval(expr, envir, enclos): object 'eth' not found
```

```r
mypar()
plot(s$v[,1],s$v[,2],col=cols,pch=16,
     xlab="PC1",ylab="PC2")
```

```
## Error in plot(s$v[, 1], s$v[, 2], col = cols, pch = 16, xlab = "PC1", : error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 's' not found
```

```r
legend("bottomleft",levels(eth),col=seq(along=levels(eth)),pch=16)
```

```
## Error in levels(eth): error in evaluating the argument 'x' in selecting a method for function 'levels': Error: object 'eth' not found
```

There is a very clear association between the first PC and ethnicity. However, we also see that for the orange points there are sub-clusters. We know from previous analyses that ethnicity and preprocessing date are correlated:



```r
year = factor(format(dates,"%y"))
```

```
## Error in format(dates, "%y"): object 'dates' not found
```

```r
table(year,eth)
```

```
## Error in eval(expr, envir, enclos): object 'year' not found
```

Here is the same plot, but now with color representing year:


```r
cols = as.numeric(year)
```

```
## Error in eval(expr, envir, enclos): object 'year' not found
```

```r
mypar()
plot(s$v[,1],s$v[,2],col=cols,pch=16,
     xlab="PC1",ylab="PC2")
```

```
## Error in plot(s$v[, 1], s$v[, 2], col = cols, pch = 16, xlab = "PC1", : error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 's' not found
```

```r
legend("bottomleft",levels(year),col=seq(along=levels(year)),pch=16)
```

```
## Error in levels(year): error in evaluating the argument 'x' in selecting a method for function 'levels': Error: object 'year' not found
```

Year is also very correlated with the first PC. So which variable is driving this? Given the high level of confounding, it is not easy to parse out. Nonetheless, in the assessment questions and below we provide some further exploratory approaches.

#### Boxplot of PCs

The structure seen in the plot of the between sample correlations shows a complex structure that seems to have more than 5 factors (one for each year). It certainly has more complexity than what would be explained by ethnicity. We can also explore the correlation with months. 


```r
month <- format(dates,"%y%m")
```

```
## Error in format(dates, "%y%m"): object 'dates' not found
```

```r
length( unique(month))
```

```
## Error in unique(month): error in evaluating the argument 'x' in selecting a method for function 'unique': Error: object 'month' not found
```

Because there are so many months (21), it becomes complicated to use color. Instead we can stratify by month and look at boxplots of our PCs:



```r
variable <- as.numeric(month)
```

```
## Error in eval(expr, envir, enclos): object 'month' not found
```

```r
mypar(2,2)
for(i in 1:4){
  boxplot(split(s$v[,i],variable),las=2,range=0)
  stripchart(split(s$v[,i],variable),add=TRUE,vertical=TRUE,pch=1,cex=.5,col=1)
  }
```

```
## Error in boxplot(split(s$v[, i], variable), las = 2, range = 0): error in evaluating the argument 'x' in selecting a method for function 'boxplot': Error in split(s$v[, i], variable) : 
##   error in evaluating the argument 'x' in selecting a method for function 'split': Error: object 's' not found
```

Here we see that month has a very strong correlation with the first PC, as well as some of the others. In cases such as these, in which we have many samples, we can use an analysis of variance to see which PCs correlate with month:


```r
corr <- sapply(1:ncol(s$v),function(i){
  fit <- lm(s$v[,i]~as.factor(month))
  return( summary(fit)$adj.r.squared  )
  })
```

```
## Error in sapply(1:ncol(s$v), function(i) {: error in evaluating the argument 'X' in selecting a method for function 'sapply': Error in ncol(s$v) : 
##   error in evaluating the argument 'x' in selecting a method for function 'ncol': Error: object 's' not found
```

```r
mypar()
plot(seq(along=corr), corr, xlab="PC")
```

```
## Error in plot(seq(along = corr), corr, xlab = "PC"): error in evaluating the argument 'x' in selecting a method for function 'plot': Error in seq(along = corr) : object 'corr' not found
```

We see a very strong correlation with the first PC and relatively strong correlations for the first 20 or so PCs.
We can also compute F-statistics comparing within month to across month variability:


```r
Fstats<- sapply(1:ncol(s$v),function(i){
   fit <- lm(s$v[,i]~as.factor(month))
   Fstat <- summary(aov(fit))[[1]][1,4]
   return(Fstat)
  })
```

```
## Error in sapply(1:ncol(s$v), function(i) {: error in evaluating the argument 'X' in selecting a method for function 'sapply': Error in ncol(s$v) : 
##   error in evaluating the argument 'x' in selecting a method for function 'ncol': Error: object 's' not found
```

```r
mypar()
plot(seq(along=Fstats),sqrt(Fstats))
```

```
## Error in plot(seq(along = Fstats), sqrt(Fstats)): error in evaluating the argument 'x' in selecting a method for function 'plot': Error in seq(along = Fstats) : object 'Fstats' not found
```

```r
p <- length(unique(month))
```

```
## Error in unique(month): error in evaluating the argument 'x' in selecting a method for function 'unique': Error: object 'month' not found
```

```r
abline(h=sqrt(qf(0.995,p-1,ncol(s$v)-1)))
```

```
## Error in qf(0.995, p - 1, ncol(s$v) - 1): object 'p' not found
```

In the assessments we will see how we can use the PCs as estimates in factor analysis to improve model estimates.



