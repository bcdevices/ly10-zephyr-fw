#
# Copyright (c) 2019 Blue Clover Devices
#
# SPDX-License-Identifier: Apache-2.0
#

PRJTAG := ly10-zephyr-fw

# Makefile default shell is /bin/sh which does not implement `source`.
SHELL := /bin/bash

BASE_PATH := $(realpath .)
DIST := $(BASE_PATH)/dist

.PHONY: default
default: build

.PHONY: GIT-VERSION-FILE
GIT-VERSION-FILE:
	@sh ./GIT-VERSION-GEN
-include GIT-VERSION-FILE

VERSION_TAG := $(patsubst v%,%,$(GIT_DESC))

DOCKER_BUILD_ARGS :=
DOCKER_BUILD_ARGS += --network=host

DOCKER_RUN_ARGS :=
DOCKER_RUN_ARGS += --network=none

ZEPHYR_TAG := 2.7.0
ZEPHYR_SYSROOT := /usr/src/zephyr-$(ZEPHYR_TAG)/zephyr
ZEPHYR_USRROOT := $(HOME)/src/zephyr-$(ZEPHYR_TAG)/zephyr

ZEPHYR_BOARD_ROOT := $(BASE_PATH)

BOARDS_APP :=
BOARDS_APP += ly10demo
BOARDS_APP += blueclover_plt_demo_v2_nrf52832

APP_TARGETS := $(patsubst %,build.%/app/zephyr/zephyr.hex,$(BOARDS_APP))

build.%/app/zephyr/zephyr.hex:
	if [ -d $(ZEPHYR_USRROOT) ]; then source $(ZEPHYR_USRROOT)/zephyr-env.sh ; \
	elif [ -d $(ZEPHYR_SYSROOT) ]; then source $(ZEPHYR_SYSROOT)/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
          west build --build-dir build.$*/app --pristine auto \
	  --board $* app -- -DBOARD_ROOT="$(ZEPHYR_BOARD_ROOT)"

.PHONY: versions
versions:
	@echo "GIT_DESC: $(GIT_DESC)"
	@echo "VERSION_TAG: $(VERSION_TAG)"

.PHONY: build
build: $(APP_TARGETS)

.PHONY: clean
clean:
	-rm -rf $(BINS) build build.*

.PHONY: prereq
prereq:
	pip3 install -r requirements.txt
	install -d zephyrproject
	cd zephyrproject && west init --mr v$(ZEPHYR_TAG)
	cd zephyrproject && west update
	pip3 install -r $(ZEPHYR_USRROOT)/scripts/requirements.txt

.PHONY: dist-prep
dist-prep:
	-install -d $(DIST)

.PHONY: dist-clean
dist-clean:
	-rm -rf $(DIST)

.PHONY: dist
dist: dist-clean dist-prep build
	install -m 666 build.ly10demo/app/zephyr/zephyr.hex dist/app-pltdemov1-$(VERSION_TAG).hex
	install -m 666 build.ly10demo/app/zephyr/zephyr.elf dist/app-pltdemov1-$(VERSION_TAG).elf
	install -m 666 build.ly10demo/app/zephyr/zephyr.map dist/app-pltdemov1-$(VERSION_TAG).map
	sed 's/{{VERSION}}/$(VERSION_TAG)/g' test-suites/suite-demo-board-zephyr.yaml.template > dist/suite-demo-board-zephyr-$(VERSION_TAG).yaml

.PHONY: deploy
deploy:
	pltcloud -t "$(API_TOKEN)" -f "dist/*" -v "v$(VERSION_TAG)" -p "$(PROJECT_UUID)"

.PHONY: docker
docker: dist-prep
	docker build $(DOCKER_BUILD_ARGS) -t "bcdevices/$(PRJTAG)" .
	-@docker rm -f "$(PRJTAG)-$(VERSION_TAG)" 2>/dev/null
	docker run  $(DOCKER_RUN_ARGS) --name "$(PRJTAG)-$(VERSION_TAG)"  -t "bcdevices/$(PRJTAG)" \
	 /bin/bash -c "make build dist"
	docker cp "$(PRJTAG)-$(VERSION_TAG):/usr/src/dist" $(BASE_PATH)
