# Encryption

## Keyring

Keyring is a security feature that stores sensitive information, such as
passwords and secrets, and allows applications to securely access it.

`keyctl` can be used to control the key management facility.

## dm-crypt

dm-crypt is one of the device-mapper targets. It provides transparent
encryption of block devices using the kernel crypto API.

The crypt block device can be created with `dmsetup` as follows.

```console
$ dmsetup create <new_device_name> --table "<start_sector> <length> crypt <cipher> <key> <iv_offset> <source_device_path> <offset>"
```

Here is how to set up a file as an encrypted vfat volume with dmsetup.

```console
$ dmFile=dmcrypt.img
$ dmName=dmcryptimg
$ dd if=/dev/zero of=$dmFile bs=1M count=512
$ losetup -f $dmFile
$ devFile=`losetup -a | grep $dmFile | awk '{print $1}' | sed 's/://g'`
$ dmsetup create $dmName --table "0 `blockdev --getsz $devFile` crypt aes-cbc-essiv:sha256 babebabebabebabebabebabebabebabe 0 $devFile 0"
$ mkfs.vfat /dev/mapper/$dmName
$ mkdir -p $dmName
$ mount /dev/mapper/$dmName $dmName
$ umount $dmName
$ dmsetup remove $dmName
$ mount $devFile $dmName
mount: /dmcryptimg: wrong fs type, bad option, bad superblock on /dev/loop0, missing codepage or helper program, or other error.
$ losetup -d $devFile
```

As you can see, the crypt block device (`/dev/mapper/dmcryptimg`) can be
mounted as vfat but the raw block device (`/dev/loop0`) can not be
mounted because whole block device is encrypted.

In the above example, the encryption key is directly specified on the
command line but it is insecure and should be avoided actually.

This is where the kernel keyring facility comes in. You can add a key to
a keyring with `keyctl` and specify the ID of the key as an argument of
`dmsetup`.

```console
$ dd if=/dev/random bs=32 count=1 iflag=fullblock 2>/dev/null | keyctl padd user dmcryptimgkey @s
223829668
$ keyctl search @s user dmcryptimgkey
223829668
$ dmsetup create $dmName --table "0 `blockdev --getsz $devFile` crypt aes-cbc-essiv:sha256 :32:user:dmcryptimgkey 0 $devFile 0"
```

## fscrypt

fscrypt is a linux native file encryption feature tightly coupled with
filesystem implementation.

Unlike dm-crypt, fscrypt operates at the filesystem level rather than at
the block device level. Except for filenames, fscrypt does not encrypt
filesystem metadata.

## References

- [Kernel Key Retention Service](https://www.kernel.org/doc/html/latest/security/keys/core.html)
- [Device Mapper: dm-crypt](https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/dm-crypt.html)
- [Filesystem-level encryption (fscrypt)](https://www.kernel.org/doc/html/latest/filesystems/fscrypt.html)
