---
title: "Linear Algebra Examples "
author: "Rafa"
date: "February 18, 2015"
output: html_document
layout: page
---



## Examples 

Now we are ready to see how matrix algebra can be useful when analyzing data. We start with some simple example and eventually get to the main one: how to write linear models with matrix algebra notation and solve the least squares problem.


### The Average

To compute the sample average and variance of our data we use these formulas {$$}\bar{Y}=\frac{1}{N} Y_i{/$$} and {$$}\mbox{var}(Y)=\frac{1}{N} \sum_{i=1}^N (Y_i - \bar{Y})^2{/$$}. We can represent these with matrix multiplication. First define this {$$}N \times 1{/$$} matrix made just of 1s

{$$}
A=\begin{pmatrix}
1\\
1\\
\vdots\\
1
\end{pmatrix}
{/$$}

This implies that

{$$}
\frac{1}{N}
\mathbf{A}^\top Y = \frac{1}{N}
\begin{pmatrix}1&1&,\dots&1\end{pmatrix}
\begin{pmatrix}
Y_1\\
Y_2\\
\vdots\\
Y_N
\end{pmatrix}=
\frac{1}{N} \sum_{i=1}^N Y_i
= \bar{Y}
{/$$}

Note that we are multiplying by the scalar {$$}1/N{/$$}. In R we multiply matrix using `%*%`


```r
library(UsingR)
y <- father.son$sheight
print(mean(y))
```

```
## [1] 68.68407
```

```r
N <- length(y)
Y<- matrix(y,N,1)
A <- matrix(1,N,1)
barY=t(A)%*%Y / N

print(barY)
```

```
##          [,1]
## [1,] 68.68407
```

### The Variance

As we will see later, multiplying the transpose of a matrix with another is very common in statistics. So common there is a function in R


```r
barY=crossprod(A,Y) / N
print(barY)
```

```
##          [,1]
## [1,] 68.68407
```

For the variance we note that if

{$$}
\mathbf{r}\equiv \begin{pmatrix}
Y_1 - \bar{Y}\\
\vdots\\
Y_N - \bar{Y}
\end{pmatrix}, \,\,
\frac{1}{N} \mathbf{r}^\top\mathbf{r} = 
\frac{1}{N}\sum_{i=1}^N (Y_i - \bar{Y})^2
{/$$}

And in R if you only send one matrix into `crossprod` it computes: {$$}r^\top r{/$$} so we can simply type:


```r
r <- y - barY
crossprod(r)/N
```

```
##          [,1]
## [1,] 7.915196
```

Which is almost equivalent to 

```r
var(y) 
```

```
## [1] 7.922545
```
The difference is due to the fact that `var` is for the sample estimate which divides by {$$}N-1{/$$}, so this


```r
var(y) * (N-1) / N
```

```
## [1] 7.915196
```
gives us the same answer as our matrix multiplication example.

### Linear Models

Now we are ready to put all this to use. Let's start with Galton's example. If we define these matrices
 
{$$}
\mathbf{Y} = \begin{pmatrix}
Y_1\\
Y_2\\
\vdots\\
Y_N
\end{pmatrix}
,
\mathbf{X} = \begin{pmatrix}
1&x_1\\
1&x_2\\
\vdots\\
1&x_N
\end{pmatrix}
,
\mathbf{\beta} = \begin{pmatrix}
\beta_0\\
\beta_1
\end{pmatrix} \mbox{ and }
\mathbf{\varepsilon} = \begin{pmatrix}
\varepsilon_1\\
\varepsilon_2\\
\vdots\\
\varepsilon_N
\end{pmatrix}
{/$$}



Then we can write the model 

{$$} 
Y_i = \beta_0 + \beta_1 x_i + \varepsilon, i=1,\dots,N 
{/$$}

as 


{$$}
\,
\begin{pmatrix}
Y_1\\
Y_2\\
\vdots\\
Y_N
\end{pmatrix} = 
\begin{pmatrix}
1&x_1\\
1&x_2\\
\vdots\\
1&x_N
\end{pmatrix}
\begin{pmatrix}
\beta_0\\
\beta_1
\end{pmatrix} +
\begin{pmatrix}
\varepsilon_1\\
\varepsilon_2\\
\vdots\\
\varepsilon_N
\end{pmatrix}
{/$$}

or simply: 

{$$}
\mathbf{Y}=\mathbf{X}\boldsymbol{\beta}+\boldsymbol{\varepsilon}
{/$$}

which is a much simpler way to write it. 

