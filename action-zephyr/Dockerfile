#
# Usage: From the "Docker Quickstart Terminal", execute:
#
#  docker build -t bcdevices/ly10-zephyr-fw
#
# References:
# - https://docs.docker.com/reference/builder/
# - https://docs.docker.com/articles/dockerfile_best-practices/
#
# --
#
# Confidential!!!
# Source code property of Blue Clover Devices.
#
# Demonstration, distribution, replication, or other use of the
# source codes is NOT permitted without prior written consent
# from Blue Clover Devices.
#

FROM bcdevices/zephyr-west:zephyr-1.14.1-rc1-1

LABEL "com.github.actions.name"="Zephyr build"
LABEL "com.github.actions.description"="Build Zephyr project"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/bcdevices/ly10-zephyr-fw"
LABEL "homepage"="https://github.com/bcdevices/ly10-zephyr-fw"
LABEL "maintainer"="Blue Clover Devices"

COPY Makefile .

WORKDIR /usr/src

ENTRYPOINT ["/usr/bin/make"]
CMD ["dist"]
