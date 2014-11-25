#!/usr/bin/env bash

cd $1
# Filter genotypes for MAF < 0.05 and individuals with missing genotypes
# Set very low bar for Hardy-weinberg equilibrium, just to check for genotyping errors
# Filter for specified outliers 
plink --noweb --hwe 1e-10 midp  --mind 0.1 --maf 0.05 --filter processed_files/not_outliers.txt 1 --make-bed --out processed_files/clean_genotypes --ped downloads/QG14_project_genotypes/QG14_project_genotypes.ped --map downloads/QG14_project_genotypes/QG14_project_genotypes.map

# Normalize gene expression
Rscript $2/norm_gene_exp.R $1
