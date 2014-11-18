#!/usr/bin/env bash

mkdir -p $1

cd $1
mkdir -p downloads
mkdir -p lib

cd downloads
wget http://mezeylab.cb.bscb.cornell.edu/labmembers/documents/QG14_project_genotypes.zip 
wget http://mezeylab.cb.bscb.cornell.edu/labmembers/documents/QG14_project_phenotypes.txt
wget http://mezeylab.cb.bscb.cornell.edu/labmembers/documents/QG14_project_covariates.txt

unzip -n QG14_project_genotypes.zip 
rm QG14_project_genotypes.zip 
