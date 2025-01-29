# TrustZone

# SMC: Secure Monitor Call

SMC instruction is for entering Secure Monitor mode from EL1 (mode for kernel) to execute Secure
Monitor code. This is like a system call.

# OP-TEE

Operating system is running in TrustZone and it is providing services via SMC instruction. It is
like linux kernel is prividing its services as system call.

OP-TEE is a famous implementation of OS running in TrustZone.

```
                             +----------------------+
                             | EL0 (Trusted App)    |
                             +----------------------+
+--------------------+ smc   +----------------------+
| EL1 (Linux Kernel) |<---+  | EL1 (Trusted OS)     |
+--------------------+    |  +----------------------+
+--------------------+    |
| EL2 (Hypervisor)   |<-+ |
+--------------------+  | |
                        | |  +----------------------+
                        | +->| EL3 (Secure Monitor) |
                        +--->+----------------------+
                         smc
```
