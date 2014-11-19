#!/usr/bin/env bash

cd $1
mkdir -p missing_statistics
plink --noweb --file downloads/QG14_project_genotypes/QG14_project_genotypes --missing --out missing_statistics/miss_stats 
mkdir -p MAF_statistics 
plink --noweb --file downloads/QG14_project_genotypes/QG14_project_genotypes --freq --out MAF_statistics/maf05 
