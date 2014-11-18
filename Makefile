SHELL := /bin/bash

SCRIPTDIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" && echo `pwd`/scripts )
PPATH ?= $(shell pwd)
PDIR ?= $(shell echo plink_`date +%Y%m%d%H%M%S`)
HOME = $(PPATH)/$(PDIR)


all: init missing cluster basic basicnorm popstrat popcov popperm

init: 
	./scripts/initialize_project.sh $(HOME) 

missing:init
	./scripts/genotype_stats.sh $(HOME)

processdata:init	
	./scripts/process_data.sh $(HOME) $(SCRIPTDIR)

cluster:processdata
	./scripts/cluster_genotypes.sh $(HOME)

basic:processdata
	cd $(HOME); mkdir -p basic_analysis/plots;\
	plink --noweb --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/gene_expression.phe --out basic_analysis/basic --all-pheno;

basicnorm:processdata
	cd $(HOME); mkdir -p norm_basic_analysis/plots;\
	plink --noweb --bfile processed_files/clean_genotypes --linear --adjust --pheno processed_files/norm_gene_expression.phe --out norm_basic_analysis/norm_basic --all-pheno

popstrat:processdata
	cd $(HOME); mkdir -p pop_strat/plots;\
	plink --noweb --bfile processed_files/clean_genotypes --mh --linear --within processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out pop_strat/pop_strat --all-pheno

popcov:processdata
	cd $(HOME); mkdir -p pop_covar/plots;\ 
	plink --noweb --bfile processed_files/clean_genotypes --linear --covar processed_files/cov.phe --pheno processed_files/norm_gene_expression.phe --adjust --out pop_covar/pop_covar --all-pheno  

popperm:processdata
	cd $(HOME); mkdir -p pop_perm/plots;\
	plink --noweb --bfile processed_files/clean_genotypes --linear --mh --within processed_files/cov.phe --perm --pheno processed_files/norm_gene_expression.phe --adjust --out pop_perm/pop_strat_perm --all-pheno

clean:
	rm -rf $(HOME)
