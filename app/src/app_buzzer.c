//
// Confidential!!!
// Source code property of Blue Clover Devices.
//
// Demonstration, distribution, replication, or other use of the
// source codes is NOT permitted without prior written consent
// from Blue Clover Devices.
//

/* app_buzzer.c - Buzzer interface */

#include <zephyr.h>
#include <device.h>
#include <sensor.h>
#include <stdio.h>
#include <gpio.h>
#include <pwm.h>

#define PERIOD_INIT    1500
#define BUZZER_PIN 22
#define BEEP_DURATION  K_MSEC(60)
#define US_TO_HZ(_us)  (USEC_PER_SEC / (_us))

static u32_t period = PERIOD_INIT;

int app_buzzer_setup(void)
{
    struct device *pwm;

    pwm = device_get_binding(CONFIG_PWM_NRF5_SW_0_DEV_NAME);
    if (NULL == pwm) {
        return -1;
    }

    pwm_pin_set_usec(pwm, BUZZER_PIN, period, period / 2U);
    k_sleep(BEEP_DURATION);
    pwm_pin_set_usec(pwm, BUZZER_PIN, 0, 0);

    return 0;
}
