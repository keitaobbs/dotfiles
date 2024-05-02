# SPDX-License-Identifier: GPL-2.0
obj-m += lkm_sample.o

all:
	make -C /root/linux M=$(PWD) modules

clean:
	make -C /root/linux M=$(PWD) clean
