# CS 03
This report outlines the tasks for setting up build automation and a virtual development environment using Vagrant and Gradle for Part 1 of the assignment. The primary focus is automating essential tasks such as VM provisioning, project setup, running the server, unit testing, and creating backups.

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

