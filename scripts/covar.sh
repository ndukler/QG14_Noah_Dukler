#!/usr/bin/env bash

cd $1
mkdir -p pop_covar/plots;
plink --noweb --bfile processed_files/clean_genotypes --linear --covar processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out pop_covar/pop_covar --all-pheno 
echo "\n"
