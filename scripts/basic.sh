#!/usr/bin/env bash

cd $1;
dir=`dirname $2`

plink --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/gene_expression.phe --out $dir/basic --all-pheno 
echo "\n"
