---
title: "Association tests"
output: html_document
layout: page
---





## Association Tests

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course1/association_tests.Rmd).

The statistical tests we have covered up to now leave out a substantial portion of life science projects. Specifically, we are referring to data that is binary, categorical and ordinal. To give a very specific example, consider genetic data where you have two genotypes (AA/Aa or aa) for cases and controls for a given disease. The statistical question is if genotype and disease are associated. As in the examples we have been studying, we have two populations: AA/Aa and aa and numeric data for each. So why can't we perform a t-test? Note that the data is either 0 (control) or 1 (cases). It is pretty clear that this data is not normally distributed so the t-distribution approximation is certainly out of the question. We could use CLT if the sample size is large enough; otherwise we can use association tests.

### Lady Tasting Tea

One of the most famous examples of hypothesis testing was performed by R.A. Fisher. A person he knew claimed she could tell if milk was added before or after tea was poured. Fisher gave the lady four pairs of cups of tea: one with milk poured first, the other after. The order was randomized. Say the lady picked 3 out 4 correctly, do we believe she has a special ability? Hypothesis testing helps answer this question by quantifying what happens by chance.

The basic question we ask is: if the lady is actually guessing, what are the chances that she gets 3 or more correct? Just as we have done before we can compute a probability under the null hypothesis that she is guessing four of each. If we assume this null hypothesis, we can think of this particular examples as picking 4 balls out of an urn with 4 green (correct answer) and 4 red (incorrect answer) balls. 

Under the null hypothesis that the lady is simply guessing, each ball has the same chance of being picked. We can then use combinatorics to figure out the probability. The probability of picking 3 is {$$}{4 \choose 3} {4 \choose 1} / {8 \choose 4} = 16/70{/$$}. The probability of picking all correct is {$$}{4 \choose 4} {4 \choose 0}/{8 \choose 4}= 1/70{/$$}. Thus the chance of observing a 3 or something more extreme, under the null hypothesis, is 0.24. This is called a p-value. The procedure that produced this p-value is called Fisher's exact test and it uses the hypergeometric distribution.

### Two By Two Tables

The data from the experiment above can be summarized by a 2 by 2 table:


```r
tab <- matrix(c(3,1,1,3),2,2)
rownames(tab)<-c("Poured Before","Poured After")
colnames(tab)<-c("Guessed before","Guessed after")
tab
```

```
##               Guessed before Guessed after
## Poured Before              3             1
## Poured After               1             3
```

The function `fisher.test` performs the calculations above and can be obtained like this:


```r
fisher.test(tab,alternative="greater")
```

```
## 
## 	Fisher's Exact Test for Count Data
## 
## data:  tab
## p-value = 0.2429
## alternative hypothesis: true odds ratio is greater than 1
## 95 percent confidence interval:
##  0.3135693       Inf
## sample estimates:
## odds ratio 
##   6.408309
```

### Chi-square Test

Genome-wide association studies (GWAS) have become ubiquitous in Biology. One of the main statistical summaries used in these studies are Manhattan plots. The y-axis of a Manhattan plot typically represents the negative of log (base 10) of the p-values obtained for association tests applied at millions of single nucleotide polymorphisms (SNP). These p-values are obtained in a similar way to the test performed on the tea tasting lady. However, in that example the number of green and red balls is experimentally fixed and the number of answers given for each category is also fixed. Another way to say this is that the sum of the rows and the sum of the columns are fixed. This defines constraints on the possible ways we can fill the 2 by 2 table and also permits us to use the hypergeometric distribution. In general, this is not the case. Nonetheless, there is another approach, the Chi-squared test, which described below.

Imagine we have 280 individuals, some of them have a given disease and the rest do not. We observe that 20% of the individuals that are homozygous for the minor allele (aa) have the disease compared to 10% of the rest. Would we see this again if we picked another 220 individuals?

Let's create an dataset with these percentages:


```r
disease=factor(c(rep(0,180),rep(1,20),rep(0,40),rep(1,10)),
               labels=c("control","cases"))
genotype=factor(c(rep("AA/Aa",200),rep("aa",50)),
                levels=c("AA/Aa","aa"))
dat <- data.frame(disease, genotype)
dat <- dat[sample(nrow(dat)),] #shuffle them up
head(dat)
```

```
##     disease genotype
## 67  control    AA/Aa
## 93  control    AA/Aa
## 143 control    AA/Aa
## 225 control       aa
## 50  control    AA/Aa
## 221 control       aa
```

To create the appropriate two by two table, we will use the function `table`. This function tabulates the frequency of each level in a factor. For example:


```r
table(genotype)
```

```
## genotype
## AA/Aa    aa 
##   200    50
```

```r
table(disease)
```

```
## disease
## control   cases 
##     220      30
```

If you you feed the function two factors, it will tabulate all possible pairs and thus create the two by two table:


```r
tab <- table(genotype,disease)
tab
```

```
##         disease
## genotype control cases
##    AA/Aa     180    20
##    aa         40    10
```

Note that you can feed `table` {$$}n{/$$} factors and it will tabulate all {$$}n{/$$}-tables.

The typical statistics we use to summarize these results is the odds ratio (OR). We compute the odds of having the disease if you are an "aa": 10/40, the odds of having the disease if you are an "AA/Aa": 20/180, and take the ratio: {$$}(10/40) / (20/180){/$$} 


```r
(tab[2,2]/tab[2,1]) / (tab[1,2]/tab[1,1])
```

```
## [1] 2.25
```

To compute a p-value we don't use the OR directly. We instead assume that there is no association between genotype and disease, and then compute what we expect to see in each cell. Under the null hypothesis, the group with 200 individuals and the group with 50 individuals were each randomly assigned the disease with the same probability. If this is the case, then the probability of disease is:


```r
p=mean(disease=="cases")
p
```

```
## [1] 0.12
```

The expected table is therefore:


```r
expected <- rbind(c(1-p,p)*sum(genotype=="AA/Aa"),
                  c(1-p,p)*sum(genotype=="aa"))
dimnames(expected)<-dimnames(tab)
expected
```

```
##         disease
## genotype control cases
##    AA/Aa     176    24
##    aa         44     6
```

The Chi-square test uses an asymptotic result (similar to CLT) related to the sums of independent binary outcomes. Using this approximation, we can compute the probability of seeing a deviation from the expected table as big as the one we saw. The p-value for this table is: 


```r
chisq.test(tab)$p.value
```

```
## [1] 0.08857435
```

### Large Samples, Small p-values

As mentioned earlier, reporting only p-values is not an appropriate way to report the results of your experiment. Many genetic association studies seem to over emphasize p-values. They have large sample sizes and report impressively small p-values.  Yet when one looks closely at the results, we realize odds ratios are quite modest: barely bigger than 1.

There is not a one-to-one relationship between the odds ratio and the p-value. To demonstrate, we recalculate the p-value keeping all the proportions identical, but increasing the sample size by 10, which reduces the p-value substantially:


```r
tab<-tab*10
chisq.test(tab)$p.value
```

```
## [1] 1.219624e-09
```

### Confidence Intervals For The Odd Ratio

Computing confidence intervals for the OR is not mathematically straightforward. Unlike other statistics, for which we can derive useful approximations of their distributions, the OR is not only a ratio, but a ratio of ratios. Therefore there is no simple way of using, for example, the CLT.
 
One approach is to use the theory of generalized linear models which provides estimates of the log odds ratio, rather than the OR itself, that can be shown to be asymptotically normal. Here we provide R code without presenting the theoretical details (for further details please see [CITE]:
  

```r
fit <- glm(disease~genotype,family="binomial",data=dat)
coeftab<- summary(fit)$coef
coeftab
```

```
##               Estimate Std. Error   z value     Pr(>|z|)
## (Intercept) -2.1972246  0.2356828 -9.322803 1.133070e-20
## genotypeaa   0.8109302  0.4249074  1.908487 5.632834e-02
```

The second row of the table shown above gives you the estimate and SE of the log odds ratio. Mathematical theory tells us the this estimate is approximately normally distributed. We can therefore form a confidence interval and then exponentiate to provide a confidence interval for the OR.


```r
ci <- coeftab[2,1] + c(-2,2)*coeftab[2,2]
exp(ci)
```

```
## [1] 0.9618616 5.2632310
```

The confidence includes 1, which is consistent with the p-value being bigger than 0.05. Note that the p-value shown here is based on a different approximation to the one used by the Chi-square test, which is why they differ.
