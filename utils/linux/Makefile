.PHONY: push pull runserver __runserver stopserver run-arm64 clean

push:
	@docker-compose cp Makefile.docker kbuild:/root
	@docker-compose cp init kbuild:/root

pull:
	@docker-compose cp kbuild:/root/Image .
	@docker-compose cp kbuild:/root/rootfs.img .

runserver: __runserver push

__runserver:
	@docker-compose up -d

stopserver:
	@docker-compose stop

run-arm64: pull
	@qemu-system-aarch64 \
		-m 512M \
		-cpu cortex-a53 \
		-M virt \
		-kernel Image \
		-initrd rootfs.img \
		-nographic \
		-append "console=ttyAMA0"

clean:
	@rm Image rootfs.img
