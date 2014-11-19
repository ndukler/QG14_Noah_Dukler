#!/usr/bin/env bash

cd $1;
plink --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/gene_expression.phe --out basic/basic --all-pheno 
echo "\n"
