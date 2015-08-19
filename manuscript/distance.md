---
layout: page
title: Distance lecture
---



# Distance, clustering and dimension reduction

## Introduction

Many of the analysis we perform with high-dimensional data relate directly or inderictly to distance. For example many clustering and machine learning techniques rely on being able to define distance using features or predictors. The concept of distance can be generalized from  physical distance. For example, we cluster animals into groups. When we do this, we put animals that are "close" in the same group:

<img src="images/animals.png" align="middle" width="300">

Any time we cluster individuals into separate groups we are, explicitely or implicitely computing a distance. 

to create _heatmaps_ a distance is computed explicitely. Heatmaps are widely used in genomics and other highthroughput fields:

<img src="images/Heatmap.png" align="middle" width="300">

[Image Source: Heatmap, Gaeddal, 01.28.2007](http://commons.wikimedia.org/wiki/File:Heatmap.png) 

In these plots the measurements, which are stored in a matrix, are represented with colors after the columns and rows have been clustered. 
Here we will learn the necessary mathematics and computing skill to understand and create heatmaps. We start by reviewing the mathematical definition of distance. 


## Euclidean Distance

As a review, let's define the distance between two points, {$$}A{/$$} and {$$}B{/$$}, on a cartesian plane.

![plot of chunk unnamed-chunk-1](images/distance-unnamed-chunk-1-1.png) 

The euclidean distance between {$$}A{/$$} and {$$}B{/$$} is simply

{$$}\sqrt{ (A_x-B_x)^2 + (A_y-B_y)^2}{/$$}


## Distance in high dimensions

We introduce a data set with gene expression measurements for 22,215 genes from 189 samples. The R ojects can be downloaded like this:


```r
library(devtools)
install_github("genomicsclass/tissuesGeneExpression")
```

The data represent RNA expression levels for eight tissues, each with several individuals.


```r
library(tissuesGeneExpression)
data(tissuesGeneExpression)
dim(e) ##e contains the expression data
```

```
## [1] 22215   189
```

```r
table(tissue) ## tissue[i] tells us what tissue is represented by e[,i]
```

```
## tissue
##  cerebellum       colon endometrium hippocampus      kidney       liver 
##          38          34          15          31          39          26 
##    placenta 
##           6
```

We are interested in describing distance between samples in the context of this dataset. We might also be interested in finding genes that _behave similarly_ across samples.

To define distance we need to know what points are since mathematical distance is computed between points. With high dimensional data, points are no longer on the cartesian plan. Instead they are in higher dimensions. For example, sample {$$}i{/$$} is defined by a point in 22,215 dimesional space: {$$}(Y_{1,i},\dots,Y_{22215,i})'{/$$}. Feature {$$}g{/$$} is defined by a point in 189 dimensions {$$}(Y_{g,189},\dots,Y_{g,189})'{/$$}

Once we define points, the Euclidean distance is defined in a very similar way as it is defined for two dimensions. For example, the  distance between two samples {$$}i{/$$} and {$$}j{/$$} is

{$$}
d(i,j) = \sqrt{ \sum_{g=1}^{22215} (Y_{g,i}-Y_{g,j })^2 }
{/$$}

and the distance between two features {$$}h{/$$} and {$$}g{/$$} as:
{$$}
d(h,g) = \sqrt{ \sum_{i=1}^{189} (Y_{h,i}-Y_{g,i})^2 }
{/$$}

