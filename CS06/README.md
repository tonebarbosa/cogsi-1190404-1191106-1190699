# CA06 - Jenkins with Ansible

Jenkins is an open-source automation server used to build, test, and deploy software. It supports continuous integration (CI) and continuous delivery (CD) workflows, enabling developers to automate repetitive tasks in software development pipelines. With its plugin ecosystem, Jenkins integrates with various tools and platforms, making it highly customizable for diverse projects.

## Part 1

The goal for this part is to create a Jenkins pipeline to build and deploy the gradle version of REST application to a local virtual machine (VM) using Vagrant and Ansible, as CS03.

First, it was installed Jenkins and Ansible on the local machine.

We've created a Vagrantfile, where we defined two virtual machines, a "blue" one and a "green" one. The main purpose of it is to use the blue-green deployment strategy, where we have two identical environments, and we switch between them to deploy new versions of the application.
We've created two machines, provisioned using ansible, where we've installed Java, Gradle, H2. Also was setted up the app and defined the startup of the Spring app as a systemd service:

![img1](./images/img1.png)

To start these machines, as usual, we've used the command `vagrant up`.

The configuration was the same for both machines, the only difference was the port used by the app, 8080 for the blue machine and 8081 for the green machine.
The virtual machines were attributed with two static ips, so that when the ansible hosts need to be updated, the ip addresses don't change.

Then, we've created a Jenkinsfile, where the setup was to clone the repository, build the image, run the integration tests and archive the jar. Then, it was added a stage to ask if the app can be deployed to production, using the input directive.

![img2](./images/img2.png)

Finally, if the user approves, we use an ansible script to deploy the app to the green machine:
If the deployment fails, a rollback is executed to the green machine.

![img3](./images/img3.png)

Where the new Jar is copied to the specific folder of the green machine, and the systemd service is restarted. 

To finish, we added a post-action to see if the app is running correctly and generate a tag with a **stable version**.

![img4](./images/img4.png)