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

FROM bcdevices/zephyr-west

RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no " > /root/.ssh/config

WORKDIR /usr/src/
## Copy everything (use .dockerignore to exclude)
COPY . /usr/src
