---
layout: page
title: Smoothing
---



<a name="smoothing"></a>

## Smoothing 

Smoothing is a very powerful technique used all across data analsysis. The general idea is to group data points that are expected to have similar expectations and 

The following data are from measurements from replicated RNA. We consider that data used in an the MA-plot ( {$$}Y{/$$} = log ratios and {$$}A{/$$} = averages) and take down-sample in a way that balances the number of points for different strata of {$$}A{/$$}:


```r
library(Biobase)
##rafalib::install_bioc(c("SpikeIn","hgu95acdf")
library(SpikeIn)
library(hgu95acdf)
data(SpikeIn95)

##Example with two columns
i=10;j=9

##remove the spiked in genes and take random sample
siNames<-colnames(pData(SpikeIn95))
ind <- which(!probeNames(SpikeIn95)%in%siNames)
pms <- pm(SpikeIn95)[ ind ,c(i,j)]

##pick a representative sample for A and order A
Y=log2(pms[,1])-log2(pms[,2])
X=(log2(pms[,1])+log2(pms[,2]))/2
set.seed(4)
ind <- tapply(seq(along=X),round(X*5),function(i)
  if(length(i)>20) return(sample(i,20)) else return(NULL))
ind <- unlist(ind)
X <- X[ind]
Y <- Y[ind]
o <-order(X)
X <- X[o]
Y <- Y[o]
```
