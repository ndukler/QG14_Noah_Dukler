#!/usr/bin/env bash

cd $1;
mkdir -p norm_basic_analysis/plots;
plink --noweb --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/norm_gene_expression.phe --out norm_basic_analysis/norm_basic --all-pheno
echo "\n"
