#!/usr/bin/env bash

cd $1
dir=`dirname $2`

plink --noweb --bfile processed_files/clean_genotypes --linear --mh --within processed_files/cov.phe --perm --pheno processed_files/norm_gene_expression.phe --adjust --out $dir/pop_strat_perm --all-pheno 
echo "\n"
