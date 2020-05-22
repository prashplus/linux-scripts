#!/bin/bash
MIRROR=https://mirrors.estointernet.in/apache/hive/hive-3.1.2
VERSION=apache-hive-3.1.2-bin

#download hadoop, untar, put in /usr/local
cd /tmp
wget "$MIRROR/$VERSION".tar.gz
tar -xzf "$VERSION".tar.gz
mv  $VERSION /usr/local
rm "$VERSION".tar.gz