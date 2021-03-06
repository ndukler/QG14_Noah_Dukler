#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR

# Home directory setup
if [[ -z $1 ]]; then
   HOME=`pwd`/plink_`date +%Y%m%d%H%M%S`
else
   HOME=`pwd`/$1
fi
echo $HOME

mkdir -p $HOME

cd $HOME
mkdir -p downloads
mkdir -p lib
# Download datasets
cd downloads
wget http://mezeylab.cb.bscb.cornell.edu/labmembers/documents/QG14_project_genotypes.zip 
wget http://mezeylab.cb.bscb.cornell.edu/labmembers/documents/QG14_project_phenotypes.txt
wget http://mezeylab.cb.bscb.cornell.edu/labmembers/documents/QG14_project_covariates.txt

unzip -n QG14_project_genotypes.zip 

cd $HOME

# Commands run to preprocess text with plink run.

# Look for missing genotype rates and MAF < 0.05 and retrieve statistics 
mkdir -p missing_statistics
plink --noweb --file downloads/QG14_project_genotypes/QG14_project_genotypes --missing --out missing_statistics/miss_stats

mkdir -p MAF_statistics
plink --noweb --file downloads/QG14_project_genotypes/QG14_project_genotypes --freq --out MAF_statistics/maf05

# Filter genotypes for MAF < 0.05 and individuals with missing genotypes
mkdir -p processed_files
plink --noweb  --mind 0.1 --maf 0.05 --make-bed --out processed_files/clean_genotypes --ped downloads/QG14_project_genotypes/QG14_project_genotypes.ped --map downloads/QG14_project_genotypes/QG14_project_genotypes.map

# Reshape phenotype data,  remove sex as covariate as it is already in ped file
paste -d "\t" <(cat <(echo "FID") <(sed -e '1!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt)) <(cat <(echo "IID") <(sed -e '1!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt))  <(sed -e '2!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt) <(sed -e '3!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt) <(sed -e '4!d' -e 's/\s/\n/g'  downloads/QG14_project_phenotypes.txt) | sed '/^\s*$/d' > processed_files/gene_expression.phe 

# Reshape covariates data
awk '{if(NR==1){print "FID","IID",$3} else{print $1,$1,$2}}' downloads/QG14_project_covariates.txt | sed -e 's/YRI/1/g' -e 's/CHB/2/g' > processed_files/cov.phe

# Normalize gene expression
Rscript $DIR/norm_gene_exp.R $HOME

cd $HOME
# Cluster individuals based on genotype
mkdir -p cluster_info
plink --noweb --bfile processed_files/clean_genotypes --cluster --out cluster_info/cluster_info --mds-plot 4

# Run basic association analysis
mkdir -p basic_analysis
mkdir -p basic_analysis/plots
plink --noweb --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/gene_expression.phe --out basic_analysis/basic --all-pheno

# Run basic association analysis on normalized data using --linear for consistency
mkdir -p norm_basic_analysis
mkdir -p norm_basic_analysis/plots
plink --noweb --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/norm_gene_expression.phe --out norm_basic_analysis/norm_basic --all-pheno

# Run population stratified analysis 
mkdir -p pop_strat
mkdir -p pop_strat/plots
plink --noweb --bfile processed_files/clean_genotypes --mh --linear --within processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out pop_strat/pop_strat --all-pheno

# Run population covariate analysis
mkdir -p pop_covar
mkdir -p pop_covar/plots 
plink --noweb --bfile processed_files/clean_genotypes --linear --covar processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out pop_covar/pop_covar --all-pheno 

# Run population stratified analysis with empirical p-values via permutation 
mkdir -p pop_perm
mkdir -p pop_perm/plots
plink --noweb --bfile processed_files/clean_genotypes --linear --mh --within processed_files/cov.phe --perm --pheno processed_files/norm_gene_expression.phe --adjust --out pop_perm/pop_strat_perm --all-pheno

# Looking for LD
mkdir -p LD_analysis
link --noweb --bfile processed_files/clean_genotypes --r2 --out LD_analysis/mixedpop --pheno processed_files/norm_gene_expression.phe

# Recoding genotype files for R
mkdir -p recoded
plink --noweb --bfile processed_files/clean_genotypes --recodeAD --out recoded/clean_recode 
