# ELF: Executable and Linkable Format

## What is ELF?

ELF is a common standard file format for executable files, object code, shared libraries, and core
dumps. By design, the ELF format is flexible, extensible, and cross-platform.

```
    +---------------------------------------+
    | ELF Header (64 bytes)                 |
    +---------------------------------------+
 ++-| Program Headers                       |
 || +---------------------------------------+
 |+>|                 | .text               |<+
 || |                 |---------------------| |
 |+>|                 | .rodata             |<-+
 |  | Sections        |---------------------| ||
 +->|                 | ...                 | ||
 |  |                 |---------------------| ||
 +->|                 | .data               |<--+
    +---------------------------------------+ |||
    | Zero Padding for 0x8 Alignment        | |||
    +---------------------------------------+ |||
    | NULL Section Header (64 bytes)        | |||
    +---------------------------------------+ |||
    |                 | .text (64 bytes)    |-+||
    |                 |---------------------|  ||
    |                 | .rodata (64 bytes)  |--+|
    | Section Headers |---------------------|   |
    |                 | ...                 |   |
    |                 |---------------------|   |
    |                 | .data (64 bytes)    |---+
    +---------------------------------------+
```

Each program header contains segment information that is needed for run time execution.
Note that segment is a set of sections.

A sample `readelf -lW` output is shown below for reference.

```
Elf file type is EXEC (Executable file)
Entry point 0x401050
There are 13 program headers, starting at offset 64

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  PHDR           0x000040 0x0000000000400040 0x0000000000400040 0x0002d8 0x0002d8 R   0x8
  INTERP         0x000318 0x0000000000400318 0x0000000000400318 0x00001c 0x00001c R   0x1
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
  LOAD           0x000000 0x0000000000400000 0x0000000000400000 0x0004f8 0x0004f8 R   0x1000
  LOAD           0x001000 0x0000000000401000 0x0000000000401000 0x00016d 0x00016d R E 0x1000
  LOAD           0x002000 0x0000000000402000 0x0000000000402000 0x0000ec 0x0000ec R   0x1000
  LOAD           0x002df8 0x0000000000403df8 0x0000000000403df8 0x000220 0x000228 RW  0x1000
  DYNAMIC        0x002e08 0x0000000000403e08 0x0000000000403e08 0x0001d0 0x0001d0 RW  0x8
  NOTE           0x000338 0x0000000000400338 0x0000000000400338 0x000030 0x000030 R   0x8
  NOTE           0x000368 0x0000000000400368 0x0000000000400368 0x000044 0x000044 R   0x4
  GNU_PROPERTY   0x000338 0x0000000000400338 0x0000000000400338 0x000030 0x000030 R   0x8
  GNU_EH_FRAME   0x002014 0x0000000000402014 0x0000000000402014 0x000034 0x000034 R   0x4
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10
  GNU_RELRO      0x002df8 0x0000000000403df8 0x0000000000403df8 0x000208 0x000208 R   0x1

 Section to Segment mapping:
  Segment Sections...
   00
   01     .interp
   02     .interp .note.gnu.property .note.gnu.build-id .note.ABI-tag .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt
   03     .init .plt .plt.sec .text .fini
   04     .rodata .eh_frame_hdr .eh_frame
   05     .init_array .fini_array .dynamic .got .got.plt .data .bss
   06     .dynamic
   07     .note.gnu.property
   08     .note.gnu.build-id .note.ABI-tag
   09     .note.gnu.property
   10     .eh_frame_hdr
   11
   12     .init_array .fini_array .dynamic .got
```

Each section header contains section information that is needed for linking and relocation.

## The Lazy Binding

When a program is executed in Linux, the dynamic linker resolves references to symbols in the shared
libraries only when it is needed. In other words, the program doesn't know the address of a specific
function in a shared library, until this function is actually utilized.

The process of resolving symbols in run time, is known as lazy binding.

Procedure Linkage Table (PLT) and Global Offset Table (GOT) play an important role.

Let's assume the following simple code and its executable file `a.out`.

```c
// main.c
#include <stdio.h>

int main(int argc, char *argv[]) {
  puts("Hello World!");
  return 0;
}
```

```console
$ gcc -no-pie -g -O0 main.c
$ ldd a.out
        linux-vdso.so.1 (0x00007ffc0db2c000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ca21da00000)
        /lib64/ld-linux-x86-64.so.2 (0x00007ca21dc89000)
```

PLT sections contain executable code and consist of well-defined format stubs.

`.plt`/`.plt.sec` section is as follows.
A default stub at 0x401020 followed by a function stub at 0x401040.

```console
$ objdump -d -j .plt -j .plt.sec a.out
Disassembly of section .plt:

0000000000401020 <.plt>:
  401020:       ff 35 ca 2f 00 00       push   0x2fca(%rip)        # 403ff0 <_GLOBAL_OFFSET_TABLE_+0x8>
  401026:       ff 25 cc 2f 00 00       jmp    *0x2fcc(%rip)        # 403ff8 <_GLOBAL_OFFSET_TABLE_+0x10>
  40102c:       0f 1f 40 00             nopl   0x0(%rax)
  401030:       f3 0f 1e fa             endbr64
  401034:       68 00 00 00 00          push   $0x0
  401039:       e9 e2 ff ff ff          jmp    401020 <_init+0x20>
  40103e:       66 90                   xchg   %ax,%ax

Disassembly of section .plt.sec:

0000000000401040 <puts@plt>:
  401040:       f3 0f 1e fa             endbr64
  401044:       ff 25 b6 2f 00 00       jmp    *0x2fb6(%rip)        # 404000 <puts@GLIBC_2.2.5>
  40104a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
```

GOT is a data section and it is populated in run time with the addresses of resolved symbols.
It also contains important addresses that will be used in the symbols resolution process.

```console
$ objdump -d -j .got.plt a.out
Disassembly of section .got.plt:

0000000000403fe8 <_GLOBAL_OFFSET_TABLE_>:
  403fe8:       08 3e 40 00 00 00 00 00 00 00 00 00 00 00 00 00     .>@.............
        ...
  404000:       30 10 40 00 00 00 00 00                             0.@.....
```

Let's see how it works.

```
(gdb) b main
(gdb) disas main
Dump of assembler code for function main:
   0x0000000000401136 <+0>:     endbr64
   0x000000000040113a <+4>:     push   %rbp
   0x000000000040113b <+5>:     mov    %rsp,%rbp
   0x000000000040113e <+8>:     sub    $0x10,%rsp
   0x0000000000401142 <+12>:    mov    %edi,-0x4(%rbp)
   0x0000000000401145 <+15>:    mov    %rsi,-0x10(%rbp)
=> 0x0000000000401149 <+19>:    lea    0xeb4(%rip),%rax        # 0x402004
   0x0000000000401150 <+26>:    mov    %rax,%rdi
   0x0000000000401153 <+29>:    call   0x401040 <puts@plt>
   0x0000000000401158 <+34>:    mov    $0x0,%eax
   0x000000000040115d <+39>:    leave
   0x000000000040115e <+40>:    ret
End of assembler dump.

(gdb) disas 'puts@plt'
Dump of assembler code for function puts@plt:
   0x0000000000401040 <+0>:     endbr64
   0x0000000000401044 <+4>:     jmp    *0x2fb6(%rip)        # 0x404000 <puts@got.plt>
   0x000000000040104a <+10>:    nopw   0x0(%rax,%rax,1)
End of assembler dump.

(gdb) x/a 0x404000
0x404000 <puts@got.plt>:        0x401030

(gdb) x/a 0x403ff8
0x403ff8:       0x7ffff7fda2f0 <_dl_runtime_resolve_xsavec>

(gdb) n
Hello World!

(gdb) x/a 0x404000
0x404000 <puts@got.plt>:        0x7ffff7c87bd0 <__GI__IO_puts>
```

1. From `.text` section, `puts@plt` stub is called.
2. `puts@plt` jumps to 0x401030 stored in `puts@got.plt`.
3. 0x401030 is a part of the default stub in `.plt` section and jumps to 0x401020 that is the
   begining of the default stub.
4. The default stub transfers the control to `_dl_runtime_resolve()`.
5. The address stored in `puts@got.plt` is updated to `__GI__IO_puts`.

## PIE: Position Independent Executable

A PIE binary and all of its dependencies are loaded into random locations within virtual memory each
time the application is executed. This makes Return Oriented Programming (ROP) attacks much more
difficult to execute reliably.

```console
$ gcc -fPIE -pie -g -O0 main.c
```

Access to a data in an other segment is done via relative offset from RIP as follows.

```asm
mov    0x2eae(%rip),%eax
```

That means the relative position b/w some segments/sections (e.g. `.text` and `.data`) is determined
at build time.

## RELRO: RELocation Read-Only

Linux relies on PLT and GOT to resolve references to symbols in the shared libraries.

It implies the following two matters.

1. PLT needs to be located at a fixed offset from the `.text` section.
2. GOT needs to be located at a known static address in memory and needs to be writable due to its
   lazy bound nature.

That means there is a security concern that arbitrary code execution by modifying GOT entries.

RELRO ensures that the dynamic linker resolves all dynamically linked functions at the beginning of
the execution, and then makes the GOT read-only.

RELRO can be turned on when compiling a program by using the following options.

```console
$ gcc -g -O0 -Wl,-z,relro,-z,now -o <binary_name> <source_code>
```

It is possible to enable RELRO only for `.got` section by removing `-z,now` and it is called partial
RELRO.

With partial RELRO, we can protect the addresses of global variables in shared libraries for
example.

## References

- [ret2dl_resolve x64: Exploiting Dynamic Linking Procedure In x64 ELF Binaries](https://syst3mfailure.io/ret2dl_resolve/)
