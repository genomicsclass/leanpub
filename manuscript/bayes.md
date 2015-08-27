---
layout: page
title: Bayesian Statistics
---




## Bayesian Statistics

One distinguishing characteristic of high-throuhgput data is that we make many measure of related outcomes. For example, we measure the expression of thousands of genes, or the height of thousands of peaks represneting protein binding, or the methyaltion levels across several CpGs. However, most of the statistical inference approach we have shown here treat each feature independently and pretty much ignores data from other features. We will learn how using statistical models we can gain power by modeling features jointly. The most succsefull of these models are what we refer to as hiearchical models which are best explained in the context of Bayesian statistics.

### Bayes theorem

We start by reviewing Bayes theorem. We do this using a hypothetical Cystic Fibrosis test as an example. Suppose a test for cystic fibrosis has an accuracy of 99%. We will use the following notation:

{$$}
\mbox{Prob}(+ \mid D=1)=0.99, \mbox{Prob}(- \mid D=0)=0.99 
{/$$}

with {$$}+{/$$} meaning a positive test and {$$}D{/$$} representing if you actually have (1) the disease or not (0).
