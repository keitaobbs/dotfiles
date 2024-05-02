// SPDX-License-Identifier: GPL-2.0
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

static int __init lkm_sample_init(void) {
  pr_info("Hello, World!\n");
  return 0;
}

static void __exit lkm_sample_exit(void) {
  pr_info("Goodbye, World!\n");
}

module_init(lkm_sample_init);
module_exit(lkm_sample_exit);

MODULE_LICENSE("GPL");
