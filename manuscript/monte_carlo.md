---
layout: page
title: Monte Carlo methods
---






## Monte Carlo Simulation

The R markdown document for this section is available [here](https://github.com/genomicsclass/labs/tree/master/inference/monte_carlo.Rmd).

Computers can be used to generate pseudo-random numbers. For practical purposes these pseudo-random numbers can be used to imitate random variables from the real world. This permits us to examine properties of random variables using a computer instead of theoretical or analytical derivations. One very useful aspect of this concept is that we can create *simulated* data to test out ideas or competing methods without actually having to perform laboratory experiments.

Simulations can also be used to check theoretical or analytical results. Also, many of the theoretical results we use in statistics are based on asymptotics: they hold when the sample size goes to infinity. In practice, we never have an infinite number of samples so we may want to know how well the theory works with our actual sample size. Sometimes we can answer this question analytically, but not always. Simulations are extremely useful in these cases.

As an example, let's use a Monte Carlo simulation to compare the CLT to the t-distribution approximation for different sample sizes.


```
## Warning in download.file(url, method = method, ...): download had nonzero
## exit status
```


```r
library(dplyr)
dat <- read.csv("mice_pheno.csv")
```

```
## Error in read.table(file = file, header = header, sep = sep, quote = quote, : no lines available in input
```

```r
controlPopulation <- filter(dat,Sex == "F" & Diet == "chow") %>%  
  select(Bodyweight) %>% unlist
```

```
## Error in filter_(.data, .dots = lazyeval::lazy_dots(...)): object 'dat' not found
```

We will build a function that automatically generates a t-statistic under the null hypothesis for a any sample size of `n`.


```r
ttestgenerator <- function(n) {
  #note that here we have a false "high fat" group where we actually
  #sample from the nonsmokers. this is because we are modeling the *null*
  cases <- sample(controlPopulation,n)
  controls <- sample(controlPopulation,n)
  tstat <- (mean(cases)-mean(controls)) / 
      sqrt( var(cases)/n + var(controls)/n ) 
  return(tstat)
  }
ttests <- replicate(1000, ttestgenerator(10))
```

```
## Error in sample(controlPopulation, n): object 'controlPopulation' not found
```

With 1,000 Monte Carlo simulated occurrences of this random variable, we can now get a glimpse of its distribution:


```r
hist(ttests)
```

```
## Error in hist(ttests): object 'ttests' not found
```

So is the distribution of this t-statistic well approximated by the
normal distribution? In the next chapter we will formally introduce
quantile-quantile plots, which provide a useful visual inspection of
how well one distribution approximates another. As we will explain
later, if points fall on the identity line, it means the approximation
is a good one. 


```r
qqnorm(ttests)
```

```
## Error in qqnorm(ttests): object 'ttests' not found
```

```r
abline(0,1)
```

```
## Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...): plot.new has not been called yet
```

This looks like a very good approximation. So, for this particular population, a sample size of 10 was large enough to use the CLT approximation. How about 3? 


```r
ttests <- replicate(1000, ttestgenerator(3))
```

```
## Error in sample(controlPopulation, n): object 'controlPopulation' not found
```

```r
qqnorm(ttests)
```

```
## Error in qqnorm(ttests): object 'ttests' not found
```

```r
abline(0,1)
```

```
## Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...): plot.new has not been called yet
```

Now we see that the large quantiles, referred to by statisticians as
the _tails_, are larger than expected (below the line on the left side
of the plot and above the line on the right side of the plot).  In the
previous module we explained that when the sample size is not large
enough and the *population values* follow a normal distribution, then
the t-distribution is a better approximation. Our simulation results
seem to confirm this:


```r
qs <- (seq(0,999)+0.5)/1000
qqplot(qt(qs,df=2*3-2),ttests,xlim=c(-6,6),ylim=c(-6,6))
```

```
## Error in sort(y): object 'ttests' not found
```

```r
abline(0,1)
```

```
## Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...): plot.new has not been called yet
```

The t-distribution is a much better approximation in this case, but it is still not perfect. This is due to the fact that the original data is not that well approximated by the normal distribution.


```r
qqnorm(controlPopulation)
```

```
## Error in qqnorm(controlPopulation): object 'controlPopulation' not found
```

```r
qqline(controlPopulation)
```

```
## Error in quantile(y, probs, names = FALSE, type = qtype, na.rm = TRUE): object 'controlPopulation' not found
```

### Parametric Simulations for the Observations

The technique we used to motivate random variables and the null
distribution was a type of Monte Carlo simulation. We had access to
population data and generated samples at random. In practice, we do
not have access to the entire population. The reason for using the
approach here was for educational purposes. However, when we want to
use Monte Carlo simulations in practice, it is much more typical to
assume a parametric distribution and generate a population from
this, which is called a _parametric simulation_. This means that we take
parameters estimated from the real data (here the mean and the standard
deviation), and plug these into a model (here the normal
distribution).  This is actually the most common form of Monte Carlo
simulation. 

For the case of weights, we could use our knowledge that mice typically weigh 24 ounces with a SD of about 3.5 ounces, and that the distribution is approximately normal, to generate population data:



```r
controls<- rnorm(5000, mean=24, sd=3.5) 
```

After we generate the data, we can then repeat the exercise above. We no longer have to use the `sample` function since we can re-generate random normal numbers. So the `ttestgenerator` function can be written like this: 


```r
ttestgenerator <- function(n, mean=24, sd=3.5) {
  cases <- rnorm(n,mean,sd)
  controls <- rnorm(n,mean,sd)
  tstat <- (mean(cases)-mean(controls)) / 
      sqrt( var(cases)/n + var(controls)/n ) 
  return(tstat)
  }
```
