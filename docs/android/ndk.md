# Android Native Development Kit (Android NDK)

## What is Android NDK?

Android NDK is a toolset that allows you to implement parts of your Android app using "native" code, typically written in C and C++.

## Core Components

### Compilers and Toolchains

Tools (like Clang and LLVM) that provide cross-compilation environment.

### Native System Headers

Access to low-level Android system libraries and kernel, such as bionic, libc++, linux uapi, and the JNI (Java Native Interface).

## Sysroot

Sysroot is a directory that contains the logical root structure of the target Android OS for compilation. It provides the necessary headers and libraries to build native code for a specific Android API level and architecture.

```
sysroot/
├── usr/
│   ├── include/                <-- [COMPILATION PHASE]
│   │   ├── stdio.h
│   │   ├── unistd.h
│   │   ├── linux/              <-- Sanitized Kernel UAPI (e.g., ioctl)
│   │   ├── sys/                <-- Bionic (C Library) POSIX headers
│   │   ├── android/            <-- Android-specific platform headers
│   │   └── c++/v1/             <-- LLVM libc++ standard headers
│   │
│   └── lib/                    <-- [LINKING PHASE]
│       ├── aarch64-linux-android/
│       │   ├── 21/             <-- API Level 21 (Lollipop) Stubs
│       │   │   ├── libc.so     <-- Stub (Symbols only, no code)
│       │   │   └── libc++.so
│       │   └── 34/             <-- API Level 34 (Android 14) Stubs
│       │       └── libvulkan.so
│       └── x86_64-linux-android/ <-- Different Arch Stubs
```

### Key Components Included

- **Kernel UAPI Headers**: Standard Linux kernel headers (linux/, asm/) required for userspace-to-kernel communication (e.g., ioctl, netlink).

- **Bionic C Library Headers**: Declarations for Android's standard C library (libc, libm, libdl).

- **C++ Standard Library (libc++)**: Headers and runtime support for the LLVM libc++ implementation.

- **Stub Shared Libraries (.so)**: Lightweight shared objects that contain only symbol information. They allow the linker to resolve functions that will be provided by the actual OS at runtime.
