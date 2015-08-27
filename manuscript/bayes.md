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

Suppose we select random person and they test postive, what is the probability that they have the disease?  We write this as {$$}\mbox{Prob}(D=1 \mid +)?{/$$}. The  cystic fibrosis rate is 1 in 3,900 which implies that  {$$}\mbox{Prob}(D)=0.0025{/$$}. To answer this question we will use Bayes Theorem, which in general  tells us that

{$$}
\mbox{Pr}(A \mid B)  =  \frac{\mbox{Pr}(B \mid A)\mbox{Pr}(A)}{\mbox{Pr}(B)} 
{/$$}

This equation applied to our problem becomes:

{$$}
\begin{align*}
\mbox{Prob}(D=1 \mid +) & =  \frac{ P(+ \mid D=1) \cdot P(D=1)} {\mbox{Prob}(+)} \\
& =  \frac{\mbox{Prob}(+ \mid D=0)\cdot P(D)} {\mbox{Prob}(+ \mid D) \cdot P(D) + \mbox{Prob}(+ \mid D=1) \mbox{Prob}( D=0)} 
\end{align*}
{/$$}

