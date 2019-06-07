# ly10-zephyr-fw

Zephyr-based firmware for LY10DEMO

- Build platform: OS X, Linux
- Host platform: LY10DEMO(nRF52)
- Target platform: LY10DEMO(nRF52)

*COMPANY CONFIDENTIAL - For internal use by Blue Clover Devices only*

(c)2019 Blue Clover Devices - ALL RIGHTS RESERVED

## Docker build

### Prerequisites

- Linux hosts or Apple Mac computer running macOS
- Docker

### Docker build instructions

From terminal, execute

```
make docker
```

to end up with build artifacts in `dist/`

## Local build

### Prerequisites

- Linux hosts or Apple Mac computer running macOS
- Linux:
    - Zephyr SDK
    - device-tree-compiler
    - cmake
    - ninja
    - dfu-util
- macOS:
    - GCC ARM Embedded toolchain 7 2018Q2, installed in `/opt/gcc-arm-none-eabi-7-2018-q2-update/`
    - `brew install cmake ninja gperf ccache dfu-util qemu dtc python3`

### Local build instructions

- Linux:
    - `export ZEPHYR_TOOLCHAIN_VARIANT="zephyr"`
    - `export ZEPHYR_SDK_INSTALL_DIR="/opt/zephyr-sdk"`
- macOS:
    - `export ZEPHYR_TOOLCHAIN_VARIANT="gnuarmemb"`
    - `export GNUARMEMB_TOOLCHAIN_PATH="/opt/gcc-arm-none-eabi-7-2018-q2-update"`
- `make prereq` to install build pre-requisites
- `make dist` to end up with build artifacts in `dist/`
