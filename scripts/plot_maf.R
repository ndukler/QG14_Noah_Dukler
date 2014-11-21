#!/usr/bin/env Rscript
.libPaths(new=Sys.getenv("TMPLIB"))

args = commandArgs(trailingOnly = TRUE)
setwd(args[1])

library(ggplot2)
data = read.table("MAF_statistics/maf05.frq",header=TRUE)

maf=ggplot(data,aes(x=MAF,y=..density..))+
  geom_histogram()+
  labs(title="Minor allele frequency")

pdf("MAF_statistics/maf_freq.pdf")
	maf
dev.off()