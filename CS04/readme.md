# CA4
In CA4, we’re going to use Ansible to provision and manage the configurations for our VMs in an automated, scalable way, ensuring best practices for security and maintainability. Here’s a guide with justifications for each step taken to convert our improved CA3 Part 2 setup to use Ansible in CA4.
## Before
On CA3 we had multiple steps with errors that were fixed this week. Comparing to CA3 part2, we are changing the provisioner to Ansible. Regarding the provider for vagrant we used Vmware (Mac) or VirtualBox depending on the machine we were executing.
## Implementing Ansible
### Ansible Inevntory Setup
- **Goal:** Define our hosts in an Ansible inventory file, which is necessary for managing multiple servers.
- **Justification:** The inventory file allows Ansible to target each VM specifically, ensuring that tasks are organized for host1 (app VM) and host2 (db VM).

For this a **hosts.ini** file was created
````
[host1]
192.168.138.144 ansible_user=vagrant ansible_ssh_private_key_file=./my_vagrant_key

[host2]
192.168.138.143 ansible_user=vagrant ansible_ssh_private_key_file=./my_vagrant_key
````
This file specifies the IPs or hostnames for each VM, SSH users, and private keys. By using custom SSH keys, we maintain secure access.

### Playbook for Setting Up the Application and Database
- **Goal:** Use Ansible to deploy and configure the Building REST Services with Spring application on host1 and the H2 database in server mode on host2.
- **Justification:** Ansible ensures consistency and repeatability, so if the configuration or deployment fails, you can re-run the playbooks without unintended changes.

Created **host1_playbook.yml** and **host2_playbook.yml** Ansible playbooks
