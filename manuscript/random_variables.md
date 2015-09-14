---
layout: page
title: Introduction to Random Variables
---



# Inference

<a name="introduction"></a>


## Introduction 

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course1/random_variables.Rmd).



This course introduces the statistical concepts necessary to understand p-values and confidence intervals. These terms are ubiquitous in the life science literature. Let's use [this paper](http://diabetes.diabetesjournals.org/content/53/suppl_3/S215.full]) as an example. 

Note that the abstract has this statement: 

> "Body weight was higher in mice fed the high-fat diet already after the first week, due to higher dietary intake in combination with lower metabolic efficiency." 

To support this claim they provide the following in the results section:

> "Already during the first week after introduction of high-fat diet, body weight increased significantly more in the high-fat diet-fed mice (+1.6 ± 0.1 g) than in the normal diet-fed mice (+0.2 {$$}\pm{/$$} 0.1 g; P < 0.001)."

What does P < 0.001 mean? What are the {$$}\pm{/$$} included? In this class,
we will learn what this means and learn to compute these values in
R. The first step is to understand what a random variable is. To do
this, we will use data from a mouse database (provided by Karen
Svenson via Gary Churchill and Dan Gatti and partially funded by P50
GM070683.) We will import the data into R and explain random variables
and null distributions using R programming. 

[CHECK] If you have the file in your working directory, you can read
it with just one line:


```r
dat <- read.csv("femaleMiceWeights.csv")
```

#### Our first look at data

We are interested in determining if following a given diet makes mice
heavier after several weeks. This data was produced by ordering 24
mice from The Jackson Lab and randomly assigning either chow or high
fat (hf) diet. After several weeks the scientists weighed each mice
and obtained this data (`head` just shows us the first 6 rows):


```r
head(dat) 
```

```
##   Diet Bodyweight
## 1 chow      21.51
## 2 chow      28.14
## 3 chow      24.04
## 4 chow      23.45
## 5 chow      23.68
## 6 chow      19.79
```

In RStudio, you can view the entire dataset with


```r
View(dat)
```

So are the hf mice heavier? Mouse 24 at 20.73 grams is one the
lightest mice, while Mouse 21 at 34.02 grams is one of the heaviest. Both are on
the hf diet. Just from looking at the data we see there is
*variability*. Claims such as the one above usually refer to the
averages. So let's look at the average of each group: 


```r
library(dplyr)
control <- filter(dat,Diet=="chow") %>% select(Bodyweight) %>% unlist
treatment <- filter(dat,Diet=="hf") %>% select(Bodyweight) %>% unlist
print( mean(treatment) )
```

```
## [1] 26.83417
```

```r
print( mean(control) )
```

```
## [1] 23.81333
```

```r
obsdiff <- mean(treatment) - mean(control)
print(obsdiff)
```

```
## [1] 3.020833
```

So the hf diet mice are about 10% heavier. Are we done? Why do we need p-values and confidence intervals? The reason is that these averages are random variables. They can take many values. 

If we repeat the experiment, we obtain 24 new mice from The Jackson Laboratory and, after randomly assigning them to each diet, we get a different mean. Every time we repeat this experiment, we get a different value. We call this type of quantity a *random variable*. 

<a name="random_variable"></a>

## Random Variables

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course1/random_variables.Rmd).

Let's see what a random variable is. Imagine we actually have the weight of all control female mice and can upload them to R. In Statistics, we refer to this as *the population*. These are all the control mice available from which we sampled 24. Note that in practice we do not have access to the population. We have a special data set that we're using here to illustrate concepts. 

Read in the data either from your home directory or from dagdata:


```r
library(downloader)
url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/femaleControlsPopulation.csv"
filename <- "femaleControlsPopulation.csv"
if (!file.exists(filename)) download(url,destfile=filename)
population <- read.csv(filename)
population <- unlist(population) # turn it into a numeric
```

Now let's sample 12 mice three times and see how the average changes.


```r
control <- sample(population,12)
mean(control)
```

```
## [1] 24.11333
```

```r
control <- sample(population,12)
mean(control)
```

```
## [1] 24.40667
```

```r
control <- sample(population,12)
mean(control)
```

```
## [1] 23.84
```

Note how the average varies. [CHECK] We can continue to do this repeatedly and start learning something about the...

<a name="null_distribution"></a>

## The Null Hypothesis

R markdown document for this section available [here](https://github.com/genomicsclass/labs/tree/master/course1/random_variables.Rmd).

Now let's go back to our average difference of `obsdiff`. As
scientists we need to be skeptics. How do we know that this `obsdiff`
is due to the diet? What happens if we give all 24 mice the same diet? Will
we see a difference this big? Statisticians refer to this scenario as
the *null hypothesis*. The name "null" is used to remind us that we
are acting as skeptics: we give credence to the possibility that there
is no difference.

Because we have access to the population, we can actually observe as
many values as we want of the difference of the averages when the diet
has no effect. We can do this by randomly sampling 24 control mice,
giving them the same diet, and then recording the difference in mean
between two randomly split groups of 12 and 12. Here is this process
written in R code:























