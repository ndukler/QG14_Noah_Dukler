#!/usr/bin/env bash
HOME=`pwd`

cd $1;
dir=`dirname $2`

plink --noweb --bfile processed_files/clean_genotypes --out LD/TTC38 --pheno processed_files/norm_gene_expression.phe --snps rs6008598,rs6971,rs9626816 --make-bed

plink --noweb --bfile LD/TTC38 --r2 square --out LD/ld_square_TTC38 --pheno processed_files/norm_gene_expression.phe 

plink --noweb --bfile processed_files/clean_genotypes --out LD/FAM118A --pheno processed_files/norm_gene_expression.phe --snps rs135007,rs136604,rs3827393,rs5769966,rs6006743,rs6006992, rs6007009 --make-bed

plink --noweb --bfile LD/FAM118A --r2 square --out LD/ld_square_FAM118A --pheno processed_files/norm_gene_expression.phe 

echo "\n"

