#!/usr/bin/env Rscript

# Script from http://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them

# 1st argument is project directory
args = commandArgs(trailingOnly = TRUE)
setwd(args[1])


libpath=paste0(args[1],"/lib/") 
.libPaths(new = libpath)

print(.libPaths())
print(rownames(installed.packages(lib.loc=.libPaths())))

InstalledPackage <- function(package) 
{
  return(package %in% installed.packages())
}

UsePackage <- function(package, defaultCRANmirror = "http://cran.at.r-project.org") 
{
  if(!InstalledPackage(package))
  {
    options(repos = c(CRAN = defaultCRANmirror))
    suppressMessages(suppressWarnings(install.packages(package)))
    if(!InstalledPackage(package)) return(FALSE)
  }
  return(TRUE)
}

libraries <- c("ggplot2","GenABEL","gridExtra","getopt","reshape2")
for(library in libraries) 
{ 
  if(!UsePackage(library))
  {
    stop("Error!", library)
  }
}
