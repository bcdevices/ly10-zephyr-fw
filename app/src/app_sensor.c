//
// Confidential!!!
// Source code property of Blue Clover Devices.
//
// Demonstration, distribution, replication, or other use of the
// source codes is NOT permitted without prior written consent
// from Blue Clover Devices.
//

/* app_sensor.c - Sensor interface */

#include <zephyr.h>
#include <device.h>
#include <sensor.h>
#include <stdio.h>

#define DELAY_TIME K_MSEC(100)

int app_sensor_setup(void)
{
    struct sensor_value temp, hum;
    struct device *dev = device_get_binding("SHT3XD");
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
