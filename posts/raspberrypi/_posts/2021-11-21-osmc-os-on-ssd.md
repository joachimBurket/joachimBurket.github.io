---
title: OSMC OS on USB SSD disk
tags: raspberrypi osmc
---

As of now, the OSMC doesn't seems to support booting from an USB device (see [this post](https://discourse.osmc.tv/t/raspberrypi4-usb-boot/89268)). 
But putting the OS on the SSD is still a lot better for performances than on the SD Card.

OSMC provides an installer, which has an option telling to run OSMC from an USB Stick. Sadly, the installer is no longer available for Linux (see [this post](https://discourse.osmc.tv/t/missing-linux-installer-at-download-page/80993)).

In order to do this behaviour from a Linux OS:

1. Download the OSMC image (https://osmc.tv/download/ under "Disk Images")
2. Check the md5sum and untar the file:
    ```bash
    $ md5sum OSMC_TGT_rbp4_XXXXXXXX.img.gz
    $ gzip -d OSMC_TGT_rbp4_XXXXXXXX.img.gz
    ```
3. Install the file on an SD Card
     ```bash
     # Replace /dev/mmcblk0 by the device's path
     $ sudo dd if=Downloads/OSMC_TGT_rbp4_XXXXXXXX.img of=/dev/mmcblk0 bs=4M
     ```
4. Then, mount the created partition and add a `preseed.cfg` file into it:
    ```bash
    $ sudo mkdir /media/osmc_boot
    $ sudo mount /dev/mmcblk0p1 /media/osmc_boot
    $ vim /media/osmc_boot/preseed.cfg
    ```
    
    `preseed.cfg` file:
    
    ```
    d-i target/storage string usb
    d-i network/interface string eth
    d-i network/auto boolean true
    ```
    
    Finally unmount the SD Card and remove it
    
    ```bash
    $ sudo umount /dev/mmcblk0p1
    $ sudo rm -rf /media/osmc_boot
    ```
When this is done, plug in the SSD to the Raspberry Pi (with no other USB connected), put the SD Card on the Raspberry and turn it on. OSMC startup will begin, and will disclaim that the USB disk will be formatted. Wait the 60 seconds, and the filesystem should be installed on the SSD.
