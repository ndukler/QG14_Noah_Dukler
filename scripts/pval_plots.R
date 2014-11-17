#!/usr/bin/env Rscript
library(ggplot2)
library(gridExtra)
library(getopt)

dir()

spec = matrix(c(
  'help' , 'h', 0, "logical", "writes helpdocs",
  'file', 'i', 1, "character", "*.assoc.linear.adjusted file",
  'gene' , 'g', 1, "character", "gene name",
  'out' , 'o', 1, "character", "Output directory for plots"
  ), byrow=TRUE, ncol=5);


opt = getopt(spec)

# if help was asked for print a friendly message
# and exit with a non-zero error code
if ( !is.null(opt$help) ) {
  cat(getopt(spec, usage=TRUE));
  q(status=1);
}

print(opt$file)

data = read.table(opt$file,header=TRUE)

pplot= function(x, genename){
  hist = ggplot(data=x,aes(x= FDR_BH,y=..density..))+
    geom_histogram()+
    labs(title=paste("P-value distribution for ", genename))
  qq = ggplot(data=x,aes(sample = FDR_BH))+
    stat_qq()+
    labs(title=paste("QQ plot for", genename))
  merge = grid.arrange(hist,qq)
  return(merge)
}

path=file.path(opt$out,paste0("pplot_",opt$gene,".pdf"))
pdf(path)
  pplot(data,opt$gene)
dev.off()
