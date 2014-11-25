#!/usr/bin/env Rscript
.libPaths(new=Sys.getenv("TMPLIB"))
args = commandArgs(trailingOnly = TRUE)
setwd(args[1])

gene_expression <- read.delim("processed_files/gene_expression.phe", header=TRUE)

# Some ideas, automated detection hard problem, also tried density methods ... 
#boxplot(gene_expression[,3:6])

# Sets the outlier criteria
outliers = function(x){
  med=median(x)
  iqr=IQR(x)
  !(x>= (med-(4*iqr)) & x <= (med+(4*iqr)))
}

# number of genes which that individual was an outlier for
num_genes_out = apply(apply(gene_expression[,3:ncol(gene_expression)],2,outliers),1,sum)
gene_expression[which(num_genes_out>0),1:2]

# So we turn to a manual solution
#These are the outliers
gene_expression[which(gene_expression$FAM118A > 9.5),1:2]
# These are thier complement for use in filtering with plink
outs = data.frame(gene_expression[which(!gene_expression$FAM118A > 9.5),1:2],cov=1)
write.table(x=outs,file = "processed_files/not_outliers.txt",quote = FALSE,row.names = FALSE)
