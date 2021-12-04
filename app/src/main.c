// SPDX-License-Identifier: Apache-2.0

//
// Copyright (c) 2019-2021 Blue Clover Devices
//

/* main.c - Application main entry point */

#include <stdio.h>
#include <zephyr.h>

#include "app_ble.h"
#include "app_buzzer.h"
#include "app_ledstrip.h"
#include "app_sensor.h"

#define DELAY_TIME K_MSEC(100)

void main(void)
{
	int err;

	/* Bluetooth */
	err =  app_ble();
	if (err) {
		return;
	}

	/* LED strip control */
	err =  app_ledstrip_setup();
	if (err) {
		return;
	}

	err = app_sensor_evironmental_setup();
	if (err) {
		printf("app_sensor_evironmental_setup() failed, err=%d\n", err);
	}

	err = app_sensor_motion_setup();
	if (err) {
		printf("app_sensor_motion_setup() failed, err=%d\n", err);
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
