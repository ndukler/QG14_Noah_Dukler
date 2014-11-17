#!/usr/bin/env Rscript

library(GenABEL)

phenotypes = read.table("processed_files/gene_expression.phe",header = T)

phenotypes$MRPL40 <- rntransform(phenotypes$MRPL40)
phenotypes$GGT5 <- rntransform(phenotypes$GGT5)
phenotypes$TTC38 <- rntransform(phenotypes$TTC38)

write.table(out, "processed_files/norm_gene_expression.phe",quote=F,row.names = F)

