#!/usr/bin/env bash

cd $1;
dir=`dirname $2`

plink --noweb --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/norm_gene_expression.phe --out $dir/norm_basic --all-pheno
echo "\n"
