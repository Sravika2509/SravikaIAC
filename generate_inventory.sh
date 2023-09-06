#!/bin/bash

# Specify the path to the SSH private key (provided by Jenkins or Terraform output).
SSH_PRIVATE_KEY_PATH="/var/jenkins_home/workspace/id_rsa"

# Set the Ansible SSH user to "ec2-user"
ANSIBLE_USER="ec2-user"

# Get the IP addresses of the EC2 instances from the Terraform output.
IPs=$(terraform output instance_ips)

# Initialize a counter variable
counter=1

# Create or overwrite the Ansible inventory file.
cat <<EOF > inventory.ini
[database_servers]
$(for ip in ${IPs}; do
  echo "server${counter} ansible_host=${ip} ansible_user=${ANSIBLE_USER} ansible_ssh_private_key_file=${SSH_PRIVATE_KEY_PATH}"
  ((counter++))  # Increment the counter
done)
EOF

echo "Ansible inventory file (inventory.ini) generated with SSH settings."
