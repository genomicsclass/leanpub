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

