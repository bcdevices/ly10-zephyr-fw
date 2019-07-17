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

FROM buildpack-deps:cosmic-scm

# Setup environment
ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm

#Setup locale
RUN apt-get update && apt-get install -y --no-install-recommends \
		locales \
	  && rm -rf /var/lib/apt/lists/*
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LANG=C.UTF-8

# Install needed packages
RUN apt-get update && apt-get install -y --no-install-recommends \
		ccache \
		device-tree-compiler \
		dfu-util \
		file \
		g++ \
		gcc \
		gcc-multilib \
		git \
		gperf \
		lbzip2 \
		libc6-dev \
		ninja-build \
		make \
		pkg-config \
		python3-pip \
		python3-setuptools \
		python3-tk \
		python3-wheel \
		unzip \
		wget \
		xz-utils \
		zip \
	  && rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/Kitware/CMake/releases/download/v3.13.2/cmake-3.13.2-Linux-x86_64.sh && \
	chmod +x cmake-3.13.2-Linux-x86_64.sh && \
	./cmake-3.13.2-Linux-x86_64.sh --skip-license --prefix=/usr/local && \
	rm -f ./cmake-3.13.2-Linux-x86_64.sh

RUN wget -nv https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.10.1/zephyr-sdk-0.10.1-setup.run
RUN sh zephyr-sdk-0.10.1-setup.run
ENV ZEPHYR_TOOLCHAIN_VARIANT zephyr
ENV ZEPHYR_SDK_INSTALL_DIR /opt/zephyr-sdk

RUN pip3 install --upgrade pip wheel setuptools
RUN pip3 install west

RUN mkdir -p /usr/src/zephyrproject
WORKDIR /usr/src/zephyrproject
RUN west init
RUN west update

RUN pip3 install -r zephyr/scripts/requirements.txt

RUN mkdir /root/.ssh && echo "StrictHostKeyChecking no " > /root/.ssh/config

WORKDIR /usr/src/
## Copy everything (use .dockerignore to exclude)
COPY . /usr/src
