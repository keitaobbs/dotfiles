# IRQ Debugging Tips

## Check interrupt number and see the details of it

```console
$ cat /proc/interrupts
           CPU0       CPU1
 11:        261        256 GIC-0  27 Level     arch_timer
 13:         16          0 GIC-0  33 Level     uart-pl011
 16:          0          0       MSI 16384 Edge      virtio0-config
 17:          0          0       MSI 16385 Edge      virtio0-input.0
 18:          0          0       MSI 16386 Edge      virtio0-output.0
 19:          0          0 GIC-0  34 Level     rtc-pl031
 20:        119          0 GIC-0  37 Level     mmc0
 21:          0          0 GIC-0  23 Level     arm-pmu
 22:          0          0 9030000.pl061   3 Edge      GPIO Key Poweroff
IPI0:        27         30       Rescheduling interrupts
IPI1:       201        266       Function call interrupts
IPI2:         0          0       CPU stop interrupts
IPI3:         0          0       CPU stop (for crash dump) interrupts
IPI4:         0          0       Timer broadcast interrupts
IPI5:         0          0       IRQ work interrupts
IPI6:         0          0       CPU wake-up interrupts
Err:          0

$ grep -r . /sys/kernel/irq/11
/sys/kernel/irq/11/wakeup:disabled
/sys/kernel/irq/11/hwirq:27
/sys/kernel/irq/11/actions:arch_timer
/sys/kernel/irq/11/type:level
/sys/kernel/irq/11/per_cpu_count:405,555
```

## Device wakeup capability

Device wakeup capability can be configured by the following functions.

```c
static inline int device_init_wakeup(struct device *dev, bool enable);
```

`device_init_wakeup` enables/disables both `dev->power.can_wakeup` and `dev->power.wakeup`.
When enable == true, it will create a wakeup source object, register it and attach it to the device.

Another way to enable device wakeup capability is specifying `wakeup-source` in devicetree.
For example, i2c core driver supports `wakeup-source` property in its probe function as follows.

```c
if (client->flags & I2C_CLIENT_WAKE) {
    int wakeirq;

    wakeirq = of_irq_get_byname(dev->of_node, "wakeup");
    if (wakeirq == -EPROBE_DEFER) {
        status = wakeirq;
        goto put_sync_adapter;
    }

    device_init_wakeup(&client->dev, true);
```

It will set irq specified with `wakeup` property as wakeup capable irq and enable device wakeup
capability with `device_init_wakeup`.

## IRQ status and its wakeup capability

IRQ wakeup capability is independent of device wakeup capability.
IRQ and its wakeup capability can be enabled/disabled at runtime by the following functions.

```c
void enable_irq(unsigned int irq);
void disable_irq(unsigned int irq);
static inline int enable_irq_wake(unsigned int irq);
static inline int disable_irq_wake(unsigned int irq);
```

To disable an irq means that the irq handler will not be called even if the irq is coming. To enable
an irq wakeup capability means that the device will wake up when the irq is coming.
