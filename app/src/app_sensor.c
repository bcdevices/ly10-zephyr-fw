// SPDX-License-Identifier: Apache-2.0

//
// Copyright (c) 2019-2021 Blue Clover Devices
//

/* app_sensor.c - Sensor interface */

#include <stdio.h>
#include <zephyr.h>
#include <device.h>
#include <drivers/sensor.h>

#include "app_sensor.h"

int app_sensor_evironmental_setup(void)
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

int app_sensor_motion_setup(void)
{
	int rc;
	struct sensor_value acc[3], gyr[3];
	const struct device *dev = device_get_binding("BMI270");
	struct sensor_value full_scale, sampling_freq, oversampling;

	if (dev == NULL) {
		printf("Could not get BMI270 device\n");
		return -1;
	}

	/* Set accelerometer scale, frequency, and mode. */
	full_scale.val1 = 2;       /* 2G scale range */
	full_scale.val2 = 0;
	sampling_freq.val1 = 100;  /* 100Hz frequency */
	sampling_freq.val2 = 0;
	oversampling.val1 = 1;     /* Normal mode */
	oversampling.val2 = 0;

	rc = sensor_attr_set(dev, SENSOR_CHAN_ACCEL_XYZ, SENSOR_ATTR_FULL_SCALE,
			&full_scale);
	if (rc != 0) {
		printf("%s setting accel full_scale failed, rc=%d\n", __func__, rc);
		return rc;
	}
	rc = sensor_attr_set(dev, SENSOR_CHAN_ACCEL_XYZ, SENSOR_ATTR_OVERSAMPLING,
			&oversampling);
	if (rc != 0) {
		printf("%s setting accel oversampling failed, rc=%d\n", __func__, rc);
		return rc;
	}
	rc = sensor_attr_set(dev, SENSOR_CHAN_ACCEL_XYZ,
			SENSOR_ATTR_SAMPLING_FREQUENCY,
			&sampling_freq);
	if (rc != 0) {
		printf("%s setting accel sampling_freq failed, rc=%d\n", __func__, rc);
		return rc;
	}

	/* Set gyroscope scale, frequency, and mode. */
	full_scale.val1 = 500;     /* dps */
	full_scale.val2 = 0;
	sampling_freq.val1 = 100;  /* 100Hz. Performance mode */
	sampling_freq.val2 = 0;
	oversampling.val1 = 1;     /* Normal mode */
	oversampling.val2 = 0;

	rc = sensor_attr_set(dev, SENSOR_CHAN_GYRO_XYZ, SENSOR_ATTR_FULL_SCALE,
			&full_scale);
	if (rc != 0) {
		printf("%s setting gyro full_scale failed, rc=%d\n", __func__, rc);
		return rc;
	}
	rc = sensor_attr_set(dev, SENSOR_CHAN_GYRO_XYZ, SENSOR_ATTR_OVERSAMPLING,
			&oversampling);
	if (rc != 0) {
		printf("%s setting gyro oversampling failed, rc=%d\n", __func__, rc);
		return rc;
	}
	rc = sensor_attr_set(dev, SENSOR_CHAN_GYRO_XYZ,
			SENSOR_ATTR_SAMPLING_FREQUENCY,
			&sampling_freq);
	if (rc != 0) {
		printf("%s setting gyro sampling_freq failed, rc=%d\n", __func__, rc);
		return rc;
	}

	/* Wait for intial samples */
	k_sleep(K_MSEC(100));

	sensor_sample_fetch(dev);

	sensor_channel_get(dev, SENSOR_CHAN_ACCEL_XYZ, acc);
	sensor_channel_get(dev, SENSOR_CHAN_GYRO_XYZ, gyr);

	printf("BMI270 AX: %d.%06d; AY: %d.%06d; AZ: %d.%06d;\n"
	       "       GX: %d.%06d; GY: %d.%06d; GZ: %d.%06d;\n",
		acc[0].val1, acc[0].val2,
		acc[1].val1, acc[1].val2,
		acc[2].val1, acc[2].val2,
		gyr[0].val1, gyr[0].val2,
		gyr[1].val1, gyr[1].val2,
		gyr[2].val1, gyr[2].val2);

	return 0;
}
