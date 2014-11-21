#!/usr/bin/env Rscript

args = commandArgs(trailingOnly = TRUE)
setwd(args[1])

libpath=paste0(args[1],"/lib/") 
.libPaths(new = libpath)


library("ggplot2")
library(gridExtra)

# Do PCA on gene expression levels individuals in study
mds=read.table("cluster_info/cluster_info.mds",header=T)
cov=read.table("downloads/QG14_project_covariates.txt",header=T)
names(cov)[1]=c("IID")
merged = merge(mds,cov)

merged$sex[merged$sex==1]= "Female"
merged$sex[merged$sex==2]= "Male"

# Function from ggplot2 github
g_legend<-function(p){
  tmp <- ggplotGrob(p)
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}

mds1 = ggplot(merged,aes(C1,C2))+
  geom_point(aes(colour=factor(pop),shape=factor(sex)))
mds2 = ggplot(merged,aes(C2,C3))+
  geom_point(aes(colour=factor(pop),shape=factor(sex)))
legend <- g_legend(mds1)
lwidth <- sum(legend$width)


pdf(file = "cluster_info/mds.pdf",width = 8, height = 3)
grid.arrange(mds1 + theme(legend.position="none"),
                         mds2 + theme(legend.position="none"),
                         main ="MDS Plot", legend, 
             widths=unit.c(unit(0.55, "npc") - lwidth,unit(0.55, "npc") - lwidth, lwidth), nrow=1)
dev.off()