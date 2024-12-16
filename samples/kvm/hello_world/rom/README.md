# `rom.S`

It contains assembly codes which will be executed in VM.

# `rom.o`

Object file compiled from `rom.S`.

```
$ gcc -Wall -Wextra -nostdinc -nostdlib -fno-builtin -c -o rom.o rom.S
$ readelf -aW rom.o
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              REL (Relocatable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x0
  Start of program headers:          0 (bytes into file)
  Start of section headers:          152 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           0 (bytes)
  Number of program headers:         0
  Size of section headers:           64 (bytes)
  Number of section headers:         5
  Section header string table index: 4

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        0000000000000000 000040 000035 00  AX  0   0  1
  [ 2] .data             PROGBITS        0000000000000000 000075 000000 00  WA  0   0  1
  [ 3] .bss              NOBITS          0000000000000000 000075 000000 00  WA  0   0  1
  [ 4] .shstrtab         STRTAB          0000000000000000 000075 00001c 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), l (large), p (processor specific)

There are no section groups in this file.

There are no program headers in this file.

There is no dynamic section in this file.

There are no relocations in this file.
No processor specific unwind information to decode

No version information found in this file.
```

According to `readelf` output, the format of `rom.o` is as follows.

```
-----------------------------------------------------------------------------
| ELF Header (64 bytes)                                                     |
-----------------------------------------------------------------------------
| Program Headers (0 bytes)                                                 |
-----------------------------------------------------------------------------
|                                | .text (53 bytes)                         |
|                                |------------------------------------------|
| Sections (88 bytes)            | .shstrtab (28 bytes)                     |
|                                |------------------------------------------|
|                                | Zero Padding for 0x8 Alignment (7 bytes) |
-----------------------------------------------------------------------------
| NULL Section Header (64 bytes) | NULL (64 bytes)                          |
-----------------------------------------------------------------------------
|                                | .text (64 bytes)                         |
|                                |------------------------------------------|
|                                | .data (64 bytes)                         |
| Section Headers (256 bytes)    |------------------------------------------|
|                                | .bss (64 bytes)                          |
|                                |------------------------------------------|
|                                | .shstrtab (64 bytes)                     |
-----------------------------------------------------------------------------
```

`.shstrtab` contains the list of section names.

```
$ readelf -x4 rom.o
Hex dump of section '.shstrtab':
  0x00000000 002e7368 73747274 6162002e 74657874 ..shstrtab..text
  0x00000010 002e6461 7461002e 62737300          ..data..bss.
```

# `rom.bin`

Binary file compiled from `rom.o` by linker according to `rom.ld`.

```
$ ld -s -x -T rom.ld -o rom.bin rom.o
```

`rom.bin` is exactly the same as `.text` section of `rom.o`.

```
$ xxd rom.bin
00000000: b048 e601 b065 e601 b06c e601 b06c e601  .H...e...l...l..
00000010: b06f e601 b02c e601 b020 e601 b057 e601  .o...,... ...W..
00000020: b06f e601 b072 e601 b06c e601 b064 e601  .o...r...l...d..
00000030: b021 e601 f4                             .!...

$ readelf -x1 rom.o
Hex dump of section '.text':
  0x00000000 b048e601 b065e601 b06ce601 b06ce601 .H...e...l...l..
  0x00000010 b06fe601 b02ce601 b020e601 b057e601 .o...,... ...W..
  0x00000020 b06fe601 b072e601 b06ce601 b064e601 .o...r...l...d..
  0x00000030 b021e601 f4                         .!...
```

## `rom.ld`

Linker script.

```
OUTPUT_FORMAT("binary");

SECTIONS
{
	.text	: {*(.text)}
}
```

# `rom.h`

```
$ xxd -i rom.bin | tee rom.h
unsigned char rom_bin[] = {
  0xb0, 0x48, 0xe6, 0x01, 0xb0, 0x65, 0xe6, 0x01, 0xb0, 0x6c, 0xe6, 0x01,
  0xb0, 0x6c, 0xe6, 0x01, 0xb0, 0x6f, 0xe6, 0x01, 0xb0, 0x2c, 0xe6, 0x01,
  0xb0, 0x20, 0xe6, 0x01, 0xb0, 0x57, 0xe6, 0x01, 0xb0, 0x6f, 0xe6, 0x01,
  0xb0, 0x72, 0xe6, 0x01, 0xb0, 0x6c, 0xe6, 0x01, 0xb0, 0x64, 0xe6, 0x01,
  0xb0, 0x21, 0xe6, 0x01, 0xf4
};
unsigned int rom_bin_len = 53;
```
