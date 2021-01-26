#
# Copyright (c) 2019 Blue Clover Devices
#
# SPDX-License-Identifier: Apache-2.0
#

FROM bcdevices/zephyr-west:zephyr-2.5.0-rc1-0

WORKDIR /usr/src/
## Copy everything (use .dockerignore to exclude)
COPY . /usr/src
