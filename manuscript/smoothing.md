---
layout: page
title: Smoothing
---



<a name="smoothing"></a>

## Smoothing 

The R markdown document for this section is available [here](https://github.com/genomicsclass/labs/tree/master/ml/smoothing.Rmd).

Smoothing is a very powerful technique used all across data analysis. It is designed to estimate {$$}f(x){/$$} when the shape is unkown but assumed to be _smooth_.  The general idea is to group data points that are expected to have similar expectations and compute the average or fit a simple parametric model. We illustrate two smoothing techniques using a gene expression example.

The following data are gene expression measurements from replicated RNA samples. 



```r
##Following three packages are available from Bioconductor
library(Biobase)
library(SpikeIn)
library(hgu95acdf)
data(SpikeIn95)
```

We consider the data used in an MA-plot comparing two replicated samples ( {$$}Y{/$$} = log ratios and {$$}X{/$$} = averages) and take down-sample in a way that balances the number of points for different strata of {$$}X{/$$} (code not shown):


```
## Error in is.data.frame(x): could not find function "pData"
```

```
## Error in match(x, table, nomatch = 0L): could not find function "probeNames"
```

```
## Error in eval(expr, envir, enclos): could not find function "pm"
```

```
## Error in eval(expr, envir, enclos): object 'pms' not found
```

```
## Error in eval(expr, envir, enclos): object 'pms' not found
```

```
## Error in tapply(seq(along = X), round(X * 5), function(i) if (length(i) > : object 'X' not found
```

```
## Error in unlist(ind): object 'ind' not found
```

```
## Error in eval(expr, envir, enclos): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'Y' not found
```

```
## Error in order(X): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'Y' not found
```



```r
library(rafalib)
mypar()
plot(X,Y)
```

```
## Error in plot(X, Y): object 'X' not found
```

In the MA plot we see that {$$}Y{/$$} depends on {$$}X{/$$}. This dependence must be a bias because these are based on replicates which means {$$}Y{/$$} should be 0 on average regardless of {$$}X{/$$}. We want to predict {$$}f(x)=\mbox{E}(Y \mid X=x){/$$} so that we can remove this bias. Linear regression does not capture the apparent curvature in {$$}f(x){/$$}:


```r
mypar()
plot(X,Y)
```

```
## Error in plot(X, Y): object 'X' not found
```

```r
fit <- lm(Y~X)
```

```
## Error in eval(expr, envir, enclos): object 'Y' not found
```

```r
points(X,Y,pch=21,bg=ifelse(Y>fit$fitted,1,3))
```

```
## Error in points(X, Y, pch = 21, bg = ifelse(Y > fit$fitted, 1, 3)): object 'X' not found
```

```r
abline(fit,col=2,lwd=4,lty=2)
```

```
## Error in abline(fit, col = 2, lwd = 4, lty = 2): object 'fit' not found
```

Note that the points above the fitted line (green) and those below (purple) are not evenly distributed. We need an alternative more flexible approach.

## Bin Smoothing

The R markdown document for this section is available [here](https://github.com/genomicsclass/labs/tree/master/ml/smoothing.Rmd).

Instead of fitting a line, let's go back to the idea of stratifying and computing the mean. This is referred to as _bin smoothing_. The general idea is that the underlying curve is "smooth" enough so that in small bins the curve is approximately constant. If we assume the curve is constant, then all the {$$}Y{/$$} in that bin have the same expected value. For example, in the plot below we highlight points in a bin centered at 8.6 as well as the points of a bin centered at 12.1 if we use bins of size 1. We also show and the fitted mean values for the {$$}Y{/$$} in those bin  with dashed lines (code not shown):


```
## Error in seq(min(X), max(X), 0.1): object 'X' not found
```

```
## Error in plot(X, Y, col = "grey", pch = 16): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'centers' not found
```

```
## Error in which(X > center - windowSize & X < center + windowSize): object 'X' not found
```

```
## Error in mean(Y): object 'Y' not found
```

```
## Error in points(X[ind], Y[ind], bg = 3, pch = 21): object 'X' not found
```

```
## Error in lines(c(min(X[ind]), max(X[ind])), c(fit, fit), col = 2, lty = 2, : object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'centers' not found
```

```
## Error in which(X > center - windowSize & X < center + windowSize): object 'X' not found
```

```
## Error in mean(Y[ind]): object 'Y' not found
```

```
## Error in points(X[ind], Y[ind], bg = 3, pch = 21): object 'X' not found
```

```
## Error in lines(c(min(X[ind]), max(X[ind])), c(fit, fit), col = 2, lty = 2, : object 'X' not found
```

By computing this mean for bins around every point we form an estimate of the underlying curve {$$}f(x){/$$}. Below we show the procedure happening as we move from the smallest value of {$$}x{/$$} to the largets. We show 10 intermediate cases as well (code not shown):


```
## Error in eval(expr, envir, enclos): object 'centers' not found
```

```
## Error in seq(along = centers): object 'centers' not found
```

The final result looks like this (code not shown):


```
## Error in plot(X, Y, col = "darkgrey", pch = 16): object 'X' not found
```

```
## Error in lines(centers, smooth, col = "black", lwd = 3): object 'centers' not found
```

There are several function in R that implement bin smoothers. One example is `ksmooth`. However, in practice we typically prefer methods that use slightly more complicated models than fitting a constant. Note, for example, that the final result above is somewhat wiggly. Methods such as `loess`, which we explain next, improve on this.

## Loess

The R markdown document for this section is available [here](https://github.com/genomicsclass/labs/tree/master/ml/smoothing.Rmd).
 
Local weighted regression (loess) is similar to bin smoothing in principle. The main difference is that we approximate the local behavior with a line or a parabola. This permits us to expand the bin sizes which stabilizes the estimates. Below we see lines fitted to two bins that are slightly larger than those we used for the bin smoother (code not shown). We can use larger bins because fitting lines provide slighly more flexibility.



```
## Error in seq(min(X), max(X), 0.1): object 'X' not found
```

```
## Error in plot(X, Y, col = "darkgrey", pch = 16): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'centers' not found
```

```
## Error in which(X > center - windowSize & X < center + windowSize): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'Y' not found
```

```
## Error in points(X[ind], Y[ind], bg = 3, pch = 21): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'X' not found
```

```
## Error in lines(c(a, b), fit$coef[1] + fit$coef[2] * c(a, b), col = 2, : object 'a' not found
```

```
## Error in eval(expr, envir, enclos): object 'centers' not found
```

```
## Error in which(X > center - windowSize & X < center + windowSize): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'Y' not found
```

```
## Error in points(X[ind], Y[ind], bg = 3, pch = 21): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'X' not found
```

```
## Error in eval(expr, envir, enclos): object 'X' not found
```

```
## Error in lines(c(a, b), fit$coef[1] + fit$coef[2] * c(a, b), col = 2, : object 'a' not found
```

As we did for the bin smoother, we show 12 steps of the process that leads to a loess fit (code not shown):


```
## Error in eval(expr, envir, enclos): object 'centers' not found
```

```
## Error in seq(along = centers): object 'centers' not found
```

This final results in a smoother fit since we use larger sample sizes to estimate our local parameters (code not shown):


```
## Error in plot(X, Y, col = "darkgrey", pch = 16): object 'X' not found
```

```
## Error in lines(centers, smooth, col = "black", lwd = 3): object 'centers' not found
```

Note that the function `loess` performs this analysis for us:


```r
fit <- loess(Y~X, degree=1, span=1/3)
```

```
## Error in eval(expr, envir, enclos): object 'Y' not found
```

```r
newx <- seq(min(X),max(X),len=100) 
```

```
## Error in seq(min(X), max(X), len = 100): object 'X' not found
```

```r
smooth <- predict(fit,newdata=data.frame(X=newx))
```

```
## Error in predict(fit, newdata = data.frame(X = newx)): object 'fit' not found
```

```r
mypar ()
plot(X,Y,col="darkgrey",pch=16)
```

```
## Error in plot(X, Y, col = "darkgrey", pch = 16): object 'X' not found
```

```r
lines(newx,smooth,col="black",lwd=3)
```

```
## Error in lines(newx, smooth, col = "black", lwd = 3): object 'newx' not found
```

There are three other important differences between `loess` and the typical bin smoother. The first  is that rather than keeping the bin size the same, `loess` keeps the number of points used in the local fit the same. This number is controlled via the `span` argument which expects a proportion. For example if `N` is the number of data points and `span=0.5` then for a given {$$}x{/$$} `loess` will use the `0.5*N` closest points to {$$}x{/$$} for the fit. The second difference is that, when fitting the parametric model to obtain {$$}f(x){/$$}, `loess` uses weighted least squares, with higher weights for points that are closer to {$$}x{/$$}. The third difference is that `loess` has the option of fitting the local model robustely. An iterative algorithm is implemented in which after fitting a model in one iteration, outliers are detected and downweighted for the next iteration. To use this option we use the argument `family="symmetric"`.





