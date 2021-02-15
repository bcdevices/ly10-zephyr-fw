// SPDX-License-Identifier: Apache-2.0

//
// Copyright (c) 2019-2021 Blue Clover Devices
//

/* app_buzzer.c - Buzzer interface */

#include <zephyr.h>
#include <device.h>
#include <drivers/pwm.h>

#include "app_buzzer.h"

#define PERIOD_INIT    1500
#define BUZZER_PIN     22
#define BEEP_DURATION  K_MSEC(10)
#define PAUSE_DURATION  K_MSEC(1)
#define US_TO_HZ(_us)  (USEC_PER_SEC / (_us))

#define PWM_NODE DT_ALIAS(pwm_buzzer)

#if DT_NODE_HAS_STATUS(PWM_NODE, okay)
#define PWM_LABEL DT_LABEL(PWM_NODE)
#define PWM_CHANNEL BUZZER_PIN
#else
#error "Unsupported board: no pwm-buzzer DT alias"
#define PWM_LABEL 0
#define PWM_CHANNEL 0
#endif

static uint32_t period = PERIOD_INIT;

static uint32_t note_periods[] = {
	1000000U / 988,         /* B */
	1000000U / 880,         /* A */
	1000000U / 784,         /* G */
	1000000U / 699,         /* F */
	1000000U / 659,         /* E */
	1000000U / 587,         /* D */
	1000000U / 523          /* C */
};

#define ARRAY_LEN(a) (sizeof(a) / sizeof((a)[0]))

int app_buzzer_setup(void)
{
	const struct device *pwm;

	pwm = device_get_binding(PWM_LABEL);
	if (pwm == NULL) {
		return -1;
	}

	for (int i = 0; i < ARRAY_LEN(note_periods); i++) {
		period = note_periods[i];
		pwm_pin_set_usec(pwm, PWM_CHANNEL, period, period / 2U, 0);
		k_sleep(BEEP_DURATION);
		pwm_pin_set_usec(pwm, PWM_CHANNEL, period, 0, 0);
		k_sleep(PAUSE_DURATION);
	}

	return 0;
}
