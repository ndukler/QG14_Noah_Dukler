#!/usr/bin/env bash

cd $1
# Filter genotypes for MAF < 0.05 and individuals with missing genotypes
mkdir -p processed_files
plink --noweb  --mind 0.1 --maf 0.05 --make-bed --out processed_files/clean_genotypes --ped downloads/QG14_project_genotypes/QG14_project_genotypes.ped --map downloads/QG14_project_genotypes/QG14_project_genotypes.map

# Reshape phenotype data,  remove sex as covariate as it is already in ped file
paste -d "\t" <(cat <(echo "FID") <(sed -e '1!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt)) <(cat <(echo "IID") <(sed -e '1!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt))  <(sed -e '2!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt) <(sed -e '3!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt) <(sed -e '4!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt) | sed '/^\s*$/d' > processed_files/gene_expression.phe 

# Reshape covariates data
awk '{if(NR==1){print "FID","IID",$3} else{print $1,$1,$2}}' downloads/QG14_project_covariates.txt | sed -e 's/YRI/1/g' -e 's/CHB/2/g' > processed_files/cov.phe

# Normalize gene expression
Rscript $2/norm_gene_exp.R $1
