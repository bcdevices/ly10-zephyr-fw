//
// Confidential!!!
// Source code property of Blue Clover Devices.
//
// Demonstration, distribution, replication, or other use of the
// source codes is NOT permitted without prior written consent
// from Blue Clover Devices.
//

/* ledstrip.c - Application LED strip control */

#include <string.h>
#include <misc/printk.h>
#include <led_strip.h>
#include <gpio.h>

#define GPIO_OUT_DRV_NAME "GPIO_0"
#define GPIO_PWR_EN  25
#define STRIP_NUM_LEDS 4

static struct device *strip;
static size_t ledstrip_counter = 0;

static const struct led_rgb colors[] = {
    {.r = 0xff,.g = 0x00,.b = 0x00, },	/* red */
    {.r = 0x00,.g = 0xff,.b = 0x00, },	/* green */
    {.r = 0x00,.g = 0x00,.b = 0xff, },	/* blue */
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

int app_ledstrip_setup(void)
{
    struct device *gpio_out_dev;
    int ret;

    gpio_out_dev = device_get_binding(GPIO_OUT_DRV_NAME);
    if (!gpio_out_dev) {
	printk("Cannot find %s!\n", GPIO_OUT_DRV_NAME);
	return -1;
    }

    /* GPIO output */
    ret = gpio_pin_configure(gpio_out_dev, GPIO_PWR_EN, (GPIO_DIR_OUT));
    if (ret) {
	printk("Error configuring GPIO (err %d)\n", ret);
	return ret;
    }
    printk("Turning on 5V_LED Rail %d\n", GPIO_PWR_EN);

    ret = gpio_pin_write(gpio_out_dev, GPIO_PWR_EN, 1);
    if (ret) {
	printk("Error writing GPIO (err %d)\n", ret);
	return ret;
    }

    /* APA102 Strip */
    strip = device_get_binding(DT_APA_APA102_0_LABEL);
    if (!strip) {
	printk("Cannot find %s!\n", GPIO_OUT_DRV_NAME);
	return -1;
    }

    ledstrip_counter = 0;

    return 0;
}

int app_ledstrip_run(void) {
    size_t i;
    for (i = 0; i < STRIP_NUM_LEDS; i++) {
	memcpy(&strip_colors[i], color_at(ledstrip_counter, i),
	   sizeof(strip_colors[i]));
    }
    led_strip_update_rgb(strip, strip_colors, STRIP_NUM_LEDS);
    ledstrip_counter++;
    return 0;
}
