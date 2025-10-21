obj-m += ws2812.o

ifeq ($(KERNELRELEASE),)

KVERSION ?= $(shell uname -r)
KDIR ?= /usr/lib/modules/$(KVERSION)/build
DESTDIR ?= /
DTC ?= dtc
PWD := $(shell pwd)

all: modules overlays

install: modules_install overlays_install

modules:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

modules_install:
	$(MAKE) -C $(KDIR) M=$(PWD) INSTALL_MOD_PATH=${DESTDIR} modules_install

overlays:
	${DTC} -@ -I dts -O dtb -o slice-cm3-ws2812.dtbo slice-cm3-ws2812.dts
	${DTC} -@ -I dts -O dtb -o slice-cm4s-ws2812.dtbo slice-cm4s-ws2812.dts

overlays_install:
	cp slice-cm3-ws2812.dtbo ${DESTDIR}/boot/overlays
	cp slice-cm4s-ws2812.dtbo ${DESTDIR}/boot/overlays

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f slice-cm3-ws2812.dtbo
	rm -f slice-cm4s-ws2812.dtbo

endif
