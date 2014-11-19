include scripts/config.mk

.PHONY = missing_stats cluster clean basic nbasic covar strat stratperm

SHELL := /bin/bash
SCRIPTDIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" && echo `pwd`/scripts )
PPATH ?= $(shell pwd)
PDIR ?= $(shell echo test)#_`date +%Y%m%d%H%M%S`)
HOME = $(PPATH)/$(PDIR)

INSTALL = $(HOME)/install.log
CLEANDAT = $(HOME)/clean_data.log
BASIC = $(HOME)/basic/make.log
NBASIC = $(HOME)/norm_basic_analysis/make.log
COVAR = $(HOME)/pop_covar/make.log
STRAT = $(HOME)/pop_strat/make.log
PERM = $(HOME)/pop_perm/make.log

all: cluster missing_stats $(BASIC) $(NBASIC) $(COVAR) $(STRAT) $(PERM)

$(INSTALL):./scripts/initialize_project.sh ./scripts/install_dependencies.R
	mkdir -p $(HOME) 
	./scripts/initialize_project.sh $(PDIR) scripts/config.mk > $@
	./scripts/install_dependencies.R $(HOME) >> $@   

missing_stats:$(INSTALL) ./scripts/genotype_stats.sh
	./scripts/genotype_stats.sh $(HOME)

$(CLEANDAT):$(INSTALL) ./scripts/process_data.sh
	./scripts/process_data.sh $(HOME) $(SCRIPTDIR) &> $@ 

cluster:$(CLEANDAT) ./scripts/cluster_genotypes.sh
	./scripts/cluster_genotypes.sh $(HOME)

$(BASIC):$(CLEANDAT) ./scripts/basic.sh
	mkdir -p $(HOME)/basic/plots
	./scripts/basic.sh $(HOME) > $@

basic:$(BASIC) ./scripts/nbasic.sh $(HOME) # alias to run just this analysis at cmd line
	mkdir -p $(HOME)/norm_basic_analysis/plots
	./scripts/nbasic.sh $(HOME) > $@

$(NBASIC):$(CLEANDAT)

nbasic:$(NBASIC)  # alias to run just this analysis at cmd line

$(COVAR):$(CLEANDAT) ./scripts/covar.sh
	mkdir -p $(HOME)/pop_covar/plots
	./scripts/covar.sh $(HOME) > $@

covar:$(COVAR)  # alias to run just this analysis at cmd line

$(STRAT):$(CLEANDAT) ./scripts/strat.sh
	mkdir -p $(HOME)/pop_strat/plots
	./scripts/strat.sh $(HOME) > $@

strat:$(STRAT)  # alias to run just this analysis at cmd line

$(PERM):$(CLEANDAT) ./scripts/stratperm.sh
	mkdir -p $(HOME)/pop_perm/plots
	./scripts/stratperm.sh $(HOME) > $@

stratperm:$(PERM)  # alias to run just this analysis at cmd line

partclean:
	rm -rf $(BASIC) $(NBASIC) $(COVAR) $(STRAT) $(PERM) 

clean:
	rm -rf $(HOME)
