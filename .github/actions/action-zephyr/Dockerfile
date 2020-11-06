#
# Copyright (c) 2019 Blue Clover Devices
#
# SPDX-License-Identifier: Apache-2.0
#

FROM bcdevices/zephyr-west:zephyr-2.4.0-0

LABEL "com.github.actions.name"="Zephyr build"
LABEL "com.github.actions.description"="Build Zephyr project"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/bcdevices/ly10-zephyr-fw"
LABEL "homepage"="https://github.com/bcdevices/ly10-zephyr-fw"
LABEL "maintainer"="Blue Clover Devices"

WORKDIR /usr/src

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
