---
title: "Exploratory Data Analysis 2"
output: html_document
layout: page
---




# Exploratory Data Analysis

Biases, systematic errors and unexpected variability are common in data from the life sciences. Failure to discover these problems often leads to flawed analyses and false discoveries. As an example, consider that experiments sometimes fail and not all data processing pipelines, such as the t.test function in R, are designed to detect these. Yet, these pipelines still give you an answer. Furthermore, it may be hard or even impossible to notice that an error was made just from the reported results.

Summarizing and, especially, visualizing data are powerful approaches to detecting these problems. We refer to this as _exploratory data analyis_ (EDA). Many important methodological contributions to existing data analysis techniques in data analysis were initiated by discoveries made via EDA. Through this book we make use of exploratory plots to motivate the analyses we choose. Here we present a general introduction to EDA using height data.

We have already introduced some EDA approaches for _univariate_ data, namely the histograms. Here we describe the qq-plot in more detail and how some EDA and summary statistics for paired data. We also give a demonstration of commonly used figures that we recommend against.


## Quantile Quantile Plots

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course1/exploratory_data_analysis_2.Rmd).

To corroborate that the normal distribution is in fact a good approximation, we can use quantile-quantile plots (QQ-plots). Quantiles are best understood by considering the special case of percentiles. The p-th percentile of a list of a distribution is defined as the number q that is bigger than p% of numbers. For example, the median 50-th percentile is the median. We can compute the percentiles for our list of heights



```r
library(UsingR) ##available from CRAN
```

```
## Error in library(UsingR): there is no package called 'UsingR'
```

```r
x=father.son$fheight
```

```
## Error in eval(expr, envir, enclos): object 'father.son' not found
```

and for the normal distribution:


```r
ps <- seq(0.01,0.99,0.01)
qs <- quantile(x,ps)
```

```
## Error in quantile(x, ps): object 'x' not found
```

```r
normalqs <- qnorm(ps,mean(x),popsd(x))
```

```
## Error in mean(x): object 'x' not found
```

```r
plot(normalqs,qs,xlab="Normal percentiles",ylab="Height percentiles")
```

```
## Error in plot(normalqs, qs, xlab = "Normal percentiles", ylab = "Height percentiles"): object 'normalqs' not found
```

```r
abline(0,1) ##identity line
```

```
## Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...): plot.new has not been called yet
```

Note how close these values are. Also, note that we can see these qqplots with less code:


```r
qqnorm(x)
```

```
## Error in qqnorm(x): object 'x' not found
```

```r
qqline(x) 
```

```
## Error in quantile(y, probs, names = FALSE, type = qtype, na.rm = TRUE): object 'x' not found
```

However, the `qqnorm` function plots against a standard normal distribution. This is why the line has slope `popsd(x)` and intercept `mean(x)`.

In the example above, the points match the line very well. In fact, we can run Monte Carlo simulations to see that we see plots like this for data known to be normally distributed.



```r
n <-1000
x <- rnorm(n)
qqnorm(x)
qqline(x)
```

![Example of the qqnorm function. Here we apply it to numbers generated to follow a normal distribution.](images/R/exploratory_data_analysis_2-tmp-qqnorm_example-1.png) 

We can also get a sense for how non-normally distributed data looks. Here we generate data from the t-distribution with different degrees of freedom. Note that the smaller the degrees of freedoms, the fatter the tails.


```r
dfs <- c(3,6,12,30)
mypar(2,2)
for(df in dfs){
  x <- rt(1000,df)
  qqnorm(x,xlab="t quantiles",main=paste0("d.f=",df),ylim=c(-6,6))
  qqline(x)
}
```

![We generate t-distributed data for four degrees of freedom and plot qqplots against normal theoretical quantiles.](images/R/exploratory_data_analysis_2-tmp-qqnorm_of_t-1.png) 

<a name="scatterplots"></a>

## Scatterplots And Correlation

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course1/exploratory_data_analysis_2.Rmd).

The methods described above relate to _univariate_ variables. In the biomedical sciences, it is common to be interested in the relationship between two or more variables. A classic examples is the father/son height data used by Galton to understand heredity. If we were to summarize these data, we could use the two averages and two standard deviations as both distributions are well approximated by the normal distribution. This summary, however, fails to describe an important characteristic of the data.


```r
library(UsingR)
```

```
## Error in library(UsingR): there is no package called 'UsingR'
```

```r
data("father.son")
```

```
## Warning in data("father.son"): data set 'father.son' not found
```

```r
x=father.son$fheight
```

```
## Error in eval(expr, envir, enclos): object 'father.son' not found
```

```r
y=father.son$sheight
```

```
## Error in eval(expr, envir, enclos): object 'father.son' not found
```

```r
plot(x,y,xlab="Father's height in inches",ylab="Son's height in inches",main=paste("correlation =",signif(cor(x,y),2)))
```

```
## Error in xy.coords(x, y, xlabel, ylabel, log): object 'y' not found
```

The scatter plot shows a general trend: the taller the father, the taller to son. A summary of this trend is the correlation coefficient which in this cases is 0.5. We motivate this statistic by trying to predict the son's height using the father's height. 

## Stratification

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course1/exploratory_data_analysis_2.Rmd).

Suppose we are asked to guess the height of randomly select sons. The average height, 68.7 inches, is the value with the highest proportion (see histogram) and would be our prediction. But what if we are told that the father is 72 inches tall, do we sill guess 68.7?

Note that the father is taller than average. Specifically, he is 1.7 standard deviations taller than the average father. So should we predict that the son is also 1.75 standard deviations taller? It turns out this would be an overestimate. To see this we look at all the sons with fathers who are about 72 inches. We do this by _stratifying_ the son heights.


```r
groups <- split(y,round(x)) 
```

```
## Error in split(y, round(x)): object 'y' not found
```

```r
boxplot(groups)
```

```
## Error in boxplot(groups): object 'groups' not found
```

```r
print(mean(y[ round(x) == 72]))
```

```
## Error in mean(y[round(x) == 72]): object 'y' not found
```
Stratification followed by boxplots lets us see the distribution of each group. The average height of sons with fathers that are 72 inches tall is 70.7 inches. We also see that the means of the strata appear to follow a straight line. This line is referred to as the regression line and its slope is related to the correlation. 

## Bi-variate Normal Distribution

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course1/exploratory_data_analysis_2.Rmd).

A pair of random variables {$$}(X,y){/$$} is considered to be approximated by bivariate normal when the proportion of values below, for example, {$$}x{/$$} and {$$}y{/$$} is approximated by this expression:

{$$} 
Pr(X<a,Y<b) = 
{/$$}

{$$}
\int_{-\infty}^{a} \int_{-\infty}^{b} \frac{1}{2\pi\sigma_x\sigma_y\sqrt{1-\rho^2}}
\exp{ \left(
\frac{1}{2(1-\rho^2)}
\left[\left(\frac{x-\mu_x}{\sigma_x}\right)^2 -  
2\rho\left(\frac{x-\mu_x}{\sigma_x}\right)\left(\frac{y-\mu_y}{\sigma_y}\right)+
\left(\frac{y-\mu_y}{\sigma_y}\right)^2
\right]
\right)
}
{/$$}

A definition that is more intuitive is the following: fix a value {$$}x{/$$} and look at all the pairs {$$}(X,Y){/$$} for which {$$}X=x{/$$}. Generally, in Statistics we call this exercise _conditioning_. We are conditioning {$$}Y{/$$} on {$$}X{/$$}. If a pair of random variables is approximated by a bivariate normal distribution, then the distribution of {$$}Y{/$$} condition on {$$}X=x{/$$} is approximated with a normal distribution for all {$$}x{/$$}. Let's see if this happens here. We take 4 different strata to demonstrate this:


```r
groups <- split(y,round(x)) 
```

```
## Error in split(y, round(x)): object 'y' not found
```

```r
mypar(2,2)
for(i in c(5,8,11,14)){
  qqnorm(groups[[i]],main=paste0("X=",names(groups)[i]," strata"),
         ylim=range(y),xlim=c(-2.5,2.5))
  qqline(groups[[i]])
}
```

```
## Error in qqnorm(groups[[i]], main = paste0("X=", names(groups)[i], " strata"), : object 'groups' not found
```


Now we come back to defining correlation. Mathematical statistics tells us that when two variables follow a bivariate normal distribution, then for any given value of {$$}x{/$$}, the average of the {$$}Y{/$$} in pairs for which {$$}X=x{/$$} is:

{$$} 
\mu_Y +  r \frac{X-\mu_X}{\sigma_X}\sigma_Y
{/$$}

Note that this is a line with slope {$$}r \frac{\sigma_Y}{\sigma_X}{/$$}. This is referred to as the _regression line_. If the SDs are the same, then the slope of the regression line is the correlation {$$}r{/$$}. Therefore, if we standardize {$$}X{/$$} and {$$}Y{/$$}, the correlation is the slope of the regression line.

Another way to see this is that to form a prediction {$$}\hat{Y}{/$$}, for every SD away from the mean in {$$}x{/$$}, we predict {$$}r{/$$} SDs away for {$$}Y{/$$}: 

{$$}
\frac{\hat{Y} - \mu_Y}{\sigma_Y} = r \frac{x-\mu_X}{\sigma_X}
{/$$}

with the {$$}\mu{/$$} representing the averages, {$$}\sigma{/$$} the standard deviations, and {$$}r{/$$} the correlation. So, if there is perfect correlation, we predict the same number of SDs. If there is 0 correlation, then we don't use {$$}x{/$$} at all.  For values between 0 and 1, the prediction is somewhere in between. For negative values, we simply predict in the opposite direction.


To confirm that the above approximations hold in this case, let's compare the mean of each strata to the identity line and the regression line:


```r
x=(x-mean(x))/sd(x)
y=(y-mean(y))/sd(y)
```

```
## Error in eval(expr, envir, enclos): object 'y' not found
```

```r
means=tapply(y,round(x*4)/4,mean)
```

```
## Error in tapply(y, round(x * 4)/4, mean): object 'y' not found
```

```r
fatherheights=as.numeric(names(means))
```

```
## Error in eval(expr, envir, enclos): object 'means' not found
```

```r
mypar(1,1)
plot(fatherheights,means,ylab="average of strata of son heights",ylim=range(fatherheights))
```

```
## Error in plot(fatherheights, means, ylab = "average of strata of son heights", : object 'fatherheights' not found
```

```r
abline(0,cor(x,y))
```

```
## Error in is.data.frame(y): object 'y' not found
```
