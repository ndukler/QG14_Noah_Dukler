#!/usr/bin/env Rscript
.libPaths(new=Sys.getenv("TMPLIB"))

args = commandArgs(trailingOnly = TRUE)
setwd(args[1])

library(ggplot2)

