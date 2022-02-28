THIS_MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
THIS_MAKEFILE_DIR := $(patsubst %/,%,$(dir $(THIS_MAKEFILE_PATH)))

all: install

packages:
	@bash ${THIS_MAKEFILE_DIR}/install.sh $@

config-home:
	@bash ${THIS_MAKEFILE_DIR}/install.sh $@

config-common:
	@bash ${THIS_MAKEFILE_DIR}/install.sh $@

config: config-common config-home

install: packages config

.PHONY: packages config-home config-common config
