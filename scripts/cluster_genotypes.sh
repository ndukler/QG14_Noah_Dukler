#!/usr/bin/env bash

cd $1
echo "Clusting individuals..."
# Cluster individuals based on genotype
mkdir -p cluster_info
plink --noweb --bfile processed_files/clean_genotypes --cluster --out cluster_info/cluster_info --mds-plot 4 &> /dev/null
