include scripts/config.mk

.PHONY = missing_stats cluster clean basic nbasic covar recode

SHELL := /bin/bash
SCRIPTDIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" && echo `pwd`/scripts )
PPATH ?= $(shell pwd)
PDIR ?= $(shell echo test)#_`date +%Y%m%d%H%M%S`)
HOME = $(PPATH)/$(PDIR)

# All plink out directories now end with .plink so they can be programatically accessed
INSTALL = $(HOME)/install.log
RESHAPE  = $(HOME)/processed_files/reshaped_data.log
CLEANDAT = $(HOME)/processed_files/clean_data.log
BASIC = $(HOME)/basic.plink/make.log
NBASIC = $(HOME)/norm_basic.plink/make.log
COVAR = $(HOME)/pop_covar.plink/make.log
LD = $(HOME)/LD/make.log
RECODE = $(HOME)/recode/make.log

export TMPLIB=$(HOME)/lib

all: $(HOME)/cluster.log $(HOME)/missing_stats.log $(BASIC) $(NBASIC) $(COVAR) $(LD) 

$(INSTALL):./scripts/initialize_project.sh ./scripts/install_dependencies.R
	mkdir -p $(HOME) 
	./scripts/initialize_project.sh $(PDIR) scripts/config.mk > $@
	./scripts/install_dependencies.R $(HOME) >> $@   

install: $(INSTALL)

$(RESHAPE): $(INSTALL) ./scripts/reshape_data.sh	
	mkdir -p $(HOME)/processed_files
	./scripts/reshape_data.sh $(HOME) &> $@

$(HOME)/missing_stats.log:$(RESHAPE) ./scripts/genotype_stats.sh ./scripts/plot_maf.R
	./scripts/genotype_stats.sh $(HOME) > $@
	./scripts/plot_maf.R $(HOME) 

$(CLEANDAT):$(RESHAPE) ./scripts/filter_data.sh ./scripts/norm_gene_exp.R ./scripts/detect_pheno_outliers.R
	./scripts/detect_pheno_outliers.R $(HOME) &> $@
	./scripts/filter_data.sh $(HOME) $(SCRIPTDIR) &>> $@

$(HOME)/cluster.log:$(CLEANDAT) ./scripts/cluster_genotypes.sh ./scripts/plot_mds.R
	./scripts/cluster_genotypes.sh $(HOME) &> $@
	./scripts/plot_mds.R $(HOME) 

$(BASIC):$(CLEANDAT) ./scripts/basic.sh ./scripts/pval_plots.R ./scripts/mhplot.R
	mkdir -p $(HOME)/basic.plink/plots
	./scripts/basic.sh $(HOME) $(BASIC) > $@

basic:$(BASIC) # alias to run just this analysis at cmd line 

$(NBASIC):$(CLEANDAT) ./scripts/nbasic.sh ./scripts/pval_plots.R ./scripts/mhplot.R
	mkdir -p $(HOME)/norm_basic.plink/plots
	./scripts/nbasic.sh $(HOME) $(NBASIC) > $@

nbasic:$(NBASIC)  # alias to run just this analysis at cmd line

$(COVAR):$(CLEANDAT) ./scripts/covar.sh ./scripts/pval_plots.R ./scripts/mhplot.R
	mkdir -p $(HOME)/pop_covar.plink/plots 
	./scripts/covar.sh $(HOME) $(COVAR) > $@

covar:$(COVAR)  # alias to run just this analysis at cmd line

$(LD):$(CLEANDAT)  ./scripts/ld.sh ./scripts/ld_assoc_plots.R
	mkdir -p $(HOME)/LD/plots;
	 ./scripts/ld.sh $(HOME) $(LD) > $@
	./scripts/ld_assoc_plots.R $(HOME) >@

ld:$(LD)

partclean:
	rm -rf `dirname $(CLEANDAT)` `dirname $(BASIC)` `dirname $(NBASIC)` `dirname $(COVAR)` `dirname $(LD)`

clean:
	rm -rf $(HOME)
