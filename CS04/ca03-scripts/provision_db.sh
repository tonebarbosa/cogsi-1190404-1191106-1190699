#!/bin/bash

sudo apt-get update
sudo apt-get install -y h2

cat my_vagrant_key.pub >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys


nohup java -cp /usr/share/h2/lib/h2.jar org.h2.tools.Server -tcp -tcpAllowOthers -tcpPort 9092 &

sudo apt-get install -y ufw
sudo ufw allow from 192.168.33.11 to any port 9092 proto tcp
sudo ufw enable
