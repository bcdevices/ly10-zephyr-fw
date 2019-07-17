PRJTAG := ly10-zephyr-fw
GIT_DESC := $(shell git describe --tags --always --dirty --match "v[0-9]*")
VERSION_TAG := $(patsubst v%,%,$(GIT_DESC))

# Makefile default shell is /bin/sh which does not implement `source`.
SHELL := /bin/bash

BASE_PATH := $(realpath .)
DIST := $(BASE_PATH)/dist

GIT_DESC := $(shell git describe --tags --always --dirty --match "v[0-9]*")
VERSION_TAG := $(patsubst v%,%,$(GIT_DESC))

DOCKER_BUILD_ARGS :=
DOCKER_BUILD_ARGS += --network=host

DOCKER_RUN_ARGS :=
DOCKER_RUN_ARGS += --network=none

#ZEPHYR_BOARD := nrf_pca10040
ZEPHYR_BOARD := ly10demo
ZEPHYR_BOARD_ROOT := $(BASE_PATH)

default: build

.PHONY: versions
versions:
	@echo "GIT_DESC: $(GIT_DESC)"
	@echo "VERSION_TAG: $(VERSION_TAG)"

.PHONY: build
build:
	ls zephyrproject
	source zephyrproject/zephyr/zephyr-env.sh && \
	  cd app && \
          west build --pristine auto --board "$(ZEPHYR_BOARD)" -- -DBOARD_ROOT="$(ZEPHYR_BOARD_ROOT)"

.PHONY: clean
clean:
	-rm -rf $(BINS)

.PHONY: prereq
prereq:
	pip3 install -r requirements.txt
	install -d zephyrproject
	cd zephyrproject && west init
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

.PHONY: docker
docker: dist-prep
	docker build $(DOCKER_BUILD_ARGS) -t "bcdevices/$(PRJTAG)" .
	-docker rm -f "$(PRJTAG)-$(VERSION_TAG)"
	docker run  $(DOCKER_RUN_ARGS) --name "$(PRJTAG)-$(VERSION_TAG)"  -t "bcdevices/$(PRJTAG)" \
	 /bin/bash -c "make build dist"
	docker cp "$(PRJTAG)-$(VERSION_TAG):/usr/src/dist" $(BASE_PATH)
