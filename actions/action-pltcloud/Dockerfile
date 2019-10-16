#
# Copyright (c) 2019 Blue Clover Devices
#
# SPDX-License-Identifier: Apache-2.0
#

FROM debian:stretch

LABEL "com.github.actions.name"="PLTcloud publish"
LABEL "com.github.actions.description"="Publish to PLTcloud"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/bcdevices/ly10-zephyr-fw"
LABEL "homepage"="https://github.com/bcdevices/ly10-zephyr-fw"
LABEL "maintainer"="Blue Clover Devices"

WORKDIR /usr/src

RUN set -xe \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
	musl \
  ca-certificates \
  bash \
  wget \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://download.pltcloud.com/cli/pltcloud_0.3.0_amd64.deb
RUN dpkg -i pltcloud*_amd64.deb

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
