# CS 03
This report details the setup and configuration of a Vagrant-managed virtual environment for deploying a Spring Boot application with an H2 database. The assignment is divided into two parts: Part 1 establishes a single VM with all necessary dependencies, automates application builds, and provides access from the host machine. Part 2 expands to a multi-VM setup, separating the application and database on two VMs with secure networking and automated dependency checks.

## Part 1
### Setting Up Vagrant VM
To create a virtual environment, we used Vagrant with VirtualBox as the provider to configure and provision the necessary dependencies. Here’s a step-by-step overview:

Vagrantfile Configuration: We created a Vagrantfile to define the virtual machine’s specifications, including:

The OS: ubuntu/bionic64 (Ubuntu 18.04).
Port Forwarding: Port 8080 (for accessing the Spring app) and 9000 (for accessing the chat server).
Provisioning: Set up a shell script to install dependencies and initialize the project.

````
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 9000, host: 9000

  config.vm.provision "shell", path: "provision.sh"

end
````
### Provisioning Script 
A provision.sh file was created to automate the installation of essential software and dependencies, including Git, JDK, Maven, and Gradle. The script also cloned the project repository and built the project:

````
#!/bin/bash
sudo apt-get update
sudo apt-get install -y git openjdk-11-jdk maven gradle

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:/opt/gradle/bin

if [ ! -d "/home/vagrant/cs03" ]; then
  git clone https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git /home/vagrant/cs03
fi
````

### Build and Execute Projects
In the provision.sh, were added the following commands to build and run the projects:
````
# Navigate to project directory
cd /home/vagrant/cs03

./mvnw clean install -DskipTests
./gradlew build

# Run Spring app in the background
nohup java -jar target/*.jar &
````

### Interaction with Applications
- Access to the Spring app is done at http://localhost:8080 from the host browser.
- We ran the chat application server in the VM by SSHing into the VM (vagrant ssh) and executing the server script. Then we ran client scripts on the host machine and connected them to the server’s IP.

### Persistent H2 Database Configuration
A synced folder was added to the Vagrantfile to persist H2 data:
````
config.vm.synced_folder "./data", "/home/vagrant/cs03/data"
````
Then we updated the Spring app’s **application.properties** to store data in /home/vagrant/cs03/data

## Part 2
### Modify Vagrantfile for Two VMs
Vagrantfile was updated to create two VMs, one for the app and another for the database
````
Vagrant.configure("2") do |config|
  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/bionic64"
    app.vm.network "forwarded_port", guest: 8080, host: 8080
    app.vm.provision "shell", path: "provision_app.sh"
  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/bionic64"
    db.vm.network "private_network", ip: "192.168.33.10"
    db.vm.provision "shell", path: "provision_db.sh"
  end
end
````
### Provision Scripts for VMs
- Created **provision_app.sh** to set up the Spring application VM:
````
#!/bin/bash

sudo apt-get update
sudo apt-get install -y git openjdk-11-jdk maven

cd /home/vagrant
git clone https://github.com/tonebarbosa/cogsi-1190404-1191106-1190699.git

cd CS01/tut-rest
./mvnw clean install -DskipTests
nohup java -jar target/*.jar --spring.datasource.url=jdbc:h2:tcp://192.168.33.10:9092/~/test &
````
- Created **provision_db.sh** to set up the database VM:
````
#!/bin/bash

sudo apt-get update
sudo apt-get install -y h2

nohup java -cp /usr/share/h2/lib/h2.jar org.h2.tools.Server -tcp -tcpAllowOthers -tcpPort 9092 &
````
### SSH Key Setup
Generated SSH keys for secure access and replaced Vagrant’s default keys on Vagrantfile
````
config.ssh.private_key_path = "./my_vagrant_key"
````
### Database Startup Check
In **provision_app.sh**, we added a check to ensure the app VM waits for the db VM to be ready before starting:
````
while ! nc -z 192.168.33.10 9092; do
  sleep 1
done
````
### Firewall Configuration on db VM
We added firewall rules in provision_db.sh to restrict access:
````
sudo apt-get install -y ufw
sudo ufw allow from 192.168.33.11 to any port 9092 proto tcp
sudo ufw enable
````
