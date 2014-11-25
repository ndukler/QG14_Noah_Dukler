#!/usr/bin/env bash

HOME=`pwd`
cd $1;
dir=`dirname $2`

plink --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/gene_expression.phe --out $dir/basic --all-pheno 

cd $dir
$HOME/scripts/joint_qqplot.R -d $dir -o plots
$HOME/scripts/joint_mhplot.R -d $dir -b $1/processed_files/clean_genotypes.bim -o plots
echo "\n"
