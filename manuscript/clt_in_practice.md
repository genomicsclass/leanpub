---
title: "Central Limit Theorem in Practice"
layout: page
---






## Central Limit Theorem in Practice

The R markdown document for this section is available [here](https://github.com/genomicsclass/labs/tree/master/inference/clt_in_practice.Rmd).

Let's use our data to see how well the central limit theorem approximates sample averages from our data. We will leverage our entire population dataset to compare the results we obtain by actually sampling from the distribution to what the CLT predicts.


```
## Warning in download.file(url, method = method, ...): download had nonzero
## exit status
```


```r
dat <- read.csv("mice_pheno.csv") #file was previously downloaded
```

```
## Error in read.table(file = file, header = header, sep = sep, quote = quote, : no lines available in input
```

```r
head(dat)
```

```
## Error in head(dat): object 'dat' not found
```

Start by selecting only female mice since males and females have
different weights. We will select three mice from each population.


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
controlPopulation <- filter(dat,Sex == "F" & Diet == "chow") %>%  
  select(Bodyweight) %>% unlist
```

```
## Error in filter_(.data, .dots = lazyeval::lazy_dots(...)): object 'dat' not found
```

```r
hfPopulation <- filter(dat,Sex == "F" & Diet == "hf") %>%  
  select(Bodyweight) %>% unlist
```

```
## Error in filter_(.data, .dots = lazyeval::lazy_dots(...)): object 'dat' not found
```

We can compute the population parameters of interest using the mean function.


```r
mu_hf <- mean(hfPopulation)
```

```
## Error in mean(hfPopulation): object 'hfPopulation' not found
```

```r
mu_control <- mean(controlPopulation)
```

```
## Error in mean(controlPopulation): object 'controlPopulation' not found
```

```r
print(mu_hf - mu_control)
```

```
## Error in print(mu_hf - mu_control): object 'mu_hf' not found
```

Compute the population standard deviations as well. We do not use the
R function `sd` because this would compute the estimates that divide by the
sample size - 1, and we want the population estimates.

We can see that with R code:


```r
x <- controlPopulation
```

```
## Error in eval(expr, envir, enclos): object 'controlPopulation' not found
```

```r
N <- length(x)
```

```
## Error in eval(expr, envir, enclos): object 'x' not found
```

```r
populationvar <- mean((x-mean(x))^2)
```

```
## Error in mean((x - mean(x))^2): object 'x' not found
```

```r
identical(var(x), populationvar)
```

```
## Error in is.data.frame(x): object 'x' not found
```

```r
identical(var(x)*(N-1)/N, populationvar)
```

```
## Error in is.data.frame(x): object 'x' not found
```

So to be mathematically correct we do not use `sd` or  `var`. Instead we use the `popvar` and `popsd` function in `rafalib`:


```r
library(rafalib)
sd_hf <- popsd(hfPopulation)
```

```
## Error in is.vector(x): object 'hfPopulation' not found
```

```r
sd_control <- popsd(controlPopulation)
```

```
## Error in is.vector(x): object 'controlPopulation' not found
```

Remember that in practice we do not get to compute these population parameters.
These are values we never see. In general, we want to estimate them from samples. 


```r
N <- 12
hf <- sample(hfPopulation, 12)
```

```
## Error in sample(hfPopulation, 12): object 'hfPopulation' not found
```

```r
control <- sample(controlPopulation, 12)
```

```
## Error in sample(controlPopulation, 12): object 'controlPopulation' not found
```

As we described, the CLT tells us that, for large {$$}N{/$$}, each of these is approximately normal with average population mean and standard error population variance divided by {$$}N{/$$}. We mentioned that a rule of thumb is that {$$}N{/$$} should be 30 or more. But that is just a rule of thumb, as the preciseness of the approximation depends on the population distribution. Here we can actually check the approximation and we do that for various values of {$$}N{/$$}.

Now we use `sapply` and `replicate` instead of `for` loops, which
makes for cleaner code (we do not have to pre-allocate a vector, R
takes care of this for us):


```r
Ns <- c(3,12,25,50)
B <- 10000 #number of simulations
res <-  sapply(Ns,function(n) {
  replicate(B,mean(sample(hfPopulation,n))-mean(sample(controlPopulation,n)))
})
```

```
## Error in sample(hfPopulation, n): object 'hfPopulation' not found
```

Now we can use qq-plots to see how well CLT approximations works for these. If in fact the normal distribution is a good approximation, the points should fall on a straight line when compared to normal quantiles. The more it deviates, the worse the approximation. We also show, in the title, the average and SD of the observed distribution which demonstrates how the SD decreases with {$$}\sqrt{N}{/$$} as predicted. 


```r
mypar(2,2)
for (i in seq(along=Ns)) {
  titleavg <- signif(mean(res[,i]),3)
  titlesd <- signif(popsd(res[,i]),3)
  title <- paste0("N=",Ns[i]," Avg=",titleavg," SD=",titlesd)
  qqnorm(res[,i],main=title)
  qqline(res[,i],col=2)
}
```

```
## Error in mean(res[, i]): object 'res' not found
```

Here we see a pretty good fit even for 3. Why is this? Because the
population itself is relatively close to normally distributed, the
averages are close to normal as well (the sum of normals is also a
normal). In practice we actually calculate a ratio: we divide by the
estimated standard deviation. Here is where the sample size starts to
matter more. 


```r
Ns <- c(3,12,25,50)
B <- 10000 #number of simulations
##function to compute a t-stat
computetstat <- function(n) {
  y <- sample(hfPopulation,n)
  x <- sample(controlPopulation,n)
  (mean(y)-mean(x))/sqrt(var(y)/n+var(x)/n)
}
res <-  sapply(Ns,function(n) {
  replicate(B,computetstat(n))
})
```

```
## Error in sample(hfPopulation, n): object 'hfPopulation' not found
```

```r
mypar(2,2)
for (i in seq(along=Ns)) {
  qqnorm(res[,i],main=Ns[i])
  qqline(res[,i],col=2)
}
```

```
## Error in qqnorm(res[, i], main = Ns[i]): object 'res' not found
```

So we see that for {$$}N=3{/$$} the CLT does not provide a usable
approximation. For {$$}N=12{/$$} there is a slight deviation at the higher
values, although the approximation appears useful. For 25 and 50 the
approximation is spot on.

This simulation only proves that {$$}N=12{/$$} is large enough in this case,
not in general. As mentioned above, we will not be able to perform
this simulation in most situations. We only use the simulation to
illustrate the concepts behind the CLT and its limitations. In future
sections we will describe the approaches we actually use in practice. 

