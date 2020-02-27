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

BOARDS_BUTTON :=
BOARDS_BUTTON += nrf52_pca10040
BOARDS_BUTTON += nrf9160_pca10090
BOARDS_BUTTON += stm32f4_disco
BOARDS_BUTTON += nucleo_f207zg
BOARDS_BUTTON += nucleo_f401re
BOARDS_BUTTON += disco_l475_iot1

BUTTON_TARGETS := $(patsubst %,build.%/button/zephyr/zephyr.hex,$(BOARDS_BUTTON))

BOARDS_CAN :=
BOARDS_CAN += stm32f4_disco
BOARDS_CAN += nucleo_l432kc

CAN_TARGETS := $(patsubst %,build.%/CAN/zephyr/zephyr.hex,$(BOARDS_CAN))

BOARDS_GSM_MODEM :=
BOARDS_GSM_MODEM += nrf52_pca10040
BOARDS_GSM_MODEM += stm32f4_disco
BOARDS_GSM_MODEM += nucleo_l432kc
BOARDS_GSM_MODEM += disco_l475_iot1

GSM_MODEM_TARGETS := $(patsubst %,build.%/gsm_modem/zephyr/zephyr.hex,$(BOARDS_GSM_MODEM))

BOARDS_SERVO_MOTOR :=
BOARDS_SERVO_MOTOR += nrf52_pca10040
BOARDS_SERVO_MOTOR += nrf9160_pca10090

SERVO_MOTOR_TARGETS := $(patsubst %,build.%/servo_motor/zephyr/zephyr.hex,$(BOARDS_SERVO_MOTOR))

SHELL_TARGETS := $(patsubst %,build.%/shell/zephyr/zephyr.hex,$(BOARDS_COMMON))

build.%/blinky/zephyr/zephyr.hex:
	mkdir -p build.$*/blinky
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/blinky \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/basic/blinky

build.%/button/zephyr/zephyr.hex:
	mkdir -p build.$*/button
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/button \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/basic/button

build.%/gsm_modem/zephyr/zephyr.hex:
	mkdir -p build.$*/gsm_modem
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/gsm_modem \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/net/gsm_modem

build.%/servo_motor/zephyr/zephyr.hex:
	mkdir -p build.$*/servo_motor
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/servo_motor \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/basic/servo_motor

build.%/shell/zephyr/zephyr.hex:
	mkdir -p build.$*/shell
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/shell \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/subsys/shell/shell_module 

build.%/CAN/zephyr/zephyr.hex:
	mkdir -p build.$*/CAN
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/CAN \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/drivers/CAN

.PHONY: build-blinky
build-blinky: $(BLINKY_TARGETS)

.PHONY: build-button
build-button: $(BUTTON_TARGETS)

.PHONY: build-gsm_modem
build-gsm_modem: $(GSM_MODEM_TARGETS)

.PHONY: build-servo_motor
build-servo_motor: $(SERVO_MOTOR_TARGETS)

.PHONY: build-shell
build-shell: $(SHELL_TARGETS)

.PHONY: build-CAN
build-CAN: $(CAN_TARGETS)

.PHONY: build-zephyr-samples
build-zephyr-samples: build-blinky build-button build-shell build-CAN build-gsm_modem build-servo_motor

ZEPHYR_BOARD_ROOT := $(BASE_PATH)

BOARDS_APP :=
BOARDS_APP += ly10demo
#BOARDS_APP := nrf52_pca10040

APP_TARGETS := $(patsubst %,build.%/app/zephyr/zephyr.hex,$(BOARDS_APP))

build.%/app/zephyr/zephyr.hex:
	if [ -d zephyrproject/zephyr ]; then source zephyrproject/zephyr/zephyr-env.sh ; \
	elif [ -d /usr/src/zephyrproject/zephyr ]; then source /usr/src/zephyrproject/zephyr/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
          west build --build-dir build.$*/app --pristine auto \
	  --board $* app -- -DBOARD_ROOT="$(ZEPHYR_BOARD_ROOT)"

.PHONY: versions
versions:
	@echo "GIT_DESC: $(GIT_DESC)"
	@echo "VERSION_TAG: $(VERSION_TAG)"

.PHONY: build
build: build-zephyr-samples $(APP_TARGETS)

.PHONY: clean
clean:
	-rm -rf $(BINS) build build.*

.PHONY: prereq
prereq:
	pip3 install -r requirements.txt
	install -d zephyrproject
	cd zephyrproject && west init --mr v2.2.0-rc2
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
	install -m 666 build.disco_l475_iot1/blinky/zephyr/zephyr.hex dist/zephyr-disco_l475_iot1-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.disco_l475_iot1/button/zephyr/zephyr.hex dist/zephyr-disco_l475_iot1-sample-button-$(VERSION_TAG).hex
	install -m 666 build.disco_l475_iot1/gsm_modem/zephyr/zephyr.hex dist/zephyr-disco_l475_iot1-sample-gsm_modem-$(VERSION_TAG).hex
	install -m 666 build.disco_l475_iot1/shell/zephyr/zephyr.hex dist/zephyr-disco_l475_iot1-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.ly10demo/app/zephyr/zephyr.hex dist/ly10-zephyr-fw-$(VERSION_TAG).hex 
	install -m 666 build.ly10demo/app/zephyr/zephyr.elf dist/ly10-zephyr-fw-$(VERSION_TAG).elf 
	install -m 666 build.ly10demo/app/zephyr/zephyr.map dist/ly10-zephyr-fw-$(VERSION_TAG).map 
	install -m 666 build.nrf52_pca10040/servo_motor/zephyr/zephyr.hex dist/zephyr-nrf52_pca100400-sample-servo_motor-$(VERSION_TAG).hex
	install -m 666 build.nrf52_pca10040/blinky/zephyr/zephyr.hex dist/zephyr-nrf52_pca10040-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nrf52_pca10040/button/zephyr/zephyr.hex dist/zephyr-nrf52_pca10040-sample-button-$(VERSION_TAG).hex
	install -m 666 build.nrf52_pca10040/gsm_modem/zephyr/zephyr.hex dist/zephyr-nrf52_pca10040-sample-gsm_modem-$(VERSION_TAG).hex
	install -m 666 build.nrf52_pca10040/shell/zephyr/zephyr.hex dist/zephyr-nrf52_pca10040-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.nrf9160_pca10090/blinky/zephyr/zephyr.hex dist/zephyr-nrf9160_pca10090-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nrf9160_pca10090/button/zephyr/zephyr.hex dist/zephyr-nrf9160_pca10090-sample-button-$(VERSION_TAG).hex
	install -m 666 build.nrf9160_pca10090/servo_motor/zephyr/zephyr.hex dist/zephyr-nrf9160_pca10090-sample-servo_motor-$(VERSION_TAG).hex
	install -m 666 build.nrf9160_pca10090/shell/zephyr/zephyr.hex dist/zephyr-nrf9160_pca10090-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f207zg/blinky/zephyr/zephyr.hex dist/zephyr-nucleo_f207zg-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f207zg/button/zephyr/zephyr.hex dist/zephyr-nucleo_f207zg-sample-button-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f207zg/shell/zephyr/zephyr.hex dist/zephyr-nucleo_f207zg-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f401re/blinky/zephyr/zephyr.hex dist/zephyr-nucleo_f401re-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f401re/button/zephyr/zephyr.hex dist/zephyr-nucleo_f401re-sample-button-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f401re/shell/zephyr/zephyr.hex dist/zephyr-nucleo_f401re-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.nucleo_l432kc/blinky/zephyr/zephyr.hex dist/zephyr-nucleo_l432kc-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nucleo_l432kc/CAN/zephyr/zephyr.hex dist/zephyr-nucleo_l432kc-sample-CAN-$(VERSION_TAG).hex
	install -m 666 build.nucleo_l432kc/gsm_modem/zephyr/zephyr.hex dist/zephyr-nucleo_l432kc-sample-gsm_modem-$(VERSION_TAG).hex
	install -m 666 build.nucleo_l432kc/shell/zephyr/zephyr.hex dist/zephyr-nucleo_l432kc-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/blinky/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/button/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-button-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/CAN/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-CAN-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/gsm_modem/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-gsm_modem-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/shell/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-shell-$(VERSION_TAG).hex
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
