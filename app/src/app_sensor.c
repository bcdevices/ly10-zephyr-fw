//
// Copyright (c) 2019 Blue Clover Devices
//
// SPDX-License-Identifier: Apache-2.0
//

/* app_sensor.c - Sensor interface */

#include <stdio.h>
#include <zephyr.h>
#include <device.h>
#include <drivers/sensor.h>

int app_sensor_setup(void)
{
    struct sensor_value temp, hum;
    const struct device *dev = device_get_binding("SHT3XD");
    int rc;

    if (dev == NULL) {
	printf("Could not get SHT3XD device\n");
	return -1;
    }

    rc = sensor_sample_fetch(dev);
    if (rc == 0) {
	rc = sensor_channel_get(dev, SENSOR_CHAN_AMBIENT_TEMP, &temp);
    }
    if (rc == 0) {
	rc = sensor_channel_get(dev, SENSOR_CHAN_HUMIDITY, &hum);
    }
    if (rc != 0) {
	printf("SHT3XD: failed: %d\n", rc);
	return -1;
    }
    printf("SHT3XD: %.2f Cel ; %0.2f %%RH\n",
	   sensor_value_to_double(&temp), sensor_value_to_double(&hum));
    return 0;
}
