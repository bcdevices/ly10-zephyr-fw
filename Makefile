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
BOARDS_COMMON += nrf52dk_nrf52832
BOARDS_COMMON += nrf9160dk_nrf9160
BOARDS_COMMON += stm32f4_disco
BOARDS_COMMON += nucleo_f207zg
BOARDS_COMMON += nucleo_f401re
BOARDS_COMMON += nucleo_l432kc
BOARDS_COMMON += disco_l475_iot1

BLINKY_TARGETS := $(patsubst %,build.%/blinky/zephyr/zephyr.hex,$(BOARDS_COMMON))

BOARDS_BUTTON :=
BOARDS_BUTTON += nrf52dk_nrf52832
BOARDS_BUTTON += nrf9160dk_nrf9160
BOARDS_BUTTON += stm32f4_disco
BOARDS_BUTTON += nucleo_f207zg
BOARDS_BUTTON += nucleo_f401re
BOARDS_BUTTON += disco_l475_iot1

BUTTON_TARGETS := $(patsubst %,build.%/button/zephyr/zephyr.hex,$(BOARDS_BUTTON))

BOARDS_CAN :=
BOARDS_CAN += stm32f4_disco
BOARDS_CAN += nucleo_l432kc

CAN_TARGETS := $(patsubst %,build.%/can/zephyr/zephyr.hex,$(BOARDS_CAN))

BOARDS_GSM_MODEM :=
BOARDS_GSM_MODEM += nrf52dk_nrf52832
#BOARDS_GSM_MODEM += stm32f4_disco # undefined references to `sys_rand32_get'
#BOARDS_GSM_MODEM += nucleo_l432kc # undefined references to `sys_rand32_get'
BOARDS_GSM_MODEM += disco_l475_iot1

GSM_MODEM_TARGETS := $(patsubst %,build.%/gsm_modem/zephyr/zephyr.hex,$(BOARDS_GSM_MODEM))

BOARDS_SERVO_MOTOR :=
#BOARDS_SERVO_MOTOR += nrf52dk_nrf52832 # Unsupported board
#BOARDS_SERVO_MOTOR += nrf9160dk_nrf9160 # Unsupported board

SERVO_MOTOR_TARGETS := $(patsubst %,build.%/servo_motor/zephyr/zephyr.hex,$(BOARDS_SERVO_MOTOR))

SHELL_TARGETS := $(patsubst %,build.%/shell/zephyr/zephyr.hex,$(BOARDS_COMMON))

ZEPHYR_TAG := 2.6.0
ZEPHYR_SYSROOT := /usr/src/zephyr-$(ZEPHYR_TAG)/zephyr
ZEPHYR_USRROOT := $(HOME)/src/zephyr-$(ZEPHYR_TAG)/zephyr

build.%/blinky/zephyr/zephyr.hex:
	mkdir -p build.$*/blinky
	if [ -d $(ZEPHYR_USRROOT) ]; then source $(ZEPHYR_USRROOT)/zephyr-env.sh ; \
	elif [ -d $(ZEPHYR_SYSROOT) ]; then source $(ZEPHYR_SYSROOT)/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/blinky \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/basic/blinky

build.%/button/zephyr/zephyr.hex:
	mkdir -p build.$*/button
	if [ -d $(ZEPHYR_USRROOT) ]; then source $(ZEPHYR_USRROOT)/zephyr-env.sh ; \
	elif [ -d $(ZEPHYR_SYSROOT) ]; then source $(ZEPHYR_SYSROOT)/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/button \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/basic/button

build.%/gsm_modem/zephyr/zephyr.hex:
	mkdir -p build.$*/gsm_modem
	if [ -d $(ZEPHYR_USRROOT) ]; then source $(ZEPHYR_USRROOT)/zephyr-env.sh ; \
	elif [ -d $(ZEPHYR_SYSROOT) ]; then source $(ZEPHYR_SYSROOT)/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/gsm_modem \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/net/gsm_modem

build.%/servo_motor/zephyr/zephyr.hex:
	mkdir -p build.$*/servo_motor
	if [ -d $(ZEPHYR_USRROOT) ]; then source $(ZEPHYR_USRROOT)/zephyr-env.sh ; \
	elif [ -d $(ZEPHYR_SYSROOT) ]; then source $(ZEPHYR_SYSROOT)/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/servo_motor \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/basic/servo_motor

build.%/shell/zephyr/zephyr.hex:
	mkdir -p build.$*/shell
	if [ -d $(ZEPHYR_USRROOT) ]; then source $(ZEPHYR_USRROOT)/zephyr-env.sh ; \
	elif [ -d $(ZEPHYR_SYSROOT) ]; then source $(ZEPHYR_SYSROOT)/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/shell \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/subsys/shell/shell_module

build.%/can/zephyr/zephyr.hex:
	mkdir -p build.$*/can
	if [ -d $(ZEPHYR_USRROOT) ]; then source $(ZEPHYR_USRROOT)/zephyr-env.sh ; \
	elif [ -d $(ZEPHYR_SYSROOT) ]; then source $(ZEPHYR_SYSROOT)/zephyr-env.sh ; \
	else echo "No Zephyr"; fi && \
	west build --build-dir build.$*/can \
	  --board $* --pristine auto \
	  $$ZEPHYR_BASE/samples/drivers/can

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
#build-zephyr-samples: build-blinky build-button build-shell build-CAN build-gsm_modem build-servo_motor
build-zephyr-samples: build-blinky build-button build-shell build-CAN build-gsm_modem

ZEPHYR_BOARD_ROOT := $(BASE_PATH)

BOARDS_APP :=
BOARDS_APP += ly10demo
#BOARDS_APP := nrf52dk_nrf52832

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
build: build-zephyr-samples $(APP_TARGETS)

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
	install -m 666 build.disco_l475_iot1/blinky/zephyr/zephyr.hex dist/zephyr-disco_l475_iot1-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.disco_l475_iot1/button/zephyr/zephyr.hex dist/zephyr-disco_l475_iot1-sample-button-$(VERSION_TAG).hex
	install -m 666 build.disco_l475_iot1/gsm_modem/zephyr/zephyr.hex dist/zephyr-disco_l475_iot1-sample-gsm_modem-$(VERSION_TAG).hex
	install -m 666 build.disco_l475_iot1/shell/zephyr/zephyr.hex dist/zephyr-disco_l475_iot1-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.ly10demo/app/zephyr/zephyr.hex dist/demo-board-zephyr-fw-$(VERSION_TAG).hex
	install -m 666 build.ly10demo/app/zephyr/zephyr.elf dist/demo-board-zephyr-fw-$(VERSION_TAG).elf
	install -m 666 build.ly10demo/app/zephyr/zephyr.map dist/demo-board-zephyr-fw-$(VERSION_TAG).map
	#install -m 666 build.nrf52dk_nrf52832/servo_motor/zephyr/zephyr.hex dist/zephyr-nrf52dk_nrf528320-sample-servo_motor-$(VERSION_TAG).hex
	install -m 666 build.nrf52dk_nrf52832/blinky/zephyr/zephyr.hex dist/zephyr-nrf52dk_nrf52832-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nrf52dk_nrf52832/button/zephyr/zephyr.hex dist/zephyr-nrf52dk_nrf52832-sample-button-$(VERSION_TAG).hex
	install -m 666 build.nrf52dk_nrf52832/gsm_modem/zephyr/zephyr.hex dist/zephyr-nrf52dk_nrf52832-sample-gsm_modem-$(VERSION_TAG).hex
	install -m 666 build.nrf52dk_nrf52832/shell/zephyr/zephyr.hex dist/zephyr-nrf52dk_nrf52832-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.nrf9160dk_nrf9160/blinky/zephyr/zephyr.hex dist/zephyr-nrf9160dk_nrf9160-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nrf9160dk_nrf9160/button/zephyr/zephyr.hex dist/zephyr-nrf9160dk_nrf9160-sample-button-$(VERSION_TAG).hex
	#install -m 666 build.nrf9160dk_nrf9160/servo_motor/zephyr/zephyr.hex dist/zephyr-nrf9160dk_nrf9160-sample-servo_motor-$(VERSION_TAG).hex
	install -m 666 build.nrf9160dk_nrf9160/shell/zephyr/zephyr.hex dist/zephyr-nrf9160dk_nrf9160-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f207zg/blinky/zephyr/zephyr.hex dist/zephyr-nucleo_f207zg-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f207zg/button/zephyr/zephyr.hex dist/zephyr-nucleo_f207zg-sample-button-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f207zg/shell/zephyr/zephyr.hex dist/zephyr-nucleo_f207zg-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f401re/blinky/zephyr/zephyr.hex dist/zephyr-nucleo_f401re-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f401re/button/zephyr/zephyr.hex dist/zephyr-nucleo_f401re-sample-button-$(VERSION_TAG).hex
	install -m 666 build.nucleo_f401re/shell/zephyr/zephyr.hex dist/zephyr-nucleo_f401re-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.nucleo_l432kc/blinky/zephyr/zephyr.hex dist/zephyr-nucleo_l432kc-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.nucleo_l432kc/can/zephyr/zephyr.hex dist/zephyr-nucleo_l432kc-sample-can-$(VERSION_TAG).hex
	#install -m 666 build.nucleo_l432kc/gsm_modem/zephyr/zephyr.hex dist/zephyr-nucleo_l432kc-sample-gsm_modem-$(VERSION_TAG).hex
	install -m 666 build.nucleo_l432kc/shell/zephyr/zephyr.hex dist/zephyr-nucleo_l432kc-sample-shell-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/blinky/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-blinky-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/button/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-button-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/can/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-can-$(VERSION_TAG).hex
	#install -m 666 build.stm32f4_disco/gsm_modem/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-gsm_modem-$(VERSION_TAG).hex
	install -m 666 build.stm32f4_disco/shell/zephyr/zephyr.hex dist/zephyr-stm32f4_disco-sample-shell-$(VERSION_TAG).hex
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
