# SPDX-License-Identifier: GPL-2.0
#
# Makefile for the Linux Bluetooth HCI device drivers.
#

ifneq ($(KERNELRELEASE),)

obj-m	+= btbcm_git.o
obj-m	+= btintel_git.o
obj-m	+= btmtk_git.o
obj-m	+= btrtl_git.o
obj-m	+= btusb_git.o

ccflags-y += -DCONFIG_BT_HCIBTUSB_AUTOSUSPEND -DCONFIG_BT_HCIBTUSB_POLL_SYNC
ccflags-y += -DCONFIG_BT_RTL -DCONFIG_BT_HCIBTUSB_RTL
ccflags-y += -DCONFIG_BT_MTK -DCONFIG_BT_HCIBTUSB_MTK
ccflags-y += -Wno-declaration-after-statement 

else

KVER ?= `uname -r`
KDIR ?= /lib/modules/$(KVER)/build
MODDIR ?= /lib/modules/$(KVER)/extra/bluetooth
FWDIR := /lib/firmware/rtl_bt

modules:
	$(MAKE) -j`nproc` -C $(KDIR) M=$$PWD modules

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean

install:
	strip -g *.ko
	@install -Dvm 644 -t $(MODDIR) *.ko
	@install -Dvm 644 -t /etc/modprobe.d blacklist-btusb.conf
	depmod -a $(KVER)

install_fw:
	rm -rf $(FWDIR)
	@cp -Pvr firmware $(FWDIR)
	
uninstall:
	@rm -rvf $(MODDIR)
	@rm -vf /etc/modprobe.d/blacklist-btusb.conf
	@rmdir --ignore-fail-on-non-empty /lib/modules/$(KVER)/extra || true
	depmod -a $(KVER)

endif
