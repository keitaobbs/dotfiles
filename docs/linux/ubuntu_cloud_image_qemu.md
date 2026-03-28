# Ubuntu Cloud Image: Internals and QEMU Boot Flow

## What is Ubuntu Cloud Image?

Ubuntu Cloud Image is a pre-configured, lightweight version of Ubuntu designed to boot instantly on cloud platforms like AWS or Azure. It removes the manual installation process by using `cloud-init` to automatically handle setup tasks like security keys and networking.

## Ubuntu Cloud Image Structure

When we download and inspect an ARM64 image (like Ubuntu 24.04 Noble), we can see the layout designed for UEFI-based booting.

```console
$ wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-arm64.img
$ qemu-img convert -f qcow2 -O raw noble-server-cloudimg-arm64.img noble.raw
$ fdisk -l noble.raw
...
Device        Start     End Sectors  Size Type
noble.raw1  2099200 7339998 5240799  2.5G Linux filesystem
noble.raw15    2048  204800  202753   99M EFI System
noble.raw16  206848 2097152 1890305  923M Linux extended boot
```

#### Disk Layout Overview

The partition order is non-linear to allow the **Root Partition (1)** to be easily expanded by cloud hypervisors without moving the EFI or Boot partitions. By placing Partition 1 at the physical end of the disk (highest sectors), any new space added to the virtual drive appears immediately adjacent to it. This allows `cloud-init` to "stretch" the root filesystem instantly into the new space without the risk or time required to relocate the static boot partitions.

| Partition | Start Sector | Role | Filesystem |
| --- | --- | --- | --- |
| **15** | 2,048 | **ESP (EFI System Partition)** | FAT32 |
| **16** | 206,848 | **Extended Boot (/boot)** | EXT4 |
| **1** | 2,099,200 | **Root FS (/)** | EXT4 |

## The Boot Chain

### 1. The EFI Partition (ESP)

The ESP is the entry point for the firmware. It contains the GRUB binary and a "stub" configuration file that points the bootloader to the real configuration on the Boot partition.

```console
$ dd if=noble.raw of=efi_part bs=512 skip=2048 count=202753
$ mount -t vfat efi_part mnt_efi; find mnt_efi -type f
./EFI/ubuntu/grubaa64.efi
./EFI/ubuntu/grub.cfg
```

The `grub.cfg` here doesn't contain the menu; it contains a logic bridge:

```
search.fs_uuid eb818ce9-7c0b-4d07-8519-1c1b70f64beb root
set prefix=($root)'/grub'
configfile $prefix/grub.cfg
```

It searches for the filesystem UUID belonging to **Partition 16** (Boot) and redirects GRUB to look there for the full menu.

### 2. The BOOT Partition

This partition houses the Linux Kernel (`vmlinuz`) and the Initial RAM Disk (`initrd`).

```console
$ dd if=noble.raw of=boot_part bs=512 skip=206848 count=1890305
$ mount -t ext4 boot_part mnt_boot; ls mnt_boot
vmlinuz-6.8.0-101-generic    initrd.img-6.8.0-101-generic    grub/
```

The `grub.cfg` on this partition defines the specific paths for the bootloader to load the kernel and initrd into memory.

### 3. The ROOT Partition

This is the final destination containing the Ubuntu userland.

```console
$ dd if=noble.raw of=root_part bs=512 skip=2099200 count=5240799
$ mount -t ext4 root_part mnt_root; ls mnt_root
bin/  etc/  home/  usr/  var/ ...
```

In modern Ubuntu images, `/boot` inside the Root partition is often empty because it serves as the mount point for Partition 16.

## QEMU Boot Flow Summary

```bash
qemu-system-aarch64 \
  -m 2G \
  -smp 2 \
  -M virt \
  -cpu max \
  -enable-kvm \
  -snapshot \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -device virtio-net-pci,netdev=net0 \
  -bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd \
  -drive file=boot.img,format=qcow2 \
  -drive file=config.img,format=raw \
  -nographic \
  -serial mon:stdio
```

* **`boot.img`**: The downloaded and potentially modified Ubuntu Cloud Image (the system disk).
* **`config.img`**: The NoCloud configuration disk created with `cloud-localds`.

When you execute the above QEMU command, the following handoff occurs across the internal structures we've analyzed:

1. **Firmware (EDK2/OVMF):** QEMU loads the UEFI firmware via the `-bios` flag. The firmware reads the GPT on `boot.img` and enters the EFI System Partition (**Partition 15**).
2. **Shim/GRUB:** The firmware executes `grubaa64.efi`. This is the first stage of the bootloader.
3. **The Bridge:** GRUB reads the initial `grub.cfg` on the EFI partition. It uses the `fs_uuid` to locate the Extended Boot Partition (**Partition 16**) and switches the configuration context to the full GRUB menu located there.
4. **Kernel Load:** GRUB reads the "real" configuration from Partition 16, loads the `vmlinuz` (kernel) and `initrd` into memory, and executes the kernel with the specified arguments (e.g., `root=LABEL=cloudimg-rootfs`).
5. **Userland:** The kernel identifies the Root Partition (**Partition 1**) by its label, mounts it as the root filesystem (`/`), and starts `systemd`.
6. **Cloud-Init & Configuration:** `systemd` launches `cloud-init`. This service detects the second drive (`config.img`), which was passed as a raw block device. It mounts this "seed" drive to fetch the `user-data` and `meta-data` required to finish the system setup (creating users, setting up SSH, etc.).

## Customizing the Kernel

To run specialized workloads, you may need to replace the standard Ubuntu Cloud Image kernel with a custom-built one.

### 1. Building the Custom Kernel

We build the kernel from the official Ubuntu Noble (24.04) source. We use the `generic` flavor as a base configuration to ensure all standard features and hardware supports are included. We also disable kernel signing constraints to allow the self-built kernel to boot without official Ubuntu certificates.

```bash
ubuntu_base_url="http://jp.archive.ubuntu.com/ubuntu"
ubuntu_security_base_url="http://security.ubuntu.com/ubuntu"
pool_dir="pool/main/l/linux"
ksrc_base_url="${ubuntu_base_url}/${pool_dir}"
ksrc_security_base_url="${ubuntu_security_base_url}/${pool_dir}"
ubuntu_kver="6.8.0-106.106"
dsc_file="linux_${ubuntu_kver}.dsc"
orig_ksrc_file="linux_${ubuntu_kver%%-*}.orig.tar.gz"
diff_ksrc_file="linux_${ubuntu_kver}.diff.gz"

wget "${ksrc_security_base_url}/${dsc_file}" || \
wget "${ksrc_base_url}/${dsc_file}"

wget "${ksrc_security_base_url}/${orig_ksrc_file}" || \
wget "${ksrc_base_url}/${orig_ksrc_file}"

wget "${ksrc_security_base_url}/${diff_ksrc_file}" || \
wget "${ksrc_base_url}/${diff_ksrc_file}"

dpkg-source --require-strong-checksums --extract "${dsc_file}"
pushd "linux-${ubuntu_kver%-*}" > /dev/null

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
eval "$(dpkg-architecture -a arm64 -s)"

custom_flavour="custom"
ubuarch_flavour="arm64-${custom_flavour}"

# Add custom flavour
sed -i "/^flavours[[:space:]]*=/ s/$/ ${custom_flavour}/" debian.master/rules.d/arm64.mk
sed -i "/^# FLAVOUR:/ s/$/ ${ubuarch_flavour}/" debian.master/config/annotations
cp debian.master/control.d/generic.inclusion-list debian.master/control.d/${custom_flavour}.inclusion-list
cat << EOF > debian.master/control.d/vars.${custom_flavour}
arch="arm64"
supported="Custom Flavour"
target="Geared toward my special usecase."
desc="=HUMAN= SMP"
bootloader="grub-efi-arm64 [arm64] | flash-kernel [arm64]"
provides="kvm-api-4, redhat-cluster-modules, ivtv-modules, virtualbox-guest-modules"
EOF

chmod a+x debian/rules
chmod a+x debian/scripts/*
chmod a+x debian/scripts/misc/*

# Use generic flavour as a base configuration
./debian/scripts/misc/annotations --arch arm64 --flavour generic --export > .config

# Disable trusted key requirements for self-built packages
scripts/config --disable SYSTEM_TRUSTED_KEYS
scripts/config --disable SYSTEM_REVOCATION_KEYS
scripts/config --set-str CONFIG_SYSTEM_TRUSTED_KEYS ""
scripts/config --set-str CONFIG_SYSTEM_REVOCATION_KEYS ""

# Import current config as custom flavour
./debian/scripts/misc/annotations --arch arm64 --flavour ${custom_flavour} --import .config

# Build the kernel and generate Debian packages
make mrproper
fakeroot debian/rules clean
fakeroot debian/rules binary-${custom_flavour}

popd > /dev/null
```

### 2. Injecting the Kernel into the Cloud Image

Since the Cloud Image uses a multi-partition layout, we must mount the partitions in a nested structure before using `chroot` to install the kernel. This ensures that the kernel and GRUB files are written to the correct physical locations (Partition 16 and 15).

```bash
ubuntu_cloud_image=uci.raw

# Setup loopback device for the raw image
sudo losetup -fP "${ubuntu_cloud_image}"
LOOP_DEV=$(losetup -j "${ubuntu_cloud_image}" | cut -d':' -f1)

# Create mount points and establish the nested hierarchy
mkdir -p mnt_root
sudo mount ${LOOP_DEV}p1 mnt_root            # Root FS (Partition 1)
sudo mount ${LOOP_DEV}p16 mnt_root/boot      # Extended Boot (Partition 16)
sudo mount ${LOOP_DEV}p15 mnt_root/boot/efi  # ESP (Partition 15)

# Bind system directories for the chroot environment
for dir in /dev /dev/pts /proc /sys /run; do
    sudo mount --bind $dir mnt_root$dir
done

# Copy the newly built kernel package into the image
sudo cp linux-*.deb mnt_root/tmp

# Execute updates within the chroot environment
sudo chroot mnt_root /bin/bash <<'EOF'
# Cleanup old kernel files to save space
rm -f /boot/vmlinuz* /boot/initrd.img* /boot/config* /boot/System.map*
rm -rf /lib/modules/*

# Install the custom kernel
dpkg -i /tmp/linux-*.deb

# Regenerate the RAMDisk and update the GRUB menu
echo "GRUB_DEVICE='LABEL=cloudimg-rootfs'" >> /etc/default/grub
update-initramfs -c -k all
update-grub
sed -i '/GRUB_DEVICE=/d' /etc/default/grub
EOF

# Cleanup and unmount
sudo rm mnt_root/tmp/linux-*.deb
sudo umount -R mnt_root
sudo losetup -d ${LOOP_DEV}
```

