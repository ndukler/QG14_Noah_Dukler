#!/usr/bin/env Rscript
.libPaths(new=Sys.getenv("TMPLIB"))
library(ggplot2)
library(getopt)
library(reshape2)
args = commandArgs(trailingOnly = TRUE)
setwd(args[1])


lds = read.table("LD/ld_square_TTC38.ld", quote="\"")
nm = read.table("LD/TTC38.bim")
                
names(lds)=nm[,2]
rownames(lds)=nm[,2]
ord = hclust( dist(lds, method = "euclidean"), method = "ward.D" )$order

mat = melt(as.matrix(lds))
names(mat)=c("SNP_A","SNP_B","R2")
mat$SNP_A = factor(mat$SNP_A,levels = rownames(lds)[ord])
mat$SNP_B = factor(mat$SNP_B,levels = rownames(lds)[ord])

genename = "TTC38"

p <- ggplot() +
  geom_tile(data=mat,aes(x=SNP_B,y=SNP_A,fill=R2))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,color="black"))+
  theme(axis.text.y = element_text(color="black"))+
  labs(x="SNP A", y = "SNP B",title=paste("Linkage Analysis of significant SNPs for", genename))+
  scale_fill_gradient(low = "grey", high = "steelblue",limits=c(0, 1))
pdf(paste0("LD/plots/",genename,"_LD.pdf"))
p
dev.off()


lds = read.table("LD/ld_square_FAM118A.ld", quote="\"")
nm = read.table("LD/FAM118A.bim")

names(lds)=nm[,2]
rownames(lds)=nm[,2]
ord = hclust( dist(lds, method = "euclidean"), method = "ward.D" )$order

mat = melt(as.matrix(lds))
names(mat)=c("SNP_A","SNP_B","R2")
mat$SNP_A = factor(mat$SNP_A,levels = rownames(lds)[ord])
mat$SNP_B = factor(mat$SNP_B,levels = rownames(lds)[ord])

genename = "FAM118A"

p <- ggplot() +
  geom_tile(data=mat,aes(x=SNP_B,y=SNP_A,fill=R2))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,color="black"))+
  theme(axis.text.y = element_text(color="black"))+
  labs(x="SNP A", y = "SNP B",title=paste("Linkage Analysis of significant SNPs for", genename))+
  scale_fill_gradient(low = "grey", high = "steelblue",limits=c(0, 1))

pdf(paste0("LD/plots/",genename,"_LD.pdf"))
p
dev.off()

# # Read in LD, map file, and output from association analysis
# ld = read.table("../test/LD/LD.ld", quote="\"",header=TRUE)
# #map =read.delim("../test/processed_files/clean_genotypes.bim", header=FALSE)
# # need to set a threshold
# 
# i = unique(c(as.character(ld$SNP_A),as.character(ld$SNP_B)))
# 
# id = data.frame(SNP_A=i,SNP_B=i,R2=1)
# 
# genename = "TTC38"
# 
# p <- ggplot() +
#   geom_tile(data=id,aes(x=SNP_B,y=SNP_A,fill=R2))+
#   geom_tile(data=ld,aes(x=SNP_B,y=SNP_A,fill=R2))+
#   geom_tile(data=ld,aes(x=SNP_A,y=SNP_B,fill=R2))+
#   theme(axis.text.x = element_text(angle = 45, hjust = 1,color="black"))+
#   theme(axis.text.y = element_text(color="black"))+
#   labs(x="SNP A", y = "SNP B",title=paste("Linkage Analysis of significant SNPs for", genename))+
#   scale_fill_gradient(low = "grey", high = "steelblue")
# p

# names(map)=c("CHR","SNP","0","BP","MAJ","MIN")
# 
# thresh=0.05
# # get the snps that were statistically significant in an analysis
# get_signif = function(thresh){
#   snps = pval$SNP[pval$FDR_BH<thresh]
#   return(list(ld[ld$SNP_A %in% snps & ld$SNP_B %in% snps,],snps))
# }
# 
# only_sig_snps= get_signif(thresh)
# # Plot linkage for significant snps
# pairs = expand.grid(only_sig_snps[[2]],only_sig_snps[[2]])
# 
# #only_sig_snps <- read.table("~/Dropbox/Classes/QGG/QG14_Project_Noah_Dukler/test/pop_covar.plink/test.ld", header=TRUE, quote="\"")
# p <- ggplot() +
#   geom_tile(data=pairs, aes(x=Var1,y=Var2),linetype = 0, fill = "lightgreen", alpha = 0.2)+
#   geom_tile(data =only_sig_snps[[1]], aes(x=SNP_B,y=SNP_A,fill=R2))+
#   geom_tile(data =only_sig_snps[[1]], aes(x=SNP_A,y=SNP_B,fill=R2))+
#   theme(axis.text.x = element_text(angle = 45, hjust = 1,color="black"))+
#   theme(axis.text.y = element_text(color="black"))+
#   labs(x="SNP A", y = "SNP B",title=paste("Linkage Analysis of significant SNPs for", genename))
# p


# For plotting windows around a single snp

# snp ="rs9606592"
# 
# # Start end in Kb
# get_region=function(snp,window)
# {
#   center=map$BP[map$SNP==snp]
#   start=center - (window*10^4)/2
#   end=center + (window*10^4)/2
#   snps = map[as.numeric(map$BP)>start & as.numeric(map$BP) < end, "SNP"]
#   return(list(ld[ld$SNP_A %in% snps & ld$SNP_B %in% snps,],snps))
# }
#
# sub = get_region(snp,10)
# pairs = expand.grid(sub[[2]],sub[[2]])
# signif = pval$SNP[pval$FDR_BH<thresh]
# 
# axis_col <- apply(matrix(sub[[2]]),1, function(x) if(snp==x){return("red")} else if(x %in% signif){return("darkgreen")} else{return("black")})
# 
# p <- ggplot() +
#   geom_tile(data=pairs, aes(x=Var1,y=Var2),linetype = 0, fill = "blue", alpha = 0.2)+
#   geom_tile(data =sub[[1]], aes(x=SNP_B,y=SNP_A,fill=R2))+
#   geom_tile(data =sub[[1]], aes(x=SNP_A,y=SNP_B,fill=R2))+
#   theme(axis.text.x = element_text(angle = 45, hjust = 1,color=axis_col))+
#   theme(axis.text.y = element_text(color=axis_col))
# p


