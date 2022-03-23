PLT Demo Firmware Shell
#######################

UART settings:

- 115200 bits/sec (8N1)

device - Device commands
************************

Subcommands:

- levels: List configured devices by levels
- list: List configured devices

device levels: List configured devices by levels
================================================

.. code-block:: shell

   plt-demo:~$ device levels
   PRE KERNEL 1:
   - CLOCK
   - UART_0
   - RNG
   PRE KERNEL 2:
   - sys_clock
   POST_KERNEL:
   - GPIO_0
   - PWM_0
   - I2C_0
   - SPI_1
   - APA102
   - BMI270
   - TEMP_0
   - SHT3XD
   APPLICATION:
   - None
   plt-demo:~$ 

device list: List configured devices
====================================

.. code-block:: shell

   plt-demo:~$ device list
   devices:
   - CLOCK (READY)
   - UART_0 (READY)
   - RNG (READY)
   - sys_clock (READY)
   - GPIO_0 (READY)
   - PWM_0 (READY)
   - I2C_0 (READY)
   - SPI_1 (READY)
   - APA102 (READY)
     requires: SPI_1
   - BMI270 (READY)
     requires: I2C_0
   - TEMP_0 (READY)
   - SHT3XD (READY)
     requires: I2C_0


gpio - GPIO commands
********************

Subcommands:

- conf: Configure GPIO
- get: Get GPIO value
- set: Set GPIO

gpio conf: Configure GPIO
=========================

.. code-block:: shell

   plt-demo:~$ gpio conf GPIO_0 1 out
   Configuring GPIO_0 pin 1
   

gpio get: Get GPIO value
========================

.. code-block:: shell

   plt-demo:~$ gpio get GPIO_0 1
   Reading GPIO_0 pin 1
   Value 0

gpio set: Set GPIO
==================

.. code-block:: shell

   plt-demo:~$ gpio set GPIO_0 1 0
   Writing to GPIO_0 pin 1

i2c - I2C commands
******************

Subcommands:

- scan: Scan I2C devices
- recover: Recover I2C bus
- read: Read bytes from an I2C device
- read_byte: Read a byte from an I2C device
- write: Write bytes to an I2C device
- write_byte: Write a byte to an I2C device

i2c scan: Scan I2C devices
==========================

.. code-block:: shell

   plt-demo:~$ i2c scan I2C_0
        0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
   00:             -- -- -- -- -- -- -- -- -- -- -- -- 
   10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
   20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
   30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
   40: -- -- -- -- 44 -- -- -- -- -- -- -- -- -- -- -- 
   50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
   60: -- -- -- -- -- -- -- -- 68 -- -- -- -- -- -- -- 
   70: -- -- -- -- -- -- -- --                         
   2 devices found on I2C_0
   plt-demo:~$ 

kernel - Kernel commands
************************

Subcommands:

- cycles: Kernel cycles.
- stacks: List threads stack usage.
- threads: List kernel threads.
- uptime: Kernel uptime.
- version: Kernel version.

kernel cycles: Kernel cycles
============================

.. code-block:: shell

   plt-demo:~$ kernel cycles
   cycles: 2221011598 hw cycles

kernel stacks: List threads stack usage
=======================================

.. code-block:: shell

   plt-demo:~$ kernel stacks
   0x20000f90 BT RX      (real size 1024):	unused 888	usage 136 / 1024 (13 %)
   0x20000ed8 BT RX pri  (real size 448):	unused 312	usage 136 / 448 (30 %)
   0x20000ad0 BT TX      (real size 640):	unused 288	usage 352 / 640 (55 %)
   0x200013e8 sysworkq   (real size 1024):	unused 416	usage 608 / 1024 (59 %)
   0x20000a18 shell_uart (real size 2048):	unused 1096	usage 952 / 2048 (46 %)
   0x20001278 idle 00    (real size 320):	unused 248	usage 72 / 320 (22 %)
   0x20001330 main       (real size 1024):	unused 596	usage 428 / 1024 (41 %)
   0x200048a8 IRQ 00     (real size 2048):	unused 1484	usage 564 / 2048 (27 %)

kernel threads: List kernel threads
===================================

.. code-block:: shell

   plt-demo:~$ kernel threads
   Scheduler: 18 since last call
   Threads:
    0x20000f90 BT RX     
   	options: 0x0, priority: -8 timeout: 536875016
   	state: pending, entry: 0xa9b9
   	stack size 1024, unused 888, usage 136 / 1024 (13 %)
   
    0x20000ed8 BT RX pri 
   	options: 0x0, priority: -10 timeout: 536874832
   	state: pending, entry: 0xaad1
   	stack size 448, unused 312, usage 136 / 448 (30 %)
   
    0x20000ad0 BT TX     
   	options: 0x0, priority: -9 timeout: 536873800
   	state: pending, entry: 0x6525
   	stack size 640, unused 288, usage 352 / 640 (55 %)
   
    0x200013e8 sysworkq  
   	options: 0x0, priority: -1 timeout: 536876128
   	state: pending, entry: 0x1a85d
   	stack size 1024, unused 416, usage 608 / 1024 (59 %)
   
   *0x20000a18 shell_uart
   	options: 0x0, priority: 14 timeout: 536873616
   	state: queued, entry: 0x4b35
   	stack size 2048, unused 1096, usage 952 / 2048 (46 %)
   
    0x20001278 idle 00   
   	options: 0x1, priority: 15 timeout: 536875760
   	state: , entry: 0x1a581
   	stack size 320, unused 248, usage 72 / 320 (22 %)
   
    0x20001330 main      
   	options: 0x1, priority: 0 timeout: 536875944
   	state: suspended, entry: 0x1a0cd
   	stack size 1024, unused 596, usage 428 / 1024 (41 %)

kernel uptime: Kernel uptime
============================

.. code-block:: shell

   plt-demo:~$ kernel uptime
   Uptime: 67828612 ms

kernel version: Kernel version
==============================

.. code-block:: shell

   plt-demo:~$ kernel version
   Zephyr version 2.7.0

nrf_clock_control
*****************

.. code-block:: shell

   plt-demo:~$ nrf_clock_control 
   HF clock:
   	- not running (users: 0)
   	- last start: 67992124 ms (60 ms ago)
   	- last stop: 67992128 ms (56 ms ago)
   LF clock:
   	- running (users: 2)

pwm - PWM shell commands
************************

Subcommands:

- cycles: set pulse width in cycles
- usec: set pulse width in usec
- nsec: set pulse width in nsec

sensor - Sensor commands
************************

Subcommands:

- get: Get sensor data.

sensor get: Get sensor data
===========================

.. code-block:: shell

   plt-demo:~$ sensor get SHT3XD
   channel idx=13 ambient_temp =  16.948958
   channel idx=16 humidity =  45.137710
   plt-demo:~$ sensor get SHT3XD 13
   channel idx=13 ambient_temp =  16.948958
   plt-demo:~$ sensor get BMI270
   channel idx=0 accel_x =  -0.328614
   channel idx=1 accel_y =  -0.271750
   channel idx=2 accel_z =  10.042785
   channel idx=3 accel_xyz x =  -0.328614 y =  -0.271750 z =  10.042785
   channel idx=4 gyro_x =   0.000000
   channel idx=5 gyro_y =  -0.022371
   channel idx=6 gyro_z =   0.000798
   channel idx=7 gyro_xyz x =   0.000000 y =  -0.022371 z =   0.000798
   plt-demo:~$ sensor get BMI270 2
   channel idx=2 accel_z =  10.046376
   plt-demo:~$ sensor get TEMP_0
   channel idx=12 die_temp =  16.250000
   plt-demo:~$ sensor get TEMP_0 12
   channel idx=12 die_temp =  16.250000
   plt-demo:~$ 

shell - Useful, not Unix-like shell commands
********************************************

Subcommands:

- backspace_mode: Toggle backspace key mode.
- colors: Toggle colored syntax.
- echo: Toggle shell echo.
- stats: Shell statistics.
