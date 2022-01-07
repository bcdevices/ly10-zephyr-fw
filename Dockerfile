# SPDX-License-Identifier: Apache-2.0
#
# Copyright (c) 2020-2022 Blue Clover Devices

FROM ghcr.io/bcdevices/zephyr:2.7.1-0

WORKDIR /usr/src/
## Copy everything (use .dockerignore to exclude)
COPY . /usr/src
