# CS 02
This report outlines the tasks for setting up build automation using Gradle as part of a two-part assignment. 
The first part focuses on automating essential tasks such as executing the server, testing, and creating backups. 
The second part covers converting a Maven-based REST service project to Gradle, building custom tasks, and handling integration testing. 
Additionally, this report discusses an alternative build automation tool and compares its features with Gradle.

## Part 1
###  Gradle Task to Execute the Server 
To run the server using Gradle, a custom task was created in the build.gradle file. This task will depend on the application plugin to simplify the running of Java applications.
First it was checked that the application plugin was applied and that the **mainClassName** was defined.
```
plugins {
    id 'application'
}
```
```
application{
    mainClass = 'basic_demo.App'
}
```
Then the task to execute the server was added
```
task runServer(type:JavaExec, dependsOn: classes){
    group = "DevOps"
    description = "Launches a chat server to which the clients will connect"
    classpath = sourceSets.main.runtimeClasspath
    mainClass = 'basic_demo.ChatServerApp'
    args '59001'
}
```
### Adding a Unit Test and Configuring Gradle
Gradle supports unit testing via the JUnit library. To do it, the following dependencies were added
```
dependencies {
    ...(others that already existed)

    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.7.0'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.7.0'
}
```
Then the class **ChatServerAppTest.java** was created and a unit test added
```
package basic_demo;

import org.junit.Test;

import static org.junit.Assert.assertNotNull;

public class ChatServerAppTest {

    @Test
    public void testChatServerAppNotNull() {
        ChatServerApp chatServerApp = new ChatServerApp();
        assertNotNull(chatServerApp);
    }
}
```
Then the test was executed with the default test task:
```
./gradlew test
```
### Backup Task using Copy Type
A backup task that copies the contents of the src folder to a backup folder was created and added to build.gradle.
```
task createBackup(type: Copy) {
    from 'src'
    into 'backup'
}
```
This task copies everything from the src folder into a new backup folder in the project directory.
### Archiving the Backup using Zip Task
To create a Zip file of the backup, a task of type Zip that depends on the **createBackup** task was created and added to build.gradle.
```
task createZipBackup(type: Zip, dependsOn: createBackup) {
    from 'backup'
    archiveFileName = 'backup.zip'
    destinationDirectory = file('backup')
}
```
This archives the contents of the backup folder into a file named **backup.zip**
### Explanation of Gradle and JDK Toolchain
Gradle comes with a built-in ability to manage the Java Development Kit (JDK) and toolchain. 
By default, Gradle uses the **javaToolchains** mechanism to automatically locate the JDK.

When running the command **gradle -q javaToolchain**, Gradle will provide details about the Java toolchain it is using. 
This feature eliminates the need to manually install or configure specific versions of the JDK.

## Part 2
to do
