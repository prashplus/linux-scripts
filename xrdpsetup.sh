#!/bin/bash
sudo apt-get update
sudo apt-get install -y xrdp
sudo apt-get install -y xfce4
sudo echo “xfce4-session” > ~/.xsession
sudo /etc/init.d/xrdp start
sudo /etc/init.d/xrdp status
