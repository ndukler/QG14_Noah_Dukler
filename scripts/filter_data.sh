#!/usr/bin/env bash

cd $1
# Filter genotypes for MAF < 0.05 and individuals with missing genotypes
plink --noweb  --mind 0.1 --maf 0.05 --make-bed --out processed_files/clean_genotypes --ped downloads/QG14_project_genotypes/QG14_project_genotypes.ped --map downloads/QG14_project_genotypes/QG14_project_genotypes.map

# Normalize gene expression
Rscript $2/norm_gene_exp.R $1
