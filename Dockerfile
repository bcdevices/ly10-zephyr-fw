#
# Usage: From the "Docker Quickstart Terminal", execute:
#
#  docker build -t bcdevices/ly10-zephyr-fw .
#
# References:
# - https://docs.docker.com/reference/builder/
# - https://docs.docker.com/articles/dockerfile_best-practices/
#
# --
#
# Confidential!!!
# Source code property of Blue Clover Design LLC.
#
# Demonstration, distribution, replication, or other use of the
# source codes is NOT permitted without prior written consent
# from Blue Clover Design.
#

FROM buildpack-deps:stretch-scm

MAINTAINER Blue Clover Devices DevTeam

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
	bison \
	bzip2 \
	doxygen \
	flex \
	gcc \
	git \
	gperf \
	libc-dev \
	libc6:i386 \
	libncurses-dev \
	libncurses5:i386 \
	libssl-dev \
	libstdc++6:i386 \
	make \
	cmake \
	cmake-data \
	librhash0 \
	libuv1 \
	p7zip-full \
	python3 \
	python-serial \
	unzip \
	wget \
	device-tree-compiler \
    && rm -rf /var/lib/apt-lists/*

# Install cmake-data v3.13.2
RUN wget http://http.us.debian.org/debian/pool/main/c/cmake/cmake-data_3.13.2-1~bpo9+1_all.deb && \
    dpkg -i cmake-data_3.13.2-1~bpo9+1_all.deb

# Install libuv1 v1.18.0
RUN wget http://http.us.debian.org/debian/pool/main/libu/libuv1/libuv1_1.18.0-3~bpo9+1_amd64.deb && \
    dpkg -i libuv1_1.18.0-3~bpo9+1_amd64.deb

# Install cmake v3.13.2
RUN wget http://http.us.debian.org/debian/pool/main/c/cmake/cmake_3.13.2-1~bpo9+1_amd64.deb && \
    dpkg -i cmake_3.13.2-1~bpo9+1_amd64.deb

RUN curl -S \
  -L https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 \
  -o /usr/local/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 \
  && tar -vxjf /usr/local/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 -C /usr/local \
  && rm -f /usr/local/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2

WORKDIR /usr/src/fw

# Copy everything (use .dockerignore to exclude)
COPY . /usr/src/fw/

ENV ZEPHYR_TOOLCHAIN_VARIANT=gnuarmemb
ENV GNUARMEMB_TOOLCHAIN_PATH="/usr/local/gcc-arm-none-eabi-6-2017-q2-update"

RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no " > /root/.ssh/config
