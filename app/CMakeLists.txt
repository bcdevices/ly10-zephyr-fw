# Boilerplate code, which pulls in the Zephyr build system.
cmake_minimum_required(VERSION 3.13.1)
include($ENV{ZEPHYR_BASE}/cmake/app/boilerplate.cmake NO_POLICY_SCOPE)
project(my_zephyr_app)

# ../boards/arm/ly10demo
#set(BOARD ly10demo)
#set(BOARD_ROOT ../boards)

# Add your source file to the "app" target. This must come after
# the boilerplate code, which defines the target.
target_sources(app PRIVATE src/main.c src/app_ble.c src/app_ledstrip.c src/app_sensor.c)

zephyr_library_include_directories($ENV{ZEPHYR_BASE}/samples/bluetooth)
