// SPDX-License-Identifier: Apache-2.0

//
// Copyright (c) 2019-2021 Blue Clover Devices
//

/* app_ble.c - Application BLE handling */

#include <bluetooth/bluetooth.h>
#include <bluetooth/conn.h>
#include <bluetooth/gatt.h>
#include <bluetooth/hci.h>
#include <bluetooth/uuid.h>
#include <controller/include/ll.h>

#include "app_ble.h"

static const struct bt_data ad[] = {
	BT_DATA_BYTES(BT_DATA_FLAGS, (BT_LE_AD_GENERAL | BT_LE_AD_NO_BREDR)),
	BT_DATA_BYTES(BT_DATA_UUID16_ALL, 0x0a, 0x18),
};

static void connected(struct bt_conn *conn, uint8_t err)
{
	if (err) {
		printk("Connection failed (err %u)\n", err);
	} else {
		printk("Connected\n");
	}
}

static void disconnected(struct bt_conn *conn, uint8_t reason)
{
	printk("Disconnected (reason %u)\n", reason);
}

static struct bt_conn_cb conn_callbacks = {
	.connected = connected,
	.disconnected = disconnected,
};

int app_ble(void)
{
	/* Bluetooth */
	int err;

	err = bt_enable(NULL);
	if (err) {
		printk("Bluetooth init failed (err %d)\n", err);
		return err;
	}
	bt_conn_cb_register(&conn_callbacks);
	printk("BCD Demo Board Bluetooth initialized\n");

	err = bt_le_adv_start(BT_LE_ADV_CONN_NAME, ad, ARRAY_SIZE(ad), NULL, 0);
	if (err) {
		printk("Advertising failed to start (err %d)\n", err);
		return err;
	}
	printk("Advertising successfully started on the Demo Board\n");

	// Get MAC Address
	// '1' as first parameter indicates we are seeking the 'random'
	// BD address
	uint8_t *bd_addr = (uint8_t *) ll_addr_get(1);

	printk("Random BD Address: %02x:%02x:%02x:%02x:%02x:%02x\n",
	       bd_addr[5], bd_addr[4], bd_addr[3],
	       bd_addr[2], bd_addr[1], bd_addr[0]);
	return 0;
}
