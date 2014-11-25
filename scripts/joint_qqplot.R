#!/usr/bin/env Rscript
.libPaths(new=Sys.getenv("TMPLIB"))
library(plyr)
library(ggplot2)
library(getopt)

spec = matrix(c(
  'help' , 'h', 0, "logical", "writes helpdocs",
  'dir', 'd', 1, "character", "the directory containing the *.assoc.linear.adjusted file",
  'out' , 'o', 1, "character", "Output directory for plots"
), byrow=TRUE, ncol=5);

opt = getopt(spec)


# if help was asked for print a friendly message
# and exit with a non-zero error code
if ( !is.null(opt$help) ) {
  cat(getopt(spec, usage=TRUE));
  q(status=1);
}

setwd(opt$dir)

# setwd("~/Dropbox/Classes/QGG/QG14_Project_Noah_Dukler/test/norm_basic.plink/")
# Get all files of appropriate format
files=dir()[grep(dir(),pattern = "*.assoc.linear.adjusted")]
gene_names=laply(strsplit(basename(files),split ="[.]"),function(x) return(x[2]))

flist=list()
for(f in 1:length(files)){
  flist[[gene_names[f]]] <- read.table(files[f],header = TRUE)
}

data = ldply(flist,function(x){return (data.frame(x$UNADJ)) })

# hist = ggplot(data,aes(x= x.UNADJ,y=..density..))+
#   facet_grid(.~.id)+
#   geom_histogram()+
#   labs(title=paste("P-value distributions"))
# hist
qq = ggplot(data,aes(sample = x.UNADJ))+
  facet_grid(.~.id)+
  stat_qq(distribution = qunif)+
  labs(title=paste("QQ plots"))
# qq
# merge = grid.arrange(hist,qq)

pdf(paste0(opt$out,"/merged_qqplot.pdf"),width = 11,height = 4)
qq
dev.off()
