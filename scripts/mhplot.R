#!/usr/bin/env Rscript
library(ggplot2)
library(getopt)

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


mhplot = function(x, genename){
  plot = ggplot(data = x, aes(x=BP, y = -log10(P)))+
    geom_point()+
    labs(title=paste("Manhattan plot for", genename))
  return(plot)
}

path=file.path(opt$out,paste0("mhplot_",opt$gene,".pdf"))
pdf(path)
pplot(data,opt$gene)
dev.off()