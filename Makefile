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

BOARDS_COMMON :=
BOARDS_COMMON += nrf52_pca10040
BOARDS_COMMON += nrf9160_pca10090
BOARDS_COMMON += stm32f4_disco
BOARDS_COMMON += nucleo_f207zg
BOARDS_COMMON += nucleo_f401re
BOARDS_COMMON += nucleo_l432kc
BOARDS_COMMON += disco_l475_iot1

BLINKY_TARGETS := $(patsubst %,build.%/blinky/zephyr/zephyr.hex,$(BOARDS_COMMON))

build.%/blinky/zephyr/zephyr.hex:
	# YCL: backref
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west --builddir build.% \
	  --board % --pristine \
	  $(ZEPHYR_BASE)/samples/basic/blinky \
	fi

.PHONY: bt
bt:
	echo $(BLINKY_TARGETS)

.PHONY: build-blinky
build-blinky: $(BLINKY_TARGETS)

#ZEPHYR_BOARD := nrf_pca10040
ZEPHYR_BOARD := ly10demo
ZEPHYR_BOARD_ROOT := $(BASE_PATH)

.PHONY: versions
versions:
	@echo "GIT_DESC: $(GIT_DESC)"
	@echo "VERSION_TAG: $(VERSION_TAG)"

.PHONY: build
build:
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	  cd app && \
          west build --pristine auto --board "$(ZEPHYR_BOARD)" -- -DBOARD_ROOT="$(ZEPHYR_BOARD_ROOT)"

.PHONY: clean
clean:
	-rm -rf $(BINS)

.PHONY: prereq
prereq:
	pip3 install -r requirements.txt
	install -d zephyrproject
	cd zephyrproject && west init --mr v2.1.0
	cd zephyrproject && west update
	pip3 install -r zephyrproject/zephyr/scripts/requirements.txt

.PHONY: dist-prep
dist-prep:
	-install -d $(DIST)

.PHONY: dist-clean
dist-clean:
	-rm -rf $(DIST)


.PHONY: dist
dist: dist-clean dist-prep build
	install -m 666 app/build/zephyr/zephyr.hex dist/ly10-zephyr-fw-$(VERSION_TAG).hex
	install -m 666 app/build/zephyr/zephyr.elf dist/ly10-zephyr-fw-$(VERSION_TAG).elf
	install -m 666 app/build/zephyr/zephyr.map dist/ly10-zephyr-fw-$(VERSION_TAG).map
	sed 's/{{VERSION}}/$(VERSION_TAG)/g' test-suites/suite-LY10-zephyr.yaml.template > dist/suite-LY10-zephyr-$(VERSION_TAG).yaml

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
