#!/bin/bash

# Check if the file path is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

# File path argument
file_path=$1

# Create IPSET blacklist
sudo ipset create blacklist hash:ip hashsize 1400000

# Read IP addresses from the file and add them to the blacklist
while IFS= read -r ip; do
    sudo ipset add blacklist "$ip"
done < "$file_path"

# Set up iptables to drop connections from IPs in the blacklist
sudo iptables -I INPUT -m set --match-set blacklist src -j DROP

# Save iptables configuration to persist after reboot
sudo iptables-save > /etc/iptables/rules.v4
