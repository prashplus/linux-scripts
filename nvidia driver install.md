# Automatic Install using PPA repository to install Nvidia Beta drivers

Using graphics-drivers PPA repository allows us to install bleeding edge Nvidia beta drivers at the risk of unstable system. To proceed first add the ppa:graphics-drivers/ppa repository into your system:

```bash
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
```

Next, identify your graphic card model and recommended driver:

```
$ ubuntu-drivers devices
== /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
modalias : pci:v000010DEd00001180sv00001458sd0000353Cbc03sc00i00
vendor   : NVIDIA Corporation
model    : GK104 [GeForce GTX 680]
driver   : nvidia-340 - third-party free
driver   : nvidia-390 - third-party free recommended
driver   : nvidia-387 - third-party free
driver   : nvidia-304 - distro non-free
driver   : nvidia-384 - third-party free
driver   : xserver-xorg-video-nouveau - distro free builtin

== cpu-microcode.py ==
driver   : intel-microcode - distro free
```

Same as with the above standard Ubuntu repository example, either install all recommended drivers automatically:

```
$ sudo ubuntu-drivers autoinstall
```

or selectively using the apt command. Example:

```
$ sudo apt install nvidia-390
```

Once done, reboot your system.