# Tips

## How to modify devicetree

QEMU generates its own devicetree according to the options.

To obtain the devicetree that QEMU generates, add `-machine dumpdtb=qemu.dtb`.

You need to convert dtb to dts, modify it, and convert dts back to dtb.

```
dtc qemu.dtb > qemu.dts
dtc qemu.dts > custom.dtb
```

Once dtb is ready, add `-dtb custom.dtb`.
