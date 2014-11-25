#!/usr/bin/env Rscript
.libPaths(new=Sys.getenv("TMPLIB"))
library(ggplot2)
library(getopt)
library(reshape2)
library(xtable)
library(plyr)

spec = matrix(c(
  'help' , 'h', 0, "logical", "writes helpdocs",
  'dir', 'd', 1, "character", "the directory containing the *.assoc.linear.adjusted file",
  'bim', 'b', 1, "character","the bim file with the SNP locations",
  'out' , 'o', 1, "character", "Output directory for plots"
), byrow=TRUE, ncol=5)

opt = getopt(spec)


# if help was asked for print a friendly message
# and exit with a non-zero error code
if ( !is.null(opt$help) ) {
  cat(getopt(spec, usage=TRUE));
  q(status=1);
}

bim=read.table(file = opt$bim)
names(bim)=c("CHR","SNP","O","BP","MAJ","MIN")

setwd(opt$dir)

files=dir()[grep(dir(),pattern = "*.assoc.linear.adjusted")]
gene_names=laply(strsplit(basename(files),split ="[.]"),function(x) return(x[2]))

flist=list()
for(f in 1:length(files)){
  flist[[gene_names[f]]] <- read.table(files[f],header = TRUE)
}

data = ldply(flist,function(x){return (data.frame(x$SNP,x$UNADJ,x$FDR_BH)) })
names(data)=c("GENE","SNP","UNADJ","FDR_BH")

merged = merge(data,bim,by="SNP")

mh = ggplot(merged, aes(x=BP,y=-log10(UNADJ),colour=FDR_BH<0.05))+
  geom_point(alpha=.5)+
  facet_grid( .~ GENE)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1,color="black"))


pdf(paste0(opt$out,"/merged_mhplot.pdf"),width = 11,height = 4)
mh
dev.off()

# Get which SNPS were causal
sig=merged[which(merged$FDR_BH<0.05),c("GENE","SNP","BP","FDR_BH")]
print(xtable(sig[,1:4], display=c("d","s","s","d","e")),include.rownames=FALSE)
