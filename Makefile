PRJTAG := ly10-zephyr-fw
GIT_DESC := $(shell git describe --tags --always --dirty --match "v[0-9]*")
VERSION_TAG := $(patsubst v%,%,$(GIT_DESC))

DOCKER_LABEL := $(PRJTAG)-$(VERSION_TAG)

default: build

.PHONY: versions
versions:
	@echo "GIT_DESC: $(GIT_DESC)"
	@echo "VERSION_TAG: $(VERSION_TAG)"

.PHONY: build
build:
	rm -rf ly10_zephyr_fw/build
	mkdir -p ly10_zephyr_fw/build
	cmake -DBOARD=nrf52_pca10040 ly10_zephyr_fw
	$(MAKE) -C ly10_zephyr_fw/build

.PHONY: docker
docker:
	install -d dist/
	docker build -t bcdevices/$(PRJTAG) .
	-docker rm -f "$(PRJTAG)-$(VERSION_TAG)"
	-eval "$$(ssh-agent -s)"
	docker run --name "$(PRJTAG)-$(VERSION_TAG)" -v "$(SSH_AUTH_SOCK):/ssh-agent" -e "SSH_AUTH_SOCK=/ssh-agent" -v dist:/usr/src/fw/dist:rw -t bcdevices/$(PRJTAG) /bin/bash -c 'which dtc && source zephyr/zephyr-env.sh && make build'
	docker cp "$(PRJTAG)-$(VERSION_TAG):/usr/src/fw/ly10_zephyr_fw/zephyr/zephyr.hex" dist/ly10-zephyr-fw-$(VERSION_TAG).bin
