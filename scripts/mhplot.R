#!/usr/bin/env Rscript
library(ggplot2)
library(getopt)

spec = matrix(c(
  'help' , 'h', 0, "logical", "writes helpdocs",
  'file', 'i', 1, "character", "*.assoc.linear.adjusted file",
  'bim', 'b', 1, "character", "*.bim file to map SNPs to positions",
  'out' , 'o', 1, "character", "Output directory for plots"
), byrow=TRUE, ncol=5);

opt = getopt(spec)

# if help was asked for print a friendly message
# and exit with a non-zero error code
if ( !is.null(opt$help) ) {
  cat(getopt(spec, usage=TRUE));
  q(status=1);
}

gene=unlist(strsplit(basename(opt$file),split ="[.]"))[2]

data = read.table(opt$file,header = TRUE)
bim = read.table(opt$bim)
names(bim)=c("CHR","SNP","NA","BP","MAJ","MIN")

mer = merge(data,bim)
mer$sig = mer$FDR_BH<0.5

mhplot = function(x, genename){
  plot = ggplot(data = x, aes(x=BP, y = -log10(UNADJ)))+
    geom_point(aes(colour=sig))+
    labs(title=paste("Manhattan plot for", genename))
  return(plot)
}

path=file.path(opt$out,paste0("mhplot_",gene,".pdf"))
pdf(path)
  mhplot(mer,gene)
dev.off()