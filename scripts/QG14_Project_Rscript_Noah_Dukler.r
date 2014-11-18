#!/usr/bin/env Rscript
library(reshape2)
library(ggplot2)
library(plyr)
library(GenABEL)
library(gridExtra)

setwd("~/Dropbox/Classes/QGG/QG14_Project_Noah_Dukler")

# Do PCA on gene expression levels individuals in study
mds=read.table("cluster_info/cluster_info.mds",header=T)
cov=read.table("QG14_project_covariates.txt",header=T)
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


pdf(file = "plots/mds.pdf",width = 8, height = 3)
grid.arrange(mds1 + theme(legend.position="none"),
                         mds2 + theme(legend.position="none"),
                         main ="MDS Plot", legend, 
             widths=unit.c(unit(0.55, "npc") - lwidth,unit(0.55, "npc") - lwidth, lwidth), nrow=1)
dev.off()

# Check each trait to make sure that they are normally distributed 
phenotypes = read.table("processed_files/gene_expression.phe",header = T)
mpheno =melt(phenotypes[,2:5],id.vars = "IID")

p <- ggplot(mpheno, aes(value)) +
  geom_histogram() +
  facet_grid(. ~ variable, scales = "free_x")
pdf(file = "plots/pheno_dist.pdf")
p
dev.off()



# Note: TTC38 appears to be non-normally distributed. Should correct with rank transform
# as per Goh et al. 2009. For consistency apply transform to all phenotypes?
shapiro.test(phenotypes$MRPL40)
shapiro.test(phenotypes$GGT5)
shapiro.test(phenotypes$TTC38)

# Rank-transform to normality using GenABEL package and write out for reananalysis using plink
out = phenotypes

out$MRPL40 <- rntransform(phenotypes$MRPL40)
out$GGT5 <- rntransform(phenotypes$GGT5)
out$TTC38 <- rntransform(phenotypes$TTC38)

npheno =melt(out[,2:5],id.vars = "IID")

p <- ggplot(npheno, aes(value)) +
  geom_histogram() +
  facet_grid(. ~ variable, scales = "free_x")
pdf(file="plots/norm_pheno.pdf")
p
dev.off()

write.table(out, "processed_files/norm_gene_expression.phe",quote=F,row.names = F)

# Some functions 
pplot= function(x, genename){
  hist = hist_ggt_p=ggplot(data=basic_ggt,aes(x= P,y=..density..))+
    geom_histogram()+
    labs(title=paste("P-value distribution for ", genename))
  qq = ggplot(data=basic_ggt,aes(sample = P))+
    stat_qq()+
    labs(title=paste("QQ plot for", genename))
  merge = grid.arrange(hist,qq)
  return(merge)
}

mhplot = function(x, genename){
    plot = ggplot(data = x, aes(x=BP, y = -log10(P)))+
      geom_point()+
      labs(title=paste("Manhattan plot for", genename))
    return(plot)
}

# Create manhattan plots for each of the analysis using the un-normalized data
basic_ggt = read.table("basic_analysis/basic.GGT5.qassoc",header=TRUE)
mhplot(basic_ggt, "GGT5")
pplot(basic_ggt,"GGT5")

basic_mrpl = read.table("basic_analysis/basic.MRPL40.qassoc",header=TRUE)
mhplot(basic_mrpl, "MPRL40")
pplot(basic_mrpl,"MPRL40")


basic_ttc = read.table("basic_analysis/basic.TTC38.qassoc",header=TRUE)
mhplot(basic_ttc, "TTC38")
pplot(basic_ttc,"TTC38")

# Create manhattan plots for each of the analysis using the NORMALIZED data
norm_ggt = read.table("norm_basic_analysis/basic_norm.GGT5.qassoc",header=TRUE)
mhplot(norm_ggt, "GGT5")
pplot(norm_ggt,"GGT5")

norm_mrpl = read.table("norm_basic_analysis/basic_norm.MRPL40.qassoc",header=TRUE)
mhplot(norm_mrpl, "MPRL40")
pplot(norm_mrpl,"MPRL40")

norm_ttc = read.table("norm_basic_analysis/basic_norm.TTC38.qassoc",header=TRUE)
mhplot(norm_ttc, "TTC38")
pplot(norm_ttc,"TTC38")

#########
# Stratified analysis with pop structure and NORMALIZED phenotype data
#########

strat_norm_ggt = read.table("linear_pop_strat/linear_pop.GGT5.qassoc",header=TRUE)
mhplot(strat_norm_ggt, "GGT5")
pplot(strat_norm_ggt,"GGT5")

strat_norm_mrpl = read.table("linear_pop_strat/linear_pop.MRPL40.qassoc",header=TRUE)
mhplot(strat_norm_mrpl, "MPRL40")
pplot(strat_norm_mrpl,"MPRL40")

strat_norm_ttc = read.table("linear_pop_strat/linear_pop.TTC38.qassoc",header=TRUE)
mhplot(strat_norm_ttc, "TTC38")
pplot(strat_norm_ttc,"TTC38")

#########
# Stratified analysis with pop structure and NORMALIZED phenotype data with empirical p-values
#########

strat_perm_norm_ggt = read.table("linear_pop_perm/linear_pop.GGT5.qassoc.perm",header=TRUE)
strat_perm_norm_ggt=merge(strat_norm_ggt[,1:3],strat_perm_norm_ggt)
names(strat_perm_norm_ggt)[4]="P"
mhplot(strat_perm_norm_ggt, "GGT5")
pplot(strat_perm_norm_ggt,"GGT5")

strat_perm_norm_mrpl = read.table("linear_pop_perm/linear_pop.MRPL40.qassoc.perm",header=TRUE)
strat_perm_norm_mrpl=merge(strat_norm_mrpl[,1:3],strat_perm_norm_mrpl)
names(strat_perm_norm_mrpl)[4]="P"
mhplot(strat_perm_norm_mrpl, "MRPL40")
pplot(strat_perm_norm_mrpl,"MRPL40")

strat_perm_norm_ttc = read.table("linear_pop_perm/linear_pop.TTC38.qassoc.perm",header=TRUE)
strat_perm_norm_ttc=merge(strat_norm_ttc[,1:3],strat_perm_norm_ttc)
names(strat_perm_norm_ttc)[4]="P"
mhplot(strat_perm_norm_ttc, "GGT5")
pplot(strat_perm_norm_ttc,"GGT5")

#########
# Covariate analysis with pop structure and NORMALIZED phenotype data
#########

covar_norm_ggt = read.table("linear_pop_covar/linear_pop.GGT5.assoc.linear",header=TRUE)
mhplot(covar_norm_ggt[covar_norm_ggt$TEST=="ADD",], "GGT5")
pplot(covar_norm_ggt[covar_norm_ggt$TEST=="ADD",],"GGT5")
mhplot(covar_norm_ggt[covar_norm_ggt$TEST=="eth",], "GGT5")
pplot(covar_norm_ggt[covar_norm_ggt$TEST=="eth",],"GGT5")


covar_norm_mrpl = read.table("linear_pop_covar/linear_pop.MRPL40.assoc.linear",header=TRUE)
mhplot(covar_norm_mrpl[covar_norm_mrpl$TEST=="ADD",], "MPRL40")
pplot(covar_norm_mrpl[covar_norm_mrpl$TEST=="ADD",],"MPRL40")
mhplot(covar_norm_mrpl[covar_norm_mrpl$TEST=="eth",], "MPRL40")
pplot(covar_norm_mrpl[covar_norm_mrpl$TEST=="eth",],"MPRL40")

covar_norm_ttc = read.table("linear_pop_covar/linear_pop.TTC38.assoc.linear",header=TRUE)
mhplot(covar_norm_ttc[covar_norm_ttc$TEST=="ADD",], "TTC38")
pplot(covar_norm_ttc[covar_norm_ttc$TEST=="ADD",],"TTC38")
mhplot(covar_norm_ttc[covar_norm_ttc$TEST=="eth",], "TTC38")
pplot(covar_norm_ttc[covar_norm_ttc$TEST=="eth",],"TTC38")
