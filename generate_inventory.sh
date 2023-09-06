#!/bin/bash
IPs=$(terraform output instance_ips)
cat <<EOF > inventory.ini
[database_servers]
$(for ip in ${IPs}; do echo "server ansible_host=${ip}"; done)
EOF
