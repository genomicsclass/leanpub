---
layout: page
title: Expressing design formula in R
---



# Linear Models

Many of the models we use in data analysis can be presented using matrix algebra. We refer to these types of models as _linear models_. Note that "linear"" here does not refer to lines but rather linear combinations. The representations we describe are convenient because we can write models more succinctly and we have the matrix algebra mathematical machinery to facilitate computation. In this chapter we will describe in some detail how we use matrix algebra to represent and fit.

## The Design Matrix

Here we will show how to use the two base R functions:

- `formula`
- `model.matrix`

in order to produce *design matrices* (also known as *model matrices*) for a variety of linear models. The design matrix is the matrix {$$}\mathbf{X}{/$$} that we have seen in previous sections.

For fitting linear models in R, we will directly provide a *formula* to the `lm` function. In this script, we will use the `model.matrix` function, which is used internally by the `lm` function. This will help us to connect the R *formula* with the matrix {$$}\mathbf{X}{/$$} from the equation {$$}\mathbf{Y} = \mathbf{X} \boldsymbol{\beta} + \boldsymbol{\varepsilon}{/$$} that we have seen. It will therefore help us interpret the results from `lm`.

### Choice of Design

The choice of design matrix is a critical step in linear modeling as it encodes which coefficients will be fit in the model, as well as the inter-relationship between the samples. 

The very simplest design matrix is a column of 1's, where a single coefficient is fit for all the samples. We refer to this term as _intercept_. For standard linear modeling, this fitted coefficient will simply be the average of the observed values ({$$}\mathbf{Y}{/$$}). However, this is not our typical use of linear models.

We typically use linear models to make comparisons between different groups. Hence, the design matrices that we ultimately work with will have at least two columns: an intercept column, which consists of a column of 1's, and a second column, which specifies which samples are in a second group. In this case, two coefficients are fit in the linear model: the intercept, which captures the average of the first group, and a second coefficient, which captures the difference between the average of the second group and the first group. This is typically the coefficient we are interested in when we are performing statistical tests: we want to know if the difference between the two groups is zero or not.

We encode this experimental design in R with two pieces. We start with a formula with the tilde symbol `~`. This means that we want to model the observations using the variables to the right of the tilde. Then we put the name of a variable, which tells us which samples are in which group.

Let's try an example. Suppose we have two groups, 1 and 2, with two samples each. We should first tell R that these values should not be interpreted numerically, but as different levels of a *factor*. We can then use the paradigm `~ group` to, say, model on the variable `group`.


```r
group <- factor(c(1,1,2,2))
model.matrix(~ group)
```

```
##   (Intercept) group2
## 1           1      0
## 2           1      0
## 3           1      1
## 4           1      1
## attr(,"assign")
## [1] 0 1
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
```

(Don't worry about the `attr` lines printed beneath the matrix. We won't be using this information.)

What about the `formula` function? We don't have to include this. By starting an expression with `~`, it is equivalent to telling R that the expression is a formula:


```r
model.matrix(formula(~ group))
```

```
##   (Intercept) group2
## 1           1      0
## 2           1      0
## 3           1      1
## 4           1      1
## attr(,"assign")
## [1] 0 1
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
```

What happens if we don't tell R that `group` should be interpreted as a factor?


```r
group <- c(1,1,2,2)
model.matrix(~ group)
```

```
##   (Intercept) group
## 1           1     1
## 2           1     1
## 3           1     2
## 4           1     2
## attr(,"assign")
## [1] 0 1
```

This is **not** the design matrix we wanted, and the reason is that we provided a numeric variable to the `formula` and `model.matrix` functions, without saying that these numbers actually referred to different groups. If the groups did not happen to have a difference of 1 (and by luck they do in this case), the linear model coefficient {$$}\beta_1{/$$} for the difference between groups would be wrong. We want the second column to have only 0 and 1, indicating group membership.

Also, a note about factors: the names of the levels are irrelevant to `model.matrix` and `lm`. All that matters is the order. For example:


```r
group <- factor(c("control","control","treated","treated"))
model.matrix(~ group)
```

```
##   (Intercept) grouptreated
## 1           1            0
## 2           1            0
## 3           1            1
## 4           1            1
## attr(,"assign")
## [1] 0 1
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
```

produces the same design matrix as our first code chunk.

### More Groups

Using the same formula, we can accommodate modeling more groups:


```r
group <- factor(c(1,1,2,2,3,3))
model.matrix(~ group)
```

```
##   (Intercept) group2 group3
## 1           1      0      0
## 2           1      0      0
## 3           1      1      0
## 4           1      1      0
## 5           1      0      1
## 6           1      0      1
## attr(,"assign")
## [1] 0 1 1
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
```

Now we have a third column which specifies which samples belong to the third group.

An alternate formulation of design matrix is possible by specifying `+ 0` in the formula:


```r
group <- factor(c(1,1,2,2,3,3))
model.matrix(~ group + 0)
```

```
##   group1 group2 group3
## 1      1      0      0
## 2      1      0      0
## 3      0      1      0
## 4      0      1      0
## 5      0      0      1
## 6      0      0      1
## attr(,"assign")
## [1] 1 1 1
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
```

This group now fits a separate coefficient for each group. We will explore this design in more depth later on.

### More Variables

We can simply add additional variables with a `+` sign, in order to build a design matrix which fits based on the information in additional variables:


```r
group <- factor(c(1,1,1,1,2,2,2,2))
condition <- factor(c("a","a","b","b","a","a","b","b"))
model.matrix(~ group + condition)
```

```
##   (Intercept) group2 conditionb
## 1           1      0          0
## 2           1      0          0
## 3           1      0          1
## 4           1      0          1
## 5           1      1          0
## 6           1      1          0
## 7           1      1          1
## 8           1      1          1
## attr(,"assign")
## [1] 0 1 2
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
## 
## attr(,"contrasts")$condition
## [1] "contr.treatment"
```

Such a linear model includes an intercept, a term for `group` and a term for `condition`. We would say that this linear model accounts for differences in both the group and condition variables.

We assume in the above linear model that the effect of the group and condition variables are simply additive. Being in group 2 and condition b is equal to the difference between 2 and 1 and the difference between b and a. 

Another model is possible which fits an additional term and which encodes the potential interaction of group and condition variables. We will cover interaction terms in depth in a later script.

The interaction model can be written in either of the following two formulas:


```r
model.matrix(~ group + condition + group:condition)
```

```
##   (Intercept) group2 conditionb group2:conditionb
## 1           1      0          0                 0
## 2           1      0          0                 0
## 3           1      0          1                 0
## 4           1      0          1                 0
## 5           1      1          0                 0
## 6           1      1          0                 0
## 7           1      1          1                 1
## 8           1      1          1                 1
## attr(,"assign")
## [1] 0 1 2 3
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
## 
## attr(,"contrasts")$condition
## [1] "contr.treatment"
```

```r
model.matrix(~ group*condition)
```

```
##   (Intercept) group2 conditionb group2:conditionb
## 1           1      0          0                 0
## 2           1      0          0                 0
## 3           1      0          1                 0
## 4           1      0          1                 0
## 5           1      1          0                 0
## 6           1      1          0                 0
## 7           1      1          1                 1
## 8           1      1          1                 1
## attr(,"assign")
## [1] 0 1 2 3
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
## 
## attr(,"contrasts")$condition
## [1] "contr.treatment"
```

## Releveling

The level which is chosen for the *reference level* or *base level*. This is the level which is contrasted against and, by default, this is simply the first level alphabetically. We can specify that we want group 2 to be the base level by either using the `relevel` function or by providing the levels explicitly in the `factor` call:


```r
group <- factor(c(1,1,2,2))
model.matrix(~ group)
```

```
##   (Intercept) group2
## 1           1      0
## 2           1      0
## 3           1      1
## 4           1      1
## attr(,"assign")
## [1] 0 1
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
```

```r
group <- relevel(group, "2")
model.matrix(~ group)
```

```
##   (Intercept) group1
## 1           1      1
## 2           1      1
## 3           1      0
## 4           1      0
## attr(,"assign")
## [1] 0 1
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
```

```r
group <- factor(group, levels=c("1","2"))
model.matrix(~ group)
```

```
##   (Intercept) group2
## 1           1      0
## 2           1      0
## 3           1      1
## 4           1      1
## attr(,"assign")
## [1] 0 1
## attr(,"contrasts")
## attr(,"contrasts")$group
## [1] "contr.treatment"
```

### Where Does model.matrix Look For The Data?

The `model.matrix` function will grab the variable from the R environment, unless the data is explicitly provided as a dataframe to the `data` argument:


```r
group <- 1:4
model.matrix(~ group)
```

```
##   (Intercept) group
## 1           1     1
## 2           1     2
## 3           1     3
## 4           1     4
## attr(,"assign")
## [1] 0 1
```

```r
model.matrix(~ group, data=data.frame(group=5:8))
```

```
##   (Intercept) group
## 1           1     5
## 2           1     6
## 3           1     7
## 4           1     8
## attr(,"assign")
## [1] 0 1
```


## Continuous Variables

In the beginning of this lab, we assumed that we didn't want to encode the variable as a numeric, but in certain designs we might be interested in using numeric variables in the design formula, as opposed to converting them to a factor first. For example, we could be interested in testing various dosages of a treatment, where we expect a specific relationship between a measured quantity and the dosage, e.g. 0 mg, 10mg, 20mg. 

Here we show how to encode a numeric variable: a linear model with an intercept, without an intercept, and additionally as a quadratic relationship.


```r
z <- 1:4
model.matrix(~ z)
```

```
##   (Intercept) z
## 1           1 1
## 2           1 2
## 3           1 3
## 4           1 4
## attr(,"assign")
## [1] 0 1
```

```r
model.matrix(~ 0 + z)
```

```
##   z
## 1 1
## 2 2
## 3 3
## 4 4
## attr(,"assign")
## [1] 1
```

```r
model.matrix(~ z + I(z^2))
```

```
##   (Intercept) z I(z^2)
## 1           1 1      1
## 2           1 2      4
## 3           1 3      9
## 4           1 4     16
## attr(,"assign")
## [1] 0 1 2
```

The `I` function above is necessary to specify a mathematical transformation of a variable. See `?I` for more information.