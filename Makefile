include scripts/config.mk

SHELL := /bin/bash
SCRIPTDIR = $(shell cd "$( dirname "${BASH_SOURCE[0]}" )" && echo `pwd`/scripts )
PPATH ?= $(shell pwd)
PDIR ?= $(shell echo test)#_`date +%Y%m%d%H%M%S`)
HOME = $(PPATH)/$(PDIR)
INSTALL = $(HOME)/install.log

$(INSTALL):./scripts/initialize_project.sh
	mkdir -p $(HOME) 
	./scripts/initialize_project.sh $(PDIR) scripts/config.mk > $@   

clean_data: $(INSTALL)


missing_stats:$(INSTALL)  
	@echo "AAAAAAAAAA"

clean:
	rm -rf $(HOME)
