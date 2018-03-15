#!/bin/bash
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install rabbitmq-server
sudo apt-get -y install python-minimal
sudo apt-get -y install python-pip