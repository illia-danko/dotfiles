THIS_MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
THIS_MAKEFILE_DIR := $(patsubst %/,%,$(dir $(THIS_MAKEFILE_PATH)))

all: install

packages:
	@bash ${THIS_MAKEFILE_DIR}/install.sh $@

config:
	@bash ${THIS_MAKEFILE_DIR}/install.sh $@

install: packages config

.PHONY: packages config
