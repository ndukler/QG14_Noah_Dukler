#!/usr/bin/env bash

cd $1
mkdir -p pop_strat/plots;
plink --noweb --bfile processed_files/clean_genotypes --mh --linear --within processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out pop_strat/pop_strat --all-pheno 
echo "\n"
