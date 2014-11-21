#!/usr/bin/env bash

HOME=`pwd`

cd $1
dir=`dirname $2`

plink --noweb --bfile processed_files/clean_genotypes --linear --covar processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out $dir/pop_covar --all-pheno

cd $dir

while read line; do
    $HOME/scripts/pval_plots.R -i $line -o plots;
    $HOME/scripts/mhplot.R -i $line -b $1/processed_files/clean_genotypes.bim -o plots
done < <(ls -1 | grep .assoc.linear.adjusted) 


echo "\n"
