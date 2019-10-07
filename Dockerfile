#
# Copyright (c) 2019 Blue Clover Devices
#
# SPDX-License-Identifier: Apache-2.0
#

FROM bcdevices/zephyr-west:zephyr-1.14.1-rc1-1

RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no " > /root/.ssh/config

WORKDIR /usr/src/
## Copy everything (use .dockerignore to exclude)
COPY . /usr/src
