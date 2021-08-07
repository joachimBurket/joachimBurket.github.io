---
title: Access serial device from rootless container
tags: sysadmin linux containers podman
---

Reading and writing a serial device from into a container is possible using [Podman](https://podman.io/) >3.2

<!--more-->

First, change the SELinux tag on the device so that containers can use it:

```bash
$ sudo chcon -t container_file_t /mnt/engineering
```

Then, run the container with the following command:

```bash
$ podman run -it --device /dev/ttyUSB0:/dev/ttyUSB0:rw --group-add keep-groups espressif/idf
```

* `--device`: Add the `/dev/ttyUSB0` host device to the container. The rigths can be specified (`rw` for read-write)
* `--group-add keep-groups`: If the user has access to the device with a group (`dialout` for instance), this is needed in order to access it from the container.

The `--group-add keep-groups` is currently only available using [crun](https://github.com/containers/crun) runtime.
{:.warning}

