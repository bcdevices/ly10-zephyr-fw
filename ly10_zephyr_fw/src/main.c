/* main.c - Application main entry point */


//
// Confidential!!!
// Source code property of Blue Clover Devices.
//
// Demonstration, distribution, replication, or other use of the
// source codes is NOT permitted without prior written consent
// from Blue Clover Devices.
//

#include <zephyr/types.h>
#include <stddef.h>
#include <string.h>
#include <errno.h>
#include <misc/printk.h>
#include <misc/byteorder.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/conn.h>
#include <bluetooth/uuid.h>
#include <bluetooth/gatt.h>
#include <led_strip.h>
#include <device.h>
#include <spi.h>
#include <misc/util.h>
#include <controller/include/ll.h>
#include <gpio.h>
#include <zephyr.h>

#define GPIO_OUT_DRV_NAME "GPIO_0"
#define GPIO_PWR_EN  25
#define STRIP_NUM_LEDS 4
#define DELAY_TIME K_MSEC(100)

static const struct led_rgb colors[] = {
	{ .r = 0xff, .g = 0x00, .b = 0x00, }, /* red */
	{ .r = 0x00, .g = 0xff, .b = 0x00, }, /* green */
	{ .r = 0x00, .g = 0x00, .b = 0xff, }, /* blue */
};

static const struct led_rgb black = {
	.r = 0x00,
	.g = 0x00,
	.b = 0x00,
};

struct led_rgb strip_colors[STRIP_NUM_LEDS];

const struct led_rgb *color_at(size_t time, size_t i)
{
	size_t rgb_start = time % STRIP_NUM_LEDS;

	if (rgb_start <= i && i < rgb_start + ARRAY_SIZE(colors)) {
		return &colors[i - rgb_start];
	} else {
		return &black;
	}
}


static const struct bt_data ad[] = {
	BT_DATA_BYTES(BT_DATA_FLAGS, (BT_LE_AD_GENERAL | BT_LE_AD_NO_BREDR)),
	BT_DATA_BYTES(BT_DATA_UUID16_ALL, 0x0a, 0x18),
};

static void connected(struct bt_conn *conn, u8_t err)
{
	if (err) {
		printk("Connection failed (err %u)\n", err);
	} else {
		printk("Connected\n");
	}
}

static void disconnected(struct bt_conn *conn, u8_t reason)
{
	printk("Disconnected (reason %u)\n", reason);
}

static struct bt_conn_cb conn_callbacks = {
	.connected = connected,
	.disconnected = disconnected,
};

void main(void)
{



	struct device *gpio_out_dev;
	int ret;


	gpio_out_dev = device_get_binding(GPIO_OUT_DRV_NAME);
	if (!gpio_out_dev) {
		printk("Cannot find %s!\n", GPIO_OUT_DRV_NAME);
		return;
	}



	/* GPIO output */
	ret = gpio_pin_configure(gpio_out_dev, GPIO_PWR_EN, (GPIO_DIR_OUT));

		printk("Toggling pin %d\n", GPIO_PWR_EN);

		ret = gpio_pin_write(gpio_out_dev, GPIO_PWR_EN, 1);



	/* Bluetooth */
	int err;

	err = bt_enable(NULL);
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return;
	}

	printk("BCD Demo Board Bluetooth initialized\n");

	bt_conn_cb_register(&conn_callbacks);

	err = bt_le_adv_start(BT_LE_ADV_CONN_NAME, ad, ARRAY_SIZE(ad), NULL, 0);
	if (err) {
		printk("Advertising failed to start (err %d)\n", err);
		return;
	}

	printk("Advertising successfully started on the Demo Board\n");
    
        // Get MAC Address and store in Memory
    u8_t * temp_bd_addr = (u8_t *)ll_addr_get(1, NULL); // '1' as first parameter indicates we are seeking the 'random' BD address
    u8_t volatile * bd_addr = (u8_t *)0x20005000;

    for (int i = 0; i < 6; i++) {
        bd_addr[i] = temp_bd_addr[i];
    }

	printk("Random BD Address: %02x:%02x:%02x:%02x:%02x:%02x\n",
           bd_addr[5], bd_addr[4], bd_addr[3],
           bd_addr[2], bd_addr[1], bd_addr[0]);



	/* APA102 Strip */
	struct device *strip;
		size_t i, time;

	strip = device_get_binding(DT_APA_APA102_0_LABEL);

	printk("Displaying pattern on strip\n");
	time = 0;

	while (1) {

		for (i = 0; i < STRIP_NUM_LEDS; i++) {

			memcpy(&strip_colors[i], color_at(time, i), sizeof(strip_colors[i]));

			}
			led_strip_update_rgb(strip, strip_colors, STRIP_NUM_LEDS);
			k_sleep(DELAY_TIME);
			time++;
		}

}
