#!/bin/bash
sudo apt-get update
sudo apt-get install -y nfs-kernel-server
sudo mkdir /nfs
sudo chown nobody:nogroup /nfs
#On server edit exports file
#nano /etc/exports
#add this line
#/nfs            *(rw,sync,no_subtree_check)
#
#On clinet
#apt-get install nfs-common
#mount 10.0.0.2:/nfs /nfs