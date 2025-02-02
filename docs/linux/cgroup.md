# Control Group

cgroup is a mechanism to organize processes hierarchically and distribute system resources along the
hierarchy in a controlled and configurable manner.

## How to setup

The cgroup v2 hierarchy can be mounted with the following command.

```console
$ mount -t cgroup2 none $MOUNT_POINT
```

Also, you should configure `cgroup.subtree_control` to enable the controllers for child cgroups.

```console
$ echo +memory > /sys/fs/cgroup/cgroup.subtree_control
```

The above example enables memory controller.

Once all the expected controllers are configured, you can create new cgroup domain by creating new
directory as follows.

```console
$ mkdir -p /sys/fs/cgroup/system
```

Finally, you can register a process to the system domain with the following command.

```console
$ echo $$ | tee /sys/fs/cgroup/system/cgroup.procs
```

This example registers the current process to the system domain.
