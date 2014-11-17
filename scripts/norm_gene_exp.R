args = commandArgs(trailingOnly = TRUE)
setwd(args[1])
dir()

libpath=paste0(args[1],"/lib/") 
.libPaths(new = libpath)
if(!require("GenABEL")){
  install.packages("GenABEL",lib = libpath, repos='http://cran.us.r-project.org')
}

library("GenABEL")
phenotypes = read.table("processed_files/gene_expression.phe",header = T)

phenotypes$MRPL40 <- rntransform(phenotypes$MRPL40)
phenotypes$GGT5 <- rntransform(phenotypes$GGT5)
phenotypes$TTC38 <- rntransform(phenotypes$TTC38)

write.table(phenotypes, "processed_files/norm_gene_expression.phe",quote=F,row.names = F)

