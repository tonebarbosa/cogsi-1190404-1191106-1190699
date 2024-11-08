#!/bin/bash

sudo apt-get update
sudo apt-get install -y git openjdk-11-jdk maven

cat my_vagrant_key.pub >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

cd /home/vagrant
git clone https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git

cd CS01/tut-rest
./mvnw clean install -DskipTests
nohup java -jar target/*.jar --spring.datasource.url=jdbc:h2:tcp://192.168.33.10:9092/~/test &

while ! nc -z 192.168.33.10 9092; do
  sleep 1
done