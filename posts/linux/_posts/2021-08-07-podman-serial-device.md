---
title: Access serial device from rootless container
tags: sysadmin linux containers podman
---

Reading and writing a serial device from into a container is possible using [Podman](https://podman.io/) >3.2

<!--more-->

First, dont' forget to change the SELinux tag on the device (in the host) so that containers can use it:

```bash
$ sudo chcon -t container_file_t /mnt/engineering
```

Then, run the container with the following command:

```
$ podman run -it --device /dev/ttyUSB0:/dev/ttyUSB0:rw --group-add keep-groups espressif/idf

# from within the container
#\ id
uid=0(root) gid=0(root) groups=0(root),65534(nogroup)

#\ ls -lZ /dev/ttyUSB0 
crw-rw----. 1 nobody nogroup system_u:object_r:container_file_t:s0 188, 0 Aug  7 17:26 /dev/ttyUSB0
```
Podman command args:

* `--device`: Add the `/dev/ttyUSB0` host device to the container. The rigths can be specified (`rw` for read-write)
* `--group-add keep-groups`: If the user has access to the device with a group (`dialout` for instance), this is needed in order to access it from the container.

The `--group-add keep-groups` is currently only available using [crun](https://github.com/containers/crun) runtime.
{:.info}

If `ls -laZ /dev` launched into the container return lots of "???" in the permissions, that's very likely that the `/dev/ttyUSB0` doesn't have the good SELinux tag.
{:.info}
