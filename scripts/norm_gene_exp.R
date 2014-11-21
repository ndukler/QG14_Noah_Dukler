#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)
setwd(args[1])

libpath=paste0(args[1],"/lib/") 
.libPaths(new = libpath)

library("GenABEL")
library("ggplot2")
library(reshape2)
phenotypes = read.table("processed_files/gene_expression.phe",header = T)

reshaped = melt(phenotypes[2:ncol(phenotypes)])

g=ggplot(reshaped,aes(x=value,y=..density..))+
  facet_grid(. ~ variable,scales="free_x")+
  geom_histogram()+
  labs(title="Phenotype distributions")

pdf("processed_files/pheno_dist.pdf")
g
dev.off()

phenotypes$MRPL40 <- rntransform(phenotypes$MRPL40)
phenotypes$GGT5 <- rntransform(phenotypes$GGT5)
phenotypes$TTC38 <- rntransform(phenotypes$TTC38)

reshaped = melt(phenotypes[2:ncol(phenotypes)])

g=ggplot(reshaped,aes(x=value,y=..density..))+
  facet_grid(. ~ variable,scales="free_x")+
  geom_histogram()+
  labs(title="Phenotype distributions (Quantile Normalized)")

pdf("processed_files/norm_pheno_dist.pdf")
g
dev.off()




write.table(phenotypes, "processed_files/norm_gene_expression.phe",quote=F,row.names = F)

