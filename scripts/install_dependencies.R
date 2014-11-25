#!/usr/bin/env Rscript

# Script from http://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them

# 1st argument is project directory
args = commandArgs(trailingOnly = TRUE)
setwd(args[1])


libpath=paste0(args[1],"/lib/") 
.libPaths(new = libpath)

write("---Library locations detected---",stderr())
write(.libPaths(),stderr())
write("--------------------------------",stderr())
defaultCRANmirror = "http://cran.rstudio.com/"

libraries <- c("ggplot2","GenABEL","gridExtra","getopt","reshape2","xtable","plyr")
for(l in 1:length(libraries)) 
{ 
   if(!(require(libraries[l],character.only = TRUE)))
  {
     #print(libraries[l])
     install.packages(libraries[l],repos=defaultCRANmirror)
  }  
}
