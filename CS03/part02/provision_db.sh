#!/bin/bash

sudo apt-get update
sudo apt-get install -y h2

nohup java -cp /usr/share/h2/lib/h2.jar org.h2.tools.Server -tcp -tcpAllowOthers -tcpPort 9092 &

sudo apt-get install -y ufw
sudo ufw allow from 192.168.33.11 to any port 9092 proto tcp
sudo ufw enable
