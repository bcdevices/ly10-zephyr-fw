//
// Copyright (c) 2019 Blue Clover Devices
//
// SPDX-License-Identifier: Apache-2.0
//

/* app_buzzer.c - Buzzer interface */

#include <zephyr.h>
#include <device.h>
#include <sensor.h>
#include <stdio.h>
#include <gpio.h>
#include <pwm.h>

#define PERIOD_INIT    1500
#define BUZZER_PIN     22
#define BEEP_DURATION  K_MSEC(10)
#define PAUSE_DURATION  K_MSEC(1)
#define US_TO_HZ(_us)  (USEC_PER_SEC / (_us))

#if defined(CONFIG_SOC_FAMILY_NRF)
#if defined(CONFIG_PWM_NRF5_SW)
#define PWM_DRIVER CONFIG_PWM_NRF5_SW_0_DEV_NAME
#else
#define PWM_DRIVER DT_NORDIC_NRF_PWM_PWM_0_LABEL
#endif				/* CONFIG_PWM_NRF5_SW */
#define PWM_CHANNEL BUZZER_PIN
#elif defined(PWM_BUZZER0_PWM_CONTROLLER) && defined(PWM_BUZZER0_PWM_CHANNEL)
/* get the defines from dt (based on alias 'pwm-buzzer0') */
#define PWM_DRIVER      PWM_BUZZER0_PWM_CONTROLLER
#define PWM_CHANNEL     PWM_BUZZER0_PWM_CHANNEL
#else
#error "Choose supported PWM driver"
#endif

static u32_t period = PERIOD_INIT;

static u32_t note_periods[] = {
    1000000U / 988,		/* B */
    1000000U / 880,		/* A */
    1000000U / 784,		/* G */
    1000000U / 699,		/* F */
    1000000U / 659,		/* E */
    1000000U / 587,		/* D */
    1000000U / 523		/* C */
};

#define ARRAY_LEN(a) (sizeof(a)/sizeof((a)[0]))

int app_buzzer_setup(void)
{
    struct device *pwm;

    pwm = device_get_binding(PWM_DRIVER);
    if (NULL == pwm) {
	return -1;
    }

    for (int i = 0; i < ARRAY_LEN(note_periods); i++) {
	period = note_periods[i];
	pwm_pin_set_usec(pwm, PWM_CHANNEL, period, period / 2U);
	k_sleep(BEEP_DURATION);
	pwm_pin_set_usec(pwm, PWM_CHANNEL, period, 0);
	k_sleep(PAUSE_DURATION);
    }

    return 0;
}
