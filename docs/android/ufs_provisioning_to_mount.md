# UFS Provisioning and Mount Flow

## 1. UFS Provisioning

**Universal Flash Storage (UFS)** provisioning is the low-level process of carving physical NAND flash into **Logical Units (LUNs)**. Unlike standard SD cards, a single UFS chip can behave like multiple independent disks.

### Key Concepts

* **Configuration Descriptor:** A data structure written to the device (typically via `ufs-tool`) that defines the number, size, and attributes of each LUN.
* **Finalization (`bConfigDescrLock`):** Once this bit is set to `0x01`, the configuration is **permanent**. You cannot re-provision the chip after this point.
* **Kernel Mapping:** The Linux kernel detects each LUN as a separate SCSI block device.

```bash
# Example: Viewing LUNs as block devices
$ ls -d /sys/block/sd*
/sys/block/sda  # LUN0
/sys/block/sdb  # LUN1
/sys/block/sdc  # LUN2
```

---

## 2. Partitioning with GPT

Once LUNs are defined, they must be partitioned to hold data. Android primarily uses the **GUID Partition Table (GPT)** format. While a LUN behaves like a physical disk, the GPT defines the logical "slices" (partitions) within that disk.

### GPT Structure within a LUN

Each partitioned LUN contains a header and a table describing where each partition starts and ends.

| Component | Description |
| --- | --- |
| **MBR** | Protective Master Boot Record for legacy compatibility. |
| **GPT Header** | Contains the GUID and partition table size. |
| **Partition Table** | Defines the name, type, and UUID for each slice (e.g., `boot`, `system`). |
| **Partitions 1-N** | The actual data areas. |
| **Backup GPT** | A redundant copy at the end of the LUN for recovery. |

The kernel automatically enumerates these partitions:

```bash
# Checking partitions for each LUN
$ ls /dev/block/sda*
/dev/block/sda   # Entire LUN0
/dev/block/sda1  # Partition 1 on LUN0
/dev/block/sda2  # Partition 2 on LUN0
```

---

## 3. Android Device Node Creation (`by-name`)

In Android, mounting partitions by static names (like `sda1`) is risky because drive letters can change. Instead, Android uses **symbolic links** in `/dev/block/by-name/`.

### The Uevent Mechanism

1. **Kernel Discovery:** When the kernel detects a partition, it generates a **uevent**.
2. **Ueventd Processing:** Android's `ueventd` daemon listens to these events. It reads the `PARTNAME` attribute.
3. **Symlink Creation:** `ueventd` creates a link from the cryptic kernel name to the human-readable partition name.

**Example `uevent` data:**

```text
/sys/block/sda1/uevent:
DEVNAME=sda1
PARTN=1
PARTNAME=dummy  <-- ueventd uses this
PARTUUID=95e31229-7eb2-4796-838a-83d460f9a4a9
```

**Resulting Symlink:**

```bash
$ ls -l /dev/block/by-name/dummy
lrwxrwxrwx 1 root root 21 /dev/block/by-name/dummy -> /dev/block/sda1
```

---

## 4. Mounting the File System

Finally, the Android `init` process reads the **fstab** (File System Table) and uses these symbolic links to mount the partitions into the root filesystem.

```text
# Example fstab entry
/dev/block/by-name/userdata  /data  ext4  noatime,nosuid,nodev  wait,check
```
