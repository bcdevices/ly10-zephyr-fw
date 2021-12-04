# ly10-zephyr-fw

Zephyr-based firmware for LY10DEMO and PLT Demo V2

- Build platform: macOS, Linux
- Host platform: LY10DEMO(nRF52), PLT Demo V2 (nRF52)
- Target platform: LY10DEMO(nRF52), PLT Demo V2 (nRF52)

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
    - Install GNU Arm Embedded Toolchain, Version 10-2020-q4-update :
      Install the Mac OS X 64-bit Package (Signed and notarized),
      `gcc-arm-none-eabi-10-2020-q4-update-mac.pkg`, from
      https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
      This will install the toolchain in `/Applications/ARM`
    - `brew install cmake ninja gperf python3 ccache qemu dtc`

### Local build instructions

- Linux:
    - `export ZEPHYR_TOOLCHAIN_VARIANT="zephyr"`
    - `export ZEPHYR_SDK_INSTALL_DIR="/opt/zephyr-sdk"`
- macOS:
    - `export ZEPHYR_TOOLCHAIN_VARIANT="gnuarmemb"`
    - `export GNUARMEMB_TOOLCHAIN_PATH="/Applications/ARM"`
- `make prereq` to install build pre-requisites
- `make dist` to end up with build artifacts in `dist/`
