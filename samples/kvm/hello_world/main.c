#include <fcntl.h>
#include <linux/kvm.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>

#include "rom/rom.h"

#define ROM_SIZE 0x1000 // 4096 bytes

int main(void) {
  int kvmfd = open("/dev/kvm", O_RDWR);
  int vmfd = ioctl(kvmfd, KVM_CREATE_VM, 0);

  // Allocate memory which will be assigned to VM as RAM.
  unsigned char *mem = mmap(NULL, ROM_SIZE, PROT_READ | PROT_WRITE,
                            MAP_SHARED | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
  // Locate the ROM binary at the beginning of the RAM.
  memcpy(mem, rom_bin, sizeof(rom_bin));
  struct kvm_userspace_memory_region region = {
      .guest_phys_addr = 0, // Physical address from the guest point of view
                            // where the mem to be mapped.
      .memory_size = ROM_SIZE,
      .userspace_addr = (unsigned long long)
          mem, // Pointer to the memory allocated for the guest.
  };
  // Assign the RAM to the guest physical memory slot.
  ioctl(vmfd, KVM_SET_USER_MEMORY_REGION, &region);

  // Initialize vCPU0.
  int vcpufd = ioctl(vmfd, KVM_CREATE_VCPU, 0);
  struct kvm_sregs sregs; // Control registers such as cr0, cr3, and cr4
  ioctl(vcpufd, KVM_GET_SREGS, &sregs);
  // Leverage segmentation feature to tell vCPU that the instructions start from
  // 0x0. Note that cs stands for code segment.
  sregs.cs.base = 0;
  sregs.cs.selector = 0;
  ioctl(vcpufd, KVM_SET_SREGS, &sregs);
  // Generic registers such as pc, sp, rip
  struct kvm_regs regs = {
      // It should match CS registers.
      .rip = 0x0, // Return instruction pointer
      // The second bit is reserved and must be 1.
      .rflags = 0x02, // Register that manages CPU status
  };
  ioctl(vcpufd, KVM_SET_REGS, &regs);

  // KVM_RUN ioctl communicates with userspace via a shared memory region.
  // KVM_GET_VCPU_MMAP_SIZE ioctl returns the size of that region.
  size_t mmap_size = ioctl(kvmfd, KVM_GET_VCPU_MMAP_SIZE, NULL);
  struct kvm_run *run =
      mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, vcpufd, 0);

  bool is_running = true;
  while (is_running) {
    // Switch to the guest vCPU context.
    ioctl(vcpufd, KVM_RUN, NULL);

    switch (run->exit_reason) {
    case KVM_EXIT_HLT:
      is_running = false;
      break;

    case KVM_EXIT_IO:
      if (run->io.port == 0x01 && run->io.direction == KVM_EXIT_IO_OUT) {
        putchar(*(char *)((unsigned char *)run + run->io.data_offset));
      }
    }
  }

  putchar('\n');

  return 0;
}
