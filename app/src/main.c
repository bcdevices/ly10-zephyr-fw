//
// Confidential!!!
// Source code property of Blue Clover Devices.
//
// Demonstration, distribution, replication, or other use of the
// source codes is NOT permitted without prior written consent
// from Blue Clover Devices.
//

/* main.c - Application main entry point */

#include <zephyr.h>

#define DELAY_TIME K_MSEC(100)

extern int app_ble(void);
extern int app_ledstrip_setup(void);
extern int app_ledstrip_run(void);

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

    while (1) {
        err =  app_ledstrip_run();
        if (err) {
            return;
        }
	k_sleep(DELAY_TIME);
    }

}
