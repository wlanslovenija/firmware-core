REBOOT_WAIT=5 # seconds

node_reboot() {
	echo "Rebooting."
	
	reboot 2>/dev/null
	
	sleep "$REBOOT_WAIT"
	
	reboot -n -f 2>/dev/null
	
	sleep "$REBOOT_WAIT"
	
	echo b 2>/dev/null >/proc/sysrq-trigger
	
	exit 1
}

flashing_failed() {
	echo "Failed."
	
	if [[ "$DOWNLOAD_ONLY" -ne 0 ]]; then
		echo "In download only mode. Not rebooting."
		exit 1
	fi
	
	node_reboot
}

node_upgrade() {
	# Expects ROOT_IMAGE and/or KERNEL_IMAGE or FLASH_IMAGE defined with image filenames
	# Expects CONF_TGZ defined with configuration tgz archive filename (which does not need to exist)
	
	sync
	
	if [[ -n "$CONF_TGZ" ]]; then
		CONF_TGZ="-j $CONF_TGZ"
	fi
	
	if [[ -n "$FLASH_IMAGE" ]]; then
		echo "Flashing '$FLASH_IMAGE'."
		mtd $CONF_TGZ write "$FLASH_IMAGE" linux || flashing_failed
	else
		if [[ -n "$KERNEL_IMAGE" ]]; then
			echo "Flashing '$KERNEL_IMAGE'."
			mtd write "$KERNEL_IMAGE" vmlinux.bin.l7 || flashing_failed
		fi
		if [[ -n "$ROOT_IMAGE" ]]; then
			echo "Flashing '$ROOT_IMAGE'."
			mtd $CONF_TGZ write "$ROOT_IMAGE" rootfs || flashing_failed
		fi
	fi
	
	echo "Success."
	
	node_reboot
}
