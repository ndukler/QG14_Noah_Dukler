include scripts/config.mk

.PHONY = missing_stats cluster clean basic nbasic covar strat stratperm

SHELL := /bin/bash
SCRIPTDIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" && echo `pwd`/scripts )
PPATH ?= $(shell pwd)
PDIR ?= $(shell echo test)#_`date +%Y%m%d%H%M%S`)
HOME = $(PPATH)/$(PDIR)

# All plink out directories now end with .plink so they can be programatically accessed
INSTALL = $(HOME)/install.log
CLEANDAT = $(HOME)/clean_data.log
BASIC = $(HOME)/basic.plink/make.log
NBASIC = $(HOME)/norm_basic.plink/make.log
COVAR = $(HOME)/pop_covar.plink/make.log
STRAT = $(HOME)/pop_strat.plink/make.log
PERM = $(HOME)/pop_perm.plink/make.log

all: $(HOME)/cluster.log $(HOME)/missing_stats.log $(BASIC) $(NBASIC) $(COVAR) $(STRAT) $(PERM)

$(INSTALL):./scripts/initialize_project.sh ./scripts/install_dependencies.R
	mkdir -p $(HOME) 
	./scripts/initialize_project.sh $(PDIR) scripts/config.mk > $@
	./scripts/install_dependencies.R $(HOME) >> $@   

$(HOME)/missing_stats.log:$(INSTALL) ./scripts/genotype_stats.sh
	./scripts/genotype_stats.sh $(HOME) > $@

$(CLEANDAT):$(INSTALL) ./scripts/process_data.sh
	./scripts/process_data.sh $(HOME) $(SCRIPTDIR) &> $@ 

$(HOME)/cluster.log:$(CLEANDAT) ./scripts/cluster_genotypes.sh
	./scripts/cluster_genotypes.sh $(HOME) &> $@

$(BASIC):$(CLEANDAT) ./scripts/basic.sh
	mkdir -p $(HOME)/basic.plink/plots
	./scripts/basic.sh $(HOME) $(BASIC) > $@

basic:$(BASIC) # alias to run just this analysis at cmd line 

$(NBASIC):$(CLEANDAT) ./scripts/nbasic.sh $(HOME) 
	mkdir -p $(HOME)/norm_basic.plink/plots
	./scripts/nbasic.sh $(HOME) $(NBASIC) > $@


nbasic:$(NBASIC)  # alias to run just this analysis at cmd line

$(COVAR):$(CLEANDAT) ./scripts/covar.sh
	mkdir -p $(HOME)/pop_covar.plink/plots
	./scripts/covar.sh $(HOME) $(COVAR) > $@

covar:$(COVAR)  # alias to run just this analysis at cmd line

$(STRAT):$(CLEANDAT) ./scripts/strat.sh
	mkdir -p $(HOME)/pop_strat.plink/plots
	./scripts/strat.sh $(HOME) $(STRAT) > $@

strat:$(STRAT)  # alias to run just this analysis at cmd line

$(PERM):$(CLEANDAT) ./scripts/stratperm.sh
	mkdir -p $(HOME)/pop_perm.plink/plots
	./scripts/stratperm.sh $(HOME) $(PERM) > $@

stratperm:$(PERM)  # alias to run just this analysis at cmd line

plot: 

partclean:
	rm -rf `dirname $(BASIC)` `dirname $(NBASIC)` `dirname $(COVAR)` `dirname $(STRAT)` `dirname $(PERM)` 

clean:
	rm -rf $(HOME)
