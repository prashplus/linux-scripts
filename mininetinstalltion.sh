#!/bin/bash
sudo apt-get update
sudo apt-get install -y git
git clone git://github.com/mininet/mininet
cd mininet
git checkout -b 2.2.0 2.2.0
util/install.sh -nfv
sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils 
sudo apt-get install openvswitch-switch
sudo mn --test pingall
