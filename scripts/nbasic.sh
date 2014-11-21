#!/usr/bin/env bash

HOME=`pwd`

cd $1;
dir=`dirname $2`

plink --noweb --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/norm_gene_expression.phe --out $dir/norm_basic --all-pheno

cd $dir

while read line; do
    $HOME/scripts/pval_plots.R -i $line -o plots;
    $HOME/scripts/mhplot.R -i $line -b $1/processed_files/clean_genotypes.bim -o plots
done < <(ls -1 | grep .assoc.linear.adjusted) 

echo "\n"
