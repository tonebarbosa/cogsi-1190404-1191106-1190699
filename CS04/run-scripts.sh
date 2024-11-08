#!/bin/bash

ansible-playbook start_vagrant.yml

ansible-playbook -i hosts.ini host1_playbook.yml
ansible-playbook -i hosts.ini host2_playbook.yml
ansible-playbook -i hosts.ini pam_playbook.yml
ansible-playbook -i hosts.ini user_management.yml
