#!/bin/bash
echo "Starting provisioning..."
sudo apt-get update
sudo apt-get install -y git openjdk-11-jdk maven gradle

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:/opt/gradle/bin

if [ ! -d "/home/vagrant/cs03" ]; then
  git clone https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git /home/vagrant/cs03
fi

cd /home/vagrant/cs03/CS01/tut-rest

./mvnw clean install -DskipTests
./gradlew build

nohup java -jar target/*.jar &