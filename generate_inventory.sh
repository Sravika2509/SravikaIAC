#!/bin/bash

# Specify the path to the SSH private key (provided by Terraform output).
SSH_PRIVATE_KEY_PATH=".ssh/id_rsa"

# Set the Ansible SSH user to "ec2-user"
ANSIBLE_USER="ec2-user"

# Get the IP addresses of the EC2 instances from the Terraform output.
IPs=$(terraform output instance_ips)

# Create or overwrite the Ansible inventory file.
cat <<EOF > inventory.ini
[database_servers]
$(for ip in ${IPs}; do echo "server ansible_host=${ip} ansible_user=${ANSIBLE_USER} ansible_ssh_private_key_file=${SSH_PRIVATE_KEY_PATH}"; done)
EOF

echo "Ansible inventory file (inventory.ini) generated with SSH settings."
