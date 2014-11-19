#!/usr/bin/env bash

cd $1
dir=`dirname $2`

plink --bfile processed_files/clean_genotypes --linear --covar processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out $dir/pop_covar --all-pheno 
echo "\n"
