---
layout: page
title: Hierarchical Models
---



## Hierarchical Models

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course3/hierarchical_models.Rmd).

In this section we use the mathematical theory which describes an approach that has become widely applied in the analysis of high-throughput data. The general idea is to build a _hierachichal model_ with two levels. One level describes variability across samples/units, and the other describes variability across features. The first level of variation is accounted for by all the models and approaches we have described here, for example the model that leads to the t-test. The second level provides power by permitting us to "borrow" information from all features to inform the inference performed on each one. 

Here we describe one specific case that is currently the most widely used approach to inference with gene expression data. It is the model implemented by the `limma` Bioconductor package. This idea has been adapted to develop methods for other data types such as RNAseq CITE.
This package provides an alternative to the t-test that greatly improves power by modeling the variance. We motivate and demonstrate the approach with an example.

Here is a volcano showing effect sizes and p-value from applying a t-test to data from an experiment running six replicated samples with 16 genes artificially made to be different in two groups of three genes. These genes are the only genes for which the null hypothesis is true. In the plot they are shown in blue.


```r
library(SpikeInSubset) ##Available from Bioconductor
```

```
## Error in library(SpikeInSubset): there is no package called 'SpikeInSubset'
```

```r
data(rma95)
```

```
## Warning in data(rma95): data set 'rma95' not found
```

```r
library(genefilter)
fac <- factor(rep(1:2,each=3))
tt <- rowttests(exprs(rma95),fac)
```

```
## Error in rowttests(exprs(rma95), fac): error in evaluating the argument 'x' in selecting a method for function 'rowttests': Error: could not find function "exprs"
```

```r
smallp <- with(tt, p.value < .01)
```

```
## Error in with(tt, p.value < 0.01): object 'tt' not found
```

```r
spike <- rownames(rma95) %in% colnames(pData(rma95))
```

```
## Error in rownames(rma95): object 'rma95' not found
```

```r
cols <- ifelse(spike,"dodgerblue",ifelse(smallp,"red","black"))
```

```
## Error in ifelse(spike, "dodgerblue", ifelse(smallp, "red", "black")): object 'spike' not found
```

```r
with(tt, plot(-dm, -log10(p.value), cex=.8, pch=16,
     xlim=c(-1,1), ylim=c(0,4.5),
     xlab="difference in means",
     col=cols))
```

```
## Error in with(tt, plot(-dm, -log10(p.value), cex = 0.8, pch = 16, xlim = c(-1, : object 'tt' not found
```

```r
abline(h=2,v=c(-.2,.2), lty=2)
```

```
## Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...): plot.new has not been called yet
```

We cut-off the range of the y-axis at 4.5, but there is one blue point with a p-value smaller than {$$}10^{-6}{/$$}. Two findings stand out from this plot. The first is that only one of the positives would be found to be significant with a standard 5% FDR cutoff:


```r
sum( p.adjust(tt$p.value,method = "BH")[spike] < 0.05)
```

```
## Error in p.adjust(tt$p.value, method = "BH"): object 'tt' not found
```

This of course has to do with the low power associated with a sample size of three in each group. The second finding is that if we forget about inference and simply rank the genes based on p-value, we obtain many false positives. For example, six of the smallest 10 p-values are false positives. 


```r
table( top50=rank(tt$p.value)<= 10, spike) 
```

```
## Error in rank(tt$p.value): object 'tt' not found
```

In the plot we notice that these are mostly genes for which the effect size is relatively small, implying that the estimated standard error is small. We can confirm this with a plot:


```r
tt$s <- apply(exprs(rma95), 1, function(row) sqrt(.5 * (var(row[1:3]) + var(row[4:6]))))
```

```
## Error in apply(exprs(rma95), 1, function(row) sqrt(0.5 * (var(row[1:3]) + : could not find function "exprs"
```

```r
with(tt, plot(s, -log10(p.value), cex=.8, pch=16,
              log="x",xlab="estimate of standard deviation",
              col=cols))
```

```
## Error in with(tt, plot(s, -log10(p.value), cex = 0.8, pch = 16, log = "x", : object 'tt' not found
```

Here is where a hierarchical model can be useful. If we can make an assumption about the distribution of these variances across genes, then we can improve estimates by "adjusting" estimates that are "too small" according to this distribution. In a previous section we described how the F-distribution provides approximates the distribution of the observed variances.

{$$}
s^2 \sim s_0^2 F_{d,d_0}
{/$$}

Because we have thousands of data points, we can actually check this assumption and also estimate the parameters {$$}s_0{/$$} and {$$}d_0{/$$}. This particular approach is referred to as empirical Bayes because it can be described as using data (empirical) to build the prior distribution (Bayesian approach). 

Now we apply what we learned with the baseball example to the standard error estimates. As before we have an observed value for each gene {$$}s_g{/$$}, a sampling distribution as a prior distribution. We can therefore compute a posterior distribution for the variance {$$}\sigma^2_g{/$$} and obtain the posterior mean. You can see the details of the derivation [CITE Smyth 2004]

{$$}
\mbox{E}[\sigma^2_g \mid s_g] = \frac{d_0 s_0^2 + d s^2_g}{d_0 + d}
{/$$}

As before, the posterior mean _shrinks_ the observed variance {$$}s_g^2{/$$} towards the global variance {$$}s_0^2{/$$} and the weights depend on the sample size through the degrees of freedom {$$}d{/$$} and, in this case, the shape of the prior distribution through {$$}d_0{/$$}. 

In the plot above we can see how the variance estimate _shrink_ for 40 genes:



```r
library(limma)
fit <- lmFit(rma95, model.matrix(~ fac))
```

```
## Error in is(object, "list"): object 'rma95' not found
```

```r
ebfit <- ebayes(fit)
```

```
## Error in ebayes(fit): object 'fit' not found
```

```r
n <- 40
qs <- seq(from=0,to=.2,length=n)
idx <- sapply(seq_len(n),function(i) which(as.integer(cut(tt$s^2,qs)) == i)[1])
```

```
## Error in cut(tt$s^2, qs): object 'tt' not found
```

```r
idx <- idx[!is.na(idx)]
```

```
## Error in eval(expr, envir, enclos): object 'idx' not found
```

```r
par(mar=c(5,5,2,2))
plot(1,1,xlim=c(0,.21),ylim=c(0,1),type="n",
     xlab="variance estimates",ylab="",yaxt="n")
axis(2,at=c(.1,.9),c("before","after"),las=2)
```

![Illustration of how estimates shrink towards the prior expectation. Forty genes spanning the range of values were selected.](images/R/hierarchical_models-tmp-shrinkage-1.png) 

```r
segments((tt$s^2)[idx],rep(.1,n),
         ebfit$s2.post[idx],rep(.9,n))
```

```
## Error in segments((tt$s^2)[idx], rep(0.1, n), ebfit$s2.post[idx], rep(0.9, : object 'tt' not found
```

An important aspect of this adjustment is that genes having a very small sample deviation close to 0 are no longer close to 0. We can now create a version of the t-test that instead of the sample standard deviation uses this posterior mean or "shrunken" estimate of the variance. We refer to these as _moderated_ t-tests. Once we do this, the improvements can be seen clearly in the volcano plot:


```r
limmares <- data.frame(dm=coef(fit)[,"fac2"], p.value=ebfit$p.value[,"fac2"])
```

```
## Error in coef(fit): object 'fit' not found
```

```r
with(limmares, plot(dm, -log10(p.value),cex=.8, pch=16,
     col=cols,xlab="difference in means",
     xlim=c(-1,1), ylim=c(0,5)))
```

```
## Error in with(limmares, plot(dm, -log10(p.value), cex = 0.8, pch = 16, : object 'limmares' not found
```

```r
abline(h=2,v=c(-.2,.2), lty=2)
```

```
## Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...): plot.new has not been called yet
```

The number of false positives in the top 10 is now reduced to 2. 


```r
table( top50=rank(limmares$p.value)<= 10, spike) 
```

```
## Error in rank(limmares$p.value): object 'limmares' not found
```
