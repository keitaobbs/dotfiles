# Runtime Power Management Debugging Tips

## Wakelock

```console
$ cat /sys/kernel/debug/wakeup_sources
name              active_count event_count wakeup_count expire_count active_since total_time max_time last_change prevent_suspend_time
mmc0              0            0           0            0            0            0          0        0           0
alarmtimer.0.auto 0            0           0            0            0            0          0        0           0
9010000.pl031     0            0           0            0            0            0          0        0           0
deleted           0            0           0            0            0            0          0        0           0
```

Wakelock can be managed by the following functions.

```c
struct wakeup_source *wakeup_source_register(struct device *dev, const char *name);
void wakeup_source_unregister(struct wakeup_source *ws);
void __pm_stay_awake(struct wakeup_source *ws);
void pm_stay_awake(struct device *dev);
void __pm_relax(struct wakeup_source *ws);
void pm_relax(struct device *dev);
```

## IRQ handler is not called as expected throughout suspend/resume

IRQ handler is registered by the following functions.

```c
static inline int __must_check
request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
            const char *name, void *dev);
```

If `IRQF_NO_SUSPEND` flag is not specified, IRQ is disabled on suspend by `suspend_device_irqs`.
