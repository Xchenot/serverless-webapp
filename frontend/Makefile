########
# bash #
########
ifneq ($(NO_BASH), true)
	SHELL := /bin/bash
endif

#######
# Env #
#######

include .env

#############
# Variables #
#############

# Bash
BASH_HISTORY=.bash-history
BASH_HISTORY_FILES=node terraform
BASH_HISTORY_PATHS=$(foreach FILE,$(BASH_HISTORY_FILES),$(BASH_HISTORY)/$(FILE))

# Docker Compose
DC=docker-compose
PULL=$(DC) pull
RUN=$(DC) run --rm --service-ports

# Node
NODE_BUILD=build
NODE_RUN=$(RUN) node
NODE_NPM=$(NODE_RUN) npm
NODE_INSTALL=$(NODE_NPM) install
NODE_RUN_BUILD=$(NODE_NPM) run build

########
# Bash #
########

.PHONY: bash-init
bash-init:
	mkdir -p $(BASH_HISTORY)
	touch $(BASH_HISTORY_PATHS)

.PHONY: bash-reset
bash-reset: bash-init
	truncate --size=0 $(BASH_HISTORY_PATHS)

########
# Node #
########

.PHONY: start
start: $(NODE_RUN) npm start

.PHONY: node-build
node-build: node-install node-build-fast

.PHONY: node-build-fast
node-build-fast:
	$(NODE_RUN) /bin/bash -c "apk add zip; cd /src ; zip -r ../terraform/build.zip *"

