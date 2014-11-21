#!/usr/bin/env Rscript

.libPaths(new=Sys.getenv("TMPLIB"))


library(ggplot2)
library(gridExtra)
library(getopt)

spec = matrix(c(
  'help' , 'h', 0, "logical", "writes helpdocs",
  'file', 'i', 1, "character", "*.assoc.linear.adjusted file",
  'out' , 'o', 1, "character", "Output directory for plots"
  ), byrow=TRUE, ncol=5);

opt = getopt(spec)


# if help was asked for print a friendly message
# and exit with a non-zero error code
if ( !is.null(opt$help) ) {
  cat(getopt(spec, usage=TRUE));
  q(status=1);
}

data = read.table(opt$file,header=TRUE)
gene=unlist(strsplit(basename(opt$file),split ="[.]"))[2]

pplot= function(x, genename){
  hist = ggplot(data=x,aes(x= UNADJ,y=..density..))+
    geom_histogram()+
    labs(title=paste("P-value distribution for ", genename))
  qq = ggplot(data=x,aes(sample = UNADJ))+
    stat_qq(distribution = qunif)+
    labs(title=paste("QQ plot for", genename))
  merge = grid.arrange(hist,qq)
  return(merge)
}

path=file.path(opt$out,paste0("pplot_",gene,".pdf"))
pdf(path)
  pplot(data,gene)
dev.off()
