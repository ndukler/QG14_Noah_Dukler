SHELL := /bin/bash

SCRIPTDIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" && echo `pwd`/scripts )
PROJPATH ?= $(shell pwd)
PROJDIR ?= $(shell echo plink_`date +%Y%m%d%H%M%S`)
HOME = $(PROJPATH)/$(PROJDIR)

$(PROJDIR): 
	./scripts/initialize_project.sh $(HOME) 

missing:$(PROJDIR)
	./scripts/genotype_stats.sh $(HOME)

processdata:$(PROJDIR)	
	./scripts/process_data.sh $(HOME) $(SCRIPTDIR)

basic:processdata
