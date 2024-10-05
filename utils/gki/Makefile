.PHONY: pull runserver stopserver shell build run clean

pull:
	@docker-compose cp gki:/root/android-kernel/out/kernel_aarch64/dist/Image .

runserver:
	@docker-compose up -d

stopserver:
	@docker-compose stop

shell:
	@docker-compose exec gki bash

build:
	@docker-compose exec gki sh -c "tools/bazel build //common:kernel_aarch64_dist"
	@docker-compose exec gki sh -c "tools/bazel run //common:kernel_aarch64_dist"

run:
	@qemu-system-aarch64 \
		-smp 2 \
		-m 512M \
		-cpu cortex-a76 \
		-machine virt \
		-kernel Image \
		-initrd rootfs.img \
		-nographic \
		-append "console=ttyAMA0"

clean:
	@rm Image
