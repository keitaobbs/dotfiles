.PHONY: push pull runserver __runserver stopserver shell run clean

ARCH = arm64

ifeq ($(ARCH),arm64)
QEMU = qemu-system-aarch64
MACHINE = virt
CPU = cortex-a76
CONSOLE = ttyAMA0
IMAGE = Image
else ifeq ($(ARCH),x86_64)
QEMU = qemu-system-x86_64
MACHINE = pc
CPU = Skylake-Client
CONSOLE = ttyS0
IMAGE = bzImage
else
$(error Unsupported architecture '$(ARCH)' is specified)
endif

push:
	@docker-compose cp Makefile.docker kbuild:/root
	@docker-compose cp init kbuild:/root
	@docker-compose cp lkm_sample kbuild:/root

pull: sd.img
	@docker-compose cp kbuild:/root/$(IMAGE) .
	@docker-compose cp kbuild:/root/rootfs.img .

sd.img:
	@docker-compose exec kbuild make -f Makefile.docker sd.img
	@docker-compose cp kbuild:/root/sd.img .

runserver: __runserver push

__runserver:
	@docker-compose up -d

stopserver:
	@docker-compose stop

shell:
	@docker-compose exec kbuild bash

run: pull
	@$(QEMU) \
		-smp 2 \
		-m 512M \
		-cpu $(CPU) \
		-machine $(MACHINE) \
		-kernel $(IMAGE) \
		-initrd rootfs.img \
		-nographic \
		-append "console=$(CONSOLE)" \
		-device sdhci-pci \
		-device sd-card,drive=mysd0 \
		-drive id=mysd0,if=none,format=raw,file=sd.img

clean:
	@rm Image bzImage rootfs.img sd.img
