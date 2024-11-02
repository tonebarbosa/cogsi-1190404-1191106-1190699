# CS 03
This report outlines the tasks for setting up build automation and a virtual development environment using Vagrant and Gradle for Part 1 of the assignment. The primary focus is automating essential tasks such as VM provisioning, project setup, running the server, unit testing, and creating backups.

## Part 1
###Setting Up Vagrant and Gradle for Build Automation
Vagrant Environment Setup
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
  config.vm.synced_folder "./data", "/home/vagrant/my-project/data"
  config.vm.provision "shell", path: "provision.sh"
end
````
Provisioning Script: A provision.sh file was created to automate the installation of essential software and dependencies, including Git, JDK, Maven, and Gradle. The script also cloned the project repository and built the project:

````
#!/bin/bash
sudo apt-get update
sudo apt-get install -y git openjdk-11-jdk maven gradle
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:/opt/gradle/bin

if [ ! -d "/home/vagrant/my-project" ]; then
  git clone https://github.com/YOUR-GROUP-REPO/cogsi2425-1234567.git /home/vagrant/my-project
fi
````

###Running the Server with Gradle
In the build.gradle file, we configured a custom Gradle task to execute the chat server application.

Applying the Application Plugin: We first ensured that the application plugin was applied, and specified the main class:

````
plugins {
    id 'application'
}

application {
    mainClass = 'basic_demo.App'
}
Creating a Custom Gradle Task: To run the chat server, we created a custom task runServer:

````
````
task runServer(type: JavaExec, dependsOn: classes) {
    group = "DevOps"
    description = "Launches a chat server to which the clients will connect"
    classpath = sourceSets.main.runtimeClasspath
    mainClass = 'basic_demo.ChatServerApp'
    args '59001'
}
````
###Adding Unit Tests and Configuring Gradle for Testing
We configured Gradle to support unit testing using JUnit.

Adding Dependencies: We added the JUnit library to our dependencies:

````
dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.7.0'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.7.0'
}
````
Creating a Test Class: A unit test was added in ChatServerAppTest.java to validate that the ChatServerApp instance initializes correctly:

````

import org.junit.Test;
import static org.junit.Assert.assertNotNull;

public class ChatServerAppTest {
    @Test
    public void testChatServerAppNotNull() {
        ChatServerApp chatServerApp = new ChatServerApp();
        assertNotNull(chatServerApp);
    }
}
````
Running Tests: We executed the test using Gradle’s default test task:
````
./gradlew test
````

###Creating a Backup Task with Gradle
To back up our source code, we created a Gradle task to copy the contents of the src directory to a backup folder.

Backup Task Using Copy Type: The following task was added to build.gradle to create a backup:

````
task createBackup(type: Copy) {
    from 'src'
    into 'backup'
}
````

###Archiving the Backup Using a Zip Task
To compress the backup, we created a Gradle task to zip the contents of the backup folder.

Zip Task: The createZipBackup task archives the backup directory:
````
task createZipBackup(type: Zip, dependsOn: createBackup) {
    from 'backup'
    archiveFileName = 'backup.zip'
    destinationDirectory = file('backup')
}
````
###Explanation of Gradle and JDK Toolchain
Gradle automatically manages the Java Development Kit (JDK) and toolchain. By using the javaToolchains feature, Gradle eliminates the need to manually install and configure specific JDK versions, ensuring compatibility across different environments.

Toolchain Configuration Check: We used the following command to confirm the toolchain settings:
````
gradle -q javaToolchain
````
This feature allows for consistent Java setup across team members’ environments, facilitating a more streamlined development process.
