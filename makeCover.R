source("http://bioconductor.org/workflows.R")
workflowInstall("arrays")

library(arrays)
library(affy)  # Affymetrix pre-processing
library(limma)  # two-color pre-processing; differential
# expression
## import 'phenotype' data, describing the experimental design
phenoData <- read.AnnotatedDataFrame(system.file("extdata", "pdata.txt", package = "arrays"))
## RMA normalization
celfiles <- system.file("extdata", package = "arrays")
eset <- justRMA(phenoData = phenoData, celfile.path = celfiles)
## differential expression
combn <- factor(paste(pData(phenoData)[, 1], pData(phenoData)[, 2], sep = "_"))
design <- model.matrix(~combn)  # describe model to be fit
fit <- lmFit(eset, design)  # fit each probeset to model
efit <- eBayes(fit)  # empirical Bayes adjustment
tt <- topTable(efit, coef = 2, number=nrow(eset), sort.by="none")  # table of differentially expressed probesets

# plot
png("manuscript/images/title_page.png",width=1950,height=2700,pointsize=48)
layout(matrix(c(1,1,1,2,3,4), ncol=3,byrow=TRUE), widths=c(1,2,2))
par(mar=c(8,5,1,1))
rafalib::nullplot(xaxt="n",yaxt="n",bty="n")
z <- fit$coefficients[,2]
d <- density(z[abs(z) < 2],bw=.05)
d <- data.frame(x=d$x, y=d$y)
d <- d[abs(d$x) < 1.8,]
plot(d$y, d$x, xlab="",ylab="",xaxt="n",yaxt="n",
     ylim=c(-2,2),type="n",bty="n")
polygon(max(d$y) - d$y, d$x, col=rgb(0,0,.5,.5), lwd=2)
par(mar=c(8,1,1,5))
plot(fit$coefficients[,1], fit$coefficients[,2], 
     col=ifelse(tt$adj.P.Val < .1,"red","black"),
     ylim=c(-2,2),xlab="",ylab="",cex=.4,pch=16,bty="n")
library(LSD)
heatscatter(fit$coefficients[,1], fit$coefficients[,2],
            colpal="heat",main="",xlab="",ylab="",
            ylim=c(-2,2),bty="n",
            cor=FALSE,add.contour=TRUE,color.contour="red",
            greyscale=TRUE,cex.main=1)
dev.off()


