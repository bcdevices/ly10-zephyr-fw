//
// Copyright (c) 2019 Blue Clover Devices
//
// SPDX-License-Identifier: Apache-2.0
//

/* main.c - Application main entry point */

#include <zephyr.h>

#define DELAY_TIME K_MSEC(100)

extern int app_ble(void);
extern int app_buzzer_setup(void);
extern int app_ledstrip_setup(void);
extern int app_ledstrip_run(void);
extern int app_sensor_setup(void);

void main(void)
{
    /* Bluetooth */
    int err;
    err =  app_ble();
    if (err) {
        return;
    }

    /* LED strip control */
    err =  app_ledstrip_setup();
    if (err) {
        return;
    }

    err = app_sensor_setup();
    if (err) {
	return;
    }

    err = app_buzzer_setup();
    if (err) {
	return;
    }

    while (1) {
        err =  app_ledstrip_run();
        if (err) {
            return;
        }
	k_sleep(DELAY_TIME);
    }

}
