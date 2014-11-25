#!/usr/bin/env bash

HOME=`pwd`

cd $1
dir=`dirname $2`

plink --noweb --bfile processed_files/clean_genotypes --linear --covar processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out $dir/pop_covar --all-pheno

cd $dir
$HOME/scripts/joint_qqplot.R -d $dir -o plots
$HOME/scripts/joint_mhplot.R -d $dir -b $1/processed_files/clean_genotypes.bim -o plots

echo "\n"
